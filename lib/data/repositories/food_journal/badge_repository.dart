import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';

class BadgeRepository {
  static BadgeRepository get instance => BadgeRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> updateStreakCount(String userId, int dayCount) async {
    final streakDocRef = _db
        .collection('Users')
        .doc(userId)
        .collection('Badges')
        .doc('streakCount');

    try {
      //Get the current streak
      final currentStreak = await streakDocRef.get();
      int currentStreakCount = 0;
      if (currentStreak.exists) {
        currentStreakCount = currentStreak.get('value') ?? 0;
      }

      if (currentStreakCount < dayCount) {
        await streakDocRef.update({'value': FieldValue.increment(1)});
      } else {
        await streakDocRef.set({'value': 0});
      }

      print('Streak count updated successfully.');
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error updating streak count: $e');
    }
  }

  Future<void> checkAndUnlockBadgeBasedOnStreak(
      String userId, String badgeName, int requiredStreak) async {
    final streakDocRef = _db
        .collection('Users')
        .doc(userId)
        .collection('Badges')
        .doc('streakCount');

    final badgeDocRef =
        _db.collection('Users').doc(userId).collection('Badges').doc(badgeName);

    try {
      final streakSnapshot = await streakDocRef.get();
      final streakCount = streakSnapshot.data()?['value'] ?? 0;

      final badgeSnapshot = await badgeDocRef.get();
      final badgeStatus = badgeSnapshot.data()?['status'] ?? 'locked';

      if (streakCount >= requiredStreak && badgeStatus == 'locked') {
        await badgeDocRef.update({
          'status': 'unlocked',
          'unlockedAt': DateTime.now().toIso8601String(),
        });
        print('$badgeName badge unlocked!');
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Error checking/unlocking badge: $e');
    }
  }

  Future<Map<String, int>> fetchMealCounts(String userId) async {
    final userRef = _db.collection('Users').doc(userId);
    final badgesDoc = userRef.collection('Badges').doc('mealCounts');

    try {
      final snapshot = await badgesDoc.get();
      if (snapshot.exists) {
        return {
          'breakfast': snapshot.data()?['breakfast'] ?? 0,
          'lunch': snapshot.data()?['lunch'] ?? 0,
          'dinner': snapshot.data()?['dinner'] ?? 0,
          'others': snapshot.data()?['others'] ?? 0,
        };
      } else {
        // Initialize mealCounts if it doesn't exist
        await badgesDoc.set({
          'breakfast': 0,
          'lunch': 0,
          'dinner': 0,
          'others': 0,
        });
        return {'breakfast': 0, 'lunch': 0, 'dinner': 0, 'others': 0};
      }
    } catch (e) {
      print('Error fetching meal counts: $e');
      return {'breakfast': 0, 'lunch': 0, 'dinner': 0, 'others': 0};
    }
  }

  Future<void> updateMealCounts(String userId, Map<String, int> counts) async {
    final userRef = _db.collection('Users').doc(userId);
    final badgesDoc = userRef.collection('Badges').doc('mealCounts');

    try {
      await badgesDoc.update({
        'breakfast': counts['breakfast'] ?? 0,
        'lunch': counts['lunch'] ?? 0,
        'dinner': counts['dinner'] ?? 0,
        'others': counts['others'] ?? 0,
      });
      print('Meal counts updated successfully.');
    } catch (e) {
      print('Error updating meal counts: $e');
    }
  }

  Future<void> incrementMealCount(String userId, String mealType) async {
    final badgesDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Badges')
        .doc('mealCounts');

    try {
      await badgesDoc.update({
        mealType: FieldValue.increment(1),
      });
      print("$mealType count incremented in Firebase.");
    } catch (e) {
      print("Error updating $mealType count: $e");
    }
  }

  //----------------LATEST-------------------//

  Future<void> initializeAchievements(String userId) async {
    final achievementsDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Achievements')
        .doc('current');

    try {
      final snapshot = await achievementsDoc.get();
      if (!snapshot.exists) {
        // Initialize default achievements
        await achievementsDoc.set({
          "initiator": false,
          "novice": false,
          "hero": false,
          "champion": false,
        });
        print("Achievements document initialized.");
      } else {
        print("Achievements document already exists.");
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Error initializing achievements: $e");
    }
  }

  Future<void> initializeMealStates(String userId) async {
    final mealStatesDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('MealStates')
        .doc('current');

    try {
      final snapshot = await mealStatesDoc.get();
      if (!snapshot.exists) {
        // Initialize default meal states
        await mealStatesDoc.set({
          "hadBreakfast": false,
          "hadLunch": false,
          "hadDinner": false,
          "hadOthers": false,
        });
        print("MealStates document initialized.");
      } else {
        print("MealStates document already exists.");
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print("Error initializing meal states: $e");
    }
  }
}
