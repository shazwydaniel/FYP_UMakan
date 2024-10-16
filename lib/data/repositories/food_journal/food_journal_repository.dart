import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';

class FoodJournalRepository {
  static FoodJournalRepository get instance => FoodJournalRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize the money journal for a user
  Future<void> initializeUserJournal(String userId) async {
    try {
      final docRef = _db
          .collection('Users')
          .doc(userId)
          .collection('food_journal')
          .doc('food_journal_entries');
      await docRef.set({'initialized': true},
          SetOptions(merge: true)); // Ensure the document is created
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Add New Expense to Money Journal
  Future<void> addFood(String userId, Map<String, dynamic> foodData) async {
    try {
      final docRef =
          _db.collection('Users').doc(userId).collection('food_journal').doc();

      // Print the expense data being added
      print('Adding food: $foodData');

      await docRef.set({
        'entry_ID': docRef.id,
        ...foodData,
      });
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (e) {
      throw TPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }
}
