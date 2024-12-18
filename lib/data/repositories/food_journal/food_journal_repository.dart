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
      // Fetch the food journal collection for the user
      final querySnapshot = await _db
          .collection('Users')
          .doc(userId)
          .collection('food_journal')
          .get();

      // Parse the data into a list of JournalItem objects
      return querySnapshot.docs.map((doc) {
        final data = doc.data();

        // Ensure all numeric fields are properly cast to their expected types
        if (data['calories'] is double) {
          data['calories'] =
              (data['calories'] as double).toInt(); // Cast to int
        }

        if (data['price'] is double) {
          data['price'] = (data['price'] as double).toInt(); // Cast to int
        }

        return JournalItem.fromMap(data, doc.id);
      }).toList();
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

  Future<String> getCafeWithMostFiveStars(String vendorId) async {
    try {
      // Reference to the Vendor document
      final vendorDoc = _db.collection('Vendors').doc(vendorId);

      // Fetch all cafes under the vendor
      final cafesSnapshot = await vendorDoc.collection('Cafe').get();

      // Map to store the count of 5-star reviews per café
      final Map<String, int> cafeFiveStarCounts = {};

      // Iterate over each café
      for (var cafeDoc in cafesSnapshot.docs) {
        final cafeData = cafeDoc.data();
        final String? cafeName = cafeData['cafeName'];

        // Skip if the café name is not available
        if (cafeName == null) continue;

        // Fetch all reviews under the current café
        final reviewsSnapshot =
            await cafeDoc.reference.collection('Reviews').get();

        // Count 5-star reviews for the current café
        int fiveStarCount = 0;
        for (var reviewDoc in reviewsSnapshot.docs) {
          final reviewData = reviewDoc.data();
          final rating = reviewData['rating'];

          if (rating == 5) {
            fiveStarCount++;
          }
        }

        print("$cafeName has $fiveStarCount five-star reviews");

        // Add the count to the map
        cafeFiveStarCounts[cafeName] = fiveStarCount;
      }

      print("Cafe Five-Star Counts: $cafeFiveStarCounts");

      // If no 5-star reviews are found, return 'None'
      if (cafeFiveStarCounts.isEmpty) {
        return 'None';
      }

      // Find the café with the most 5-star reviews
      String mostFiveStarCafe = '';
      int maxFiveStarCount = 0;

      cafeFiveStarCounts.forEach((cafe, count) {
        if (count > maxFiveStarCount) {
          mostFiveStarCafe = cafe;
          maxFiveStarCount = count;
        }
      });

      print("Cafe with Most 5 Stars: $mostFiveStarCafe");
      return mostFiveStarCafe;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw Exception("Failed to fetch 5-star reviews: ${e.message}");
    } catch (e) {
      print("Error fetching most 5-star reviews: $e");
      return 'Error';
    }
  }

  Future<String> getCafeWithMostOneStars(String vendorId) async {
    try {
      // Reference to the Vendor document
      final vendorDoc = _db.collection('Vendors').doc(vendorId);

      // Fetch all cafes under the vendor
      final cafesSnapshot = await vendorDoc.collection('Cafe').get();

      // Map to store the count of 1-star reviews per café
      final Map<String, int> cafeOneStarCounts = {};

      // Iterate over each café
      for (var cafeDoc in cafesSnapshot.docs) {
        final cafeData = cafeDoc.data();
        final String? cafeName = cafeData['cafeName']; // Get the café name

        if (cafeName == null) {
          print("Skipping cafe with missing name: ${cafeDoc.id}");
          continue; // Skip cafes with no name
        }

        // Fetch all reviews under the current café
        final reviewsSnapshot =
            await cafeDoc.reference.collection('Reviews').get();

        // Count 1-star reviews for the current café
        int oneStarCount = 0;
        for (var reviewDoc in reviewsSnapshot.docs) {
          final reviewData = reviewDoc.data();
          final rating = reviewData['rating'];

          if (rating == 1) {
            oneStarCount++;
          }
        }

        print("$cafeName has $oneStarCount one-star reviews");

        // Add the count to the map
        cafeOneStarCounts[cafeName] = oneStarCount;
      }

      // If no 1-star reviews are found, return 'None'
      if (cafeOneStarCounts.isEmpty) {
        return 'None';
      }

      // Find the café with the most 1-star reviews
      String mostOneStarCafe = 'None';
      int maxOneStarCount = 0;

      cafeOneStarCounts.forEach((cafe, count) {
        if (count > maxOneStarCount) {
          mostOneStarCafe = cafe;
          maxOneStarCount = count;
        }
      });

      print("Cafe with Most 1 Stars: $mostOneStarCafe");
      return mostOneStarCafe;
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw Exception("Failed to fetch 1-star reviews: ${e.message}");
    } catch (e) {
      print("Error fetching most 1-star reviews: $e");
      return 'Error';
    }
  }

  Future<Map<String, dynamic>> analyzeFoodLogs(String userId) async {
    // Initialize frequency maps
    Map<String, int> foodFrequency = {};
    Map<String, int> locationFrequency = {};

    try {
      // Reference to the 'food_journal' subcollection under the specific user
      final foodJournalRef =
          _db.collection('Users').doc(userId).collection('food_journal');

      // Fetch all logged food documents
      final snapshot = await foodJournalRef.get();

      if (snapshot.docs.isEmpty) {
        print("No food logs found for user: $userId");
        return {'foodFrequency': {}, 'locationFrequency': {}};
      }

      // Loop through each logged food document
      for (var doc in snapshot.docs) {
        final data = doc.data();

        // Extract itemId and cafeId
        String itemId = data['entry_ID'] ?? '';
        String cafeId = data['cafeLocation'] ?? ''; //or cafe

        if (itemId.isNotEmpty) {
          // Increment food count
          foodFrequency[itemId] = (foodFrequency[itemId] ?? 0) + 1;
        }

        if (cafeId.isNotEmpty) {
          // Increment location count
          locationFrequency[cafeId] = (locationFrequency[cafeId] ?? 0) + 1;
        }
      }

      print("Food Frequency: $foodFrequency");
      print("Location Frequency: $locationFrequency");

      return {
        'foodFrequency': foodFrequency,
        'locationFrequency': locationFrequency,
      };
    } catch (e) {
      print("Error fetching food logs: $e");
      return {'foodFrequency': {}, 'locationFrequency': {}};
    }
  }
}
