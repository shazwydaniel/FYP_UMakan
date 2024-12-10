import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';

class FoodJournalRepository {
  static FoodJournalRepository get instance => FoodJournalRepository();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Initialize the food journal for a user
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

  // Add New Meal to Food Journal
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

  Future<List<JournalItem>> getFoodJournalItem(String userId) async {
    try {
      final querySnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('food_journal')
          .get();

      return querySnapshot.docs
          .map((doc) => JournalItem.fromMap(doc.data(), doc.id))
          .toList();
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

  Future<void> deleteItem(String vendorId, String cafeId) async {
    try {
      await _db
          .collection('Users')
          .doc(vendorId)
          .collection('food_journal')
          .doc(cafeId)
          .delete();
      // Optionally handle any additional logic, like updating state
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
      // Handle any errors
      throw Exception('Failed to delete cafe: $e');
    }
  }

  Future<Map<String, int>> getCafeLogsByVendor(String vendorId) async {
    try {
      final querySnapshot = await _db.collection('Users').get();

      final Map<String, int> cafeLogs = {};

      for (var userDoc in querySnapshot.docs) {
        final journalSnapshot = await _db
            .collection('Users')
            .doc(userDoc.id)
            .collection('food_journal')
            .get();

        // Iterate through the food journal entries
        for (var journalDoc in journalSnapshot.docs) {
          final data = journalDoc.data();

          // Ensure the item belongs to the given vendorId
          if (data['vendorId'] == vendorId && data['cafe'] != null) {
            final String cafeName = data['cafe'];

            // Increment count for the cafe
            cafeLogs[cafeName] = (cafeLogs[cafeName] ?? 0) + 1;
          }
        }
      }

      print("Cafe Logs for vendorId $vendorId: $cafeLogs");
      return cafeLogs;
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
      print("Error fetching cafe logs: $e");
      throw Exception("Failed to fetch cafe logs.");
    }
  }
}
