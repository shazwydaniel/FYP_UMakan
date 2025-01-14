import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authentication/screens/register/register.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class UserRepository extends GetxController {
  static UserRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Register ------------------------------------
  Future<void> saveUserRecord(UserModel user) async {
    try {
      await _db.collection('Users').doc(user.id).set(user.toJson());
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw TPlatformException(e.code).message;
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<UserModel> getUserRecord(String userId) async {
    final doc = await _db.collection('Users').doc(userId).get();
    return UserModel.fromMap(doc.data()!);
  }

  // Update User Record ------------------------------------
  Future<void> updateUserRecord(UserModel user) async {
    try {
      await calculateAndUpdateAllowance(user.id);
      await _db.collection('Users').doc(user.id).update(user.toJson());
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.message}');
      throw TFirebaseAuthException(e.code);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } on FormatException catch (_) {
      print('FormatException occurred');
      throw const TFormatException();
    } on PlatformException catch (e) {
      print('PlatformException: ${e.message}');
      throw TPlatformException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Get User Data ------------------------------------
  Future<UserModel> getUserData(String userId) async {
    try {
      final doc = await _db.collection('Users').doc(userId).get();
      final data = doc.data();

      if (data == null) {
        throw 'User record does not exist';
      }

      return UserModel.fromMap(data);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Fetch User Details Based on User ID ------------------------------------
  Future<UserModel> fetchUserDetails() async {
    try {
      final userId = AuthenticatorRepository.instance.authUser?.uid;

      if (userId == null) {
        throw 'No authenticated user found';
      }

      await calculateAndUpdateAllowance(userId);

      final documentSnapshot = await _db.collection('Users').doc(userId).get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Error fetching user details: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Update User Data in Firestore ------------------------------------
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
      print('Updating additionalAllowance: ${updatedUser.additionalAllowance}');
      print('Updating additionalExpense: ${updatedUser.additionalExpense}');
      await _db
          .collection("Users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Update Any Field in Specific Users Collection ------------------------------------
  Future<void> createSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticatorRepository.instance.authUser?.uid)
          .set(json, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Update Any Field in Specific Users Collection ------------------------------------
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Users")
          .doc(AuthenticatorRepository.instance.authUser?.uid)
          .update(json);
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Remove All User Data from Firestore ------------------------------------
  Future<void> removeUserRecord(String userId) async {
    try {
      await _db.collection("Users").doc(userId).delete();
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to add or update a field in a document ------------------------------------
  Future<void> addFieldToUser(
      String userId, Map<String, dynamic> newField) async {
    try {
      await _db.collection('Users').doc(userId).update(newField);
    } catch (e) {
      print('Failed to add/update field: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to fetch the user's role ------------------------------------
  Future<String?> fetchUserRole(String uid) async {
    try {
      debugPrint("Fetching role for UID: $uid");

      // Check the "Users" collection
      DocumentSnapshot userDocSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(uid)
          .get();

      if (userDocSnapshot.exists) {
        debugPrint("User document found in 'Users' collection");
        Map<String, dynamic>? userData =
            userDocSnapshot.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey('Role')) {
          String? role = userData['Role'];
          debugPrint("Role found in 'Users': $role");
          return role;
        } else {
          debugPrint("Role field is missing in the user document");
          throw Exception("Role field is missing in the user document");
        }
      }

      // Check the "Authority" collection
      DocumentSnapshot authorityDocSnapshot = await FirebaseFirestore.instance
          .collection('Authority')
          .doc(uid)
          .get();

      if (authorityDocSnapshot.exists) {
        debugPrint("User document found in 'Authority' collection");
        return 'Authority'; // Assume all users in "Authority" are authorities
      }

      // Check the "Vendors" collection
      DocumentSnapshot vendorDocSnapshot =
          await FirebaseFirestore.instance.collection('Vendors').doc(uid).get();

      if (vendorDocSnapshot.exists) {
        debugPrint("User document found in 'Vendors' collection");
        return 'Vendor'; // Assume all users in "Vendors" are vendors
      }

      // Check the "SupportOrganisation" collection
      DocumentSnapshot supportOrgDocSnapshot = await FirebaseFirestore.instance
          .collection('SupportOrganisation')
          .doc(uid)
          .get();

      if (supportOrgDocSnapshot.exists) {
        debugPrint("User document found in 'Support Organisation' collection");
        return 'Support Organisation'; // Assume all users in "Support Organisation" are Support Organisation
      }

      // Check the "Admin" collection
      DocumentSnapshot adminDocSnapshot =
          await FirebaseFirestore.instance.collection('Admins').doc(uid).get();

      if (adminDocSnapshot.exists) {
        debugPrint("User document found in 'Admin' collection");
        return 'Admin'; // Assume all users in "Vendors" are vendors
      }

      // If the document does not exist in any collection
      debugPrint(
          "No user document found in 'Users', 'Authority', or 'Vendors'");
      throw Exception("User not found in any collection");
    } catch (e) {
      debugPrint("Error fetching user role: $e");
      rethrow; // Re-throw the error for further handling
    }
  }

  // Method to update the telegramHandle field for a specific user ------------------------------------
  Future<void> updateTelegramHandle(
      String userId, String telegramHandle) async {
    try {
      await _db
          .collection("Users")
          .doc(userId)
          .update({'telegramHandle': telegramHandle});
      print("Telegram handle updated successfully for user $userId");
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print('Unknown error updating telegram handle: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to fetch the telegramHandle for a specific user ------------------------------------
  Future<String?> getTelegramHandle(String userId) async {
    try {
      final doc = await _db.collection("Users").doc(userId).get();
      if (doc.exists) {
        final data = doc.data();
        return data?['telegramHandle'] ?? ''; // Return empty string if not set
      } else {
        throw 'User document does not exist';
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print('Unknown error fetching telegram handle: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Modify calculateAndUpdateAllowance to account for daily logs
  Future<void> calculateAndUpdateAllowance(String userId) async {
    try {
      // Fetch user and latest daily data
      final userDoc = await _db.collection('Users').doc(userId).get();
      final userData = userDoc.data();

      if (userData == null) throw 'User not found';

      final now = DateTime.now();
      final recommendedMoneyAllowance = userData['recommendedMoneyAllowance'] ?? 0.0;
      final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
      final elapsedDays = now.day;

      // Calculate daily allowance based on historical data
      final dailyAllowance = recommendedMoneyAllowance / daysInMonth;
      final updatedAllowance = recommendedMoneyAllowance - (elapsedDays * dailyAllowance);

      // Ensure updated allowance does not go below 0
      final safeAllowance = updatedAllowance < 0 ? 0 : updatedAllowance;

      // Update user record
      await _db.collection('Users').doc(userId).update({
        'updatedRecommendedAllowance': safeAllowance,
      });
      print("Updated recommended allowance: $safeAllowance");
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print('Error calculating allowance: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to log daily financial data into MoneyJournalHistory  ------------------------------------
  Future<void> logDailyData(String userId, Map<String, dynamic> dailyData) async {
    try {
      final now = DateTime.now();
      final year = now.year.toString();
      final month = now.month.toString().padLeft(2, '0');
      final day = now.day.toString().padLeft(2, '0');

      final dailyDoc = _db
          .collection('Users')
          .doc(userId)
          .collection('MoneyJournalHistory')
          .doc(year)
          .collection('Months')
          .doc(month)
          .collection('Days')
          .doc(day);

      await dailyDoc.set(dailyData, SetOptions(merge: true));
      print("Daily data logged successfully for $year/$month/$day");
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print('Error logging daily data: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to fetch the latest logged day's data  ------------------------------------
  Future<Map<String, dynamic>> getLastLoggedData(String userId) async {
    try {
      final now = DateTime.now();
      final year = now.year.toString();
      final month = now.month.toString().padLeft(2, '0');

      final daysRef = _db
          .collection('Users')
          .doc(userId)
          .collection('MoneyJournalHistory')
          .doc(year)
          .collection('Months')
          .doc(month)
          .collection('Days');

      final lastDaySnapshot =
          await daysRef.orderBy('day', descending: true).limit(1).get();

      if (lastDaySnapshot.docs.isNotEmpty) {
        return lastDaySnapshot.docs.first.data();
      } else {
        return {};
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print('Error fetching last logged data: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to update actualRemainingFoodAllowance dynamically ------------------------------------
  Future<void> updateRemainingAllowance(String userId) async {
    try {
      // Fetch the latest daily log
      final lastLog = await getLastLoggedData(userId);

      if (lastLog.isNotEmpty) {
        // Calculate based on last log
        final additionalAllowance = lastLog['additionalAllowance'] ?? 0.0;
        final additionalExpense = lastLog['additionalExpense'] ?? 0.0;
        final monthlyAllowance = lastLog['monthlyAllowance'] ?? 0.0;
        final monthlyCommittments = lastLog['monthlyCommittments'] ?? 0.0;

        final remaining = (monthlyAllowance + additionalAllowance) -
            (monthlyCommittments + additionalExpense);

        // Update the field in Firestore
        await _db.collection('Users').doc(userId).update({
          'actualRemainingFoodAllowance': remaining,
        });
        print("Updated actualRemainingFoodAllowance: $remaining");
      } else {
        print("No daily log found for $userId.");
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code).message;
    } catch (e) {
      print('Error updating remaining allowance: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}
