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
      final documentSnapshot = await _db
          .collection('Users')
          .doc(AuthenticatorRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return UserModel.fromSnapshot(documentSnapshot);
      } else {
        return UserModel.empty();
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Update User Data in Firestore ------------------------------------
  Future<void> updateUserDetails(UserModel updatedUser) async {
    try {
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

  // Remoce All User Data from Firestore ------------------------------------
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

  // Method to add or update a field in a document
  Future<void> addFieldToUser(
      String userId, Map<String, dynamic> newField) async {
    try {
      await _db.collection('Users').doc(userId).update(newField);
    } catch (e) {
      print('Failed to add/update field: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  // Method to fetch the user's role
  Future<String?> fetchUserRole(String uid) async {
    try {
      debugPrint("Fetching role for UID: $uid");

      // Check the "Users" collection
      DocumentSnapshot userDocSnapshot =
          await FirebaseFirestore.instance.collection('Users').doc(uid).get();

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
      DocumentSnapshot authorityDocSnapshot =
          await FirebaseFirestore.instance.collection('Authority').doc(uid).get();

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

      // If the document does not exist in any collection
      debugPrint("No user document found in 'Users', 'Authority', or 'Vendors'");
      throw Exception("User not found in any collection");
    } catch (e) {
      debugPrint("Error fetching user role: $e");
      rethrow; // Re-throw the error for further handling
    }
  }
}
