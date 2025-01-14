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
        // Initialize default achievements and lastUnlocked fields
        await achievementsDoc.set({
          "initiator": false,
          "novice": false,
          "hero": false,
          "champion": false,
          "lastUnlocked": {
            "initiator": null,
            "novice": null,
            "hero": null,
            "champion": null,
          },
        });
        print("Achievements document initialized.");
      } else {
        // Check for missing fields and add them if necessary
        final data = snapshot.data()!;
        final Map<String, Object?> updates =
            {}; // Declare as Map<String, Object?>

        // Check if achievements fields are missing
        if (!data.containsKey("initiator")) updates["initiator"] = false;
        if (!data.containsKey("novice")) updates["novice"] = false;
        if (!data.containsKey("hero")) updates["hero"] = false;
        if (!data.containsKey("champion")) updates["champion"] = false;

        // Check if lastUnlocked field is missing or incomplete
        if (!data.containsKey("lastUnlocked")) {
          updates["lastUnlocked"] = {
            "initiator": null,
            "novice": null,
            "hero": null,
            "champion": null,
          };
        } else {
          final Map<String, dynamic> lastUnlocked =
              Map<String, dynamic>.from(data["lastUnlocked"]);
          if (!lastUnlocked.containsKey("initiator")) {
            lastUnlocked["initiator"] = null;
          }
          if (!lastUnlocked.containsKey("novice")) {
            lastUnlocked["novice"] = null;
          }
          if (!lastUnlocked.containsKey("hero")) {
            lastUnlocked["hero"] = null;
          }
          if (!lastUnlocked.containsKey("champion")) {
            lastUnlocked["champion"] = null;
          }
          updates["lastUnlocked"] = lastUnlocked;
        }

        // Update the document if there are missing fields
        if (updates.isNotEmpty) {
          await achievementsDoc.update(updates);
          print(
              "Achievements document updated with missing fields from Badge Repo.");
        } else {
          print(
              "Achievements document already exists and is complete from Badge Repo.");
        }
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
        print("MealStates document initialized from Badge Repo.");
      } else {
        print("MealStates document already exists from Badge Repo.");
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

  Future<void> initializeStreaks(String userId) async {
    final streaksDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('streaks')
        .doc('current');

    try {
      final snapshot = await streaksDoc.get();
      if (!snapshot.exists) {
        // Initialize default streaks
        await streaksDoc.set({
          "streakCount": 0,
        });
        print("Streaks document initialized. Badge Repo Streaks Initilizer");
      } else {
        print("Streaks document already exists.Badge Repo Streaks Initilizer");
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw Exception('FirebaseException: ${e.message}');
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const FormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw Exception('PlatformException: ${e.message}');
    } catch (e) {
      print("Error initializing streaks: $e");
    }
  }
}
