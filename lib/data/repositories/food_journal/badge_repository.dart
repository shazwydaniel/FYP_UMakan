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
  final userController = UserController.instance;

  Future<void> initializeAchievements(String userId) async {
    final userRef = _db.collection('Users').doc(userId);
    final badgesCollection = userRef.collection('Badges');

    try {
      // Initialize the streakCount
      await badgesCollection.doc('streakCount').set({'value': 0});

      // Initialize the badges
      final badges = [
        {'badgeName': 'Initiator', 'status': 'locked', 'unlockedAt': null},
        {'badgeName': 'Novice', 'status': 'locked', 'unlockedAt': null},
        {'badgeName': 'Hero', 'status': 'locked', 'unlockedAt': null},
        {'badgeName': 'Champion', 'status': 'locked', 'unlockedAt': null},
      ];

      final batch = FirebaseFirestore.instance.batch();
      for (var badge in badges) {
        final badgeDoc = badgesCollection.doc(badge['badgeName']);
        batch.set(badgeDoc, badge);
      }

      await batch.commit();
      print('Achievements with streakCount initialized successfully.');
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
      print('Error initializing achievements: $e');
    }
  }

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

  Future<void> updateStreakAndCheckBadges(int completedDays) async {
    final userId = userController.user.value.id; // Get the current user ID

    try {
      // Update the streak count in Firebase
      await updateStreakCount(userId, completedDays);

      // Check and unlock badges based on streak milestones
      if (completedDays == 1) {
        await checkAndUnlockBadgeBasedOnStreak(userId, 'Initiator', 1);
      } else if (completedDays == 3) {
        await checkAndUnlockBadgeBasedOnStreak(userId, 'Novice', 3);
      } else if (completedDays == 7) {
        await checkAndUnlockBadgeBasedOnStreak(userId, 'Hero', 7);
      } else if (completedDays == 30) {
        await checkAndUnlockBadgeBasedOnStreak(userId, 'Champion', 30);
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
    } catch (e) {
      print('Error updating streak and checking badges: $e');
    }
  }
}
