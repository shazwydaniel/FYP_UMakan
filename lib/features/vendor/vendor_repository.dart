import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/features/vendor/model/vendor_model.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/firebase_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/format_exceptions.dart';
import 'package:fyp_umakan/utils/exceptions/platform_exceptions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VendorRepository {
  static VendorRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> registerVendor(String email, String password,
      String vendorName, String contactInfo) async {
    try {
      // Create vendor user account
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password, // Vendor might set their own password later
      );

      // Set vendor role in Firestore
      await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(userCredential.user!.uid)
          .set({
        'Vendor Name': vendorName,
        'Contact Info': contactInfo,
        'Vendor Email': email,
        'Role': 'Vendors',
      });

      // Return the UserCredential upon successful registration
      return userCredential;
    } catch (e) {
      // Handle the error and rethrow or return a default value
      print('Error: $e');
      // Optionally rethrow the error or handle it in a way that suits your app
      throw e; // Re-throwing the error to maintain the Future<UserCredential> return type
    }
  }

  // Fetch User Details Based on User ID ------------------------------------
  Future<Vendor> fetchUserDetails() async {
    try {
      final documentSnapshot = await _db
          .collection('Vendors')
          .doc(AuthenticatorRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return Vendor.fromSnapshot(documentSnapshot);
      } else {
        return Vendor.empty();
      }
    } on FirebaseException catch (e) {
      print('FirebaseException: ${e.message}');
      throw TFirebaseException(e.code);
    } catch (e) {
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> createVendor(Vendor vendor) async {
    try {
      await _db.collection('Vendors').doc(vendor.id).set(vendor.toJson());
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

  Future<void> addCafeToVendor(
      String vendorId, Map<String, dynamic> cafeData) async {
    try {
      final cafeRef = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc();

      await cafeRef.set({
        'cafe_ID': cafeRef.id,
        ...cafeData,
      });

      print('Cafe added to vendor successfully!');
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

  Future<void> addItemToCafe(
      String vendorId, String cafeId, Map<String, dynamic> itemData) async {
    try {
      final itemRef = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Items')
          .doc();

      await itemRef.set({
        'item_ID': itemRef.id,
        ...itemData,
      });
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

  Future<Vendor> getVendorById(String vendorId) async {
    try {
      final doc = await _db.collection('Vendors').doc(vendorId).get();
      return Vendor.fromMap(doc.data()!, doc.id);
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

  Future<CafeDetails> getCafeById(String vendorId, String cafeId) async {
    try {
      final doc = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .get();
      return CafeDetails.fromMap(doc.data()!, doc.id, vendorId);
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

  Future<List<CafeItem>> getItemsForCafe(String vendorId, String cafeId) async {
    try {
      // Debug: Print vendorId and cafeId
      print('Fetching items for vendor: $vendorId, cafe: $cafeId');

      final querySnapshot = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Items')
          .get();

      // Debug: Print raw Firestore snapshot
      print(
          'Firestore raw data: ${querySnapshot.docs.map((doc) => doc.data())}');

      return querySnapshot.docs
          .map((doc) => CafeItem.fromMap(doc.data(), doc.id))
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
      print('Error in getItemsForCafe: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<CafeDetails>> getCafesForVendor(String vendorId) async {
    try {
      final querySnapshot = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .get();

      return querySnapshot.docs
          .map((doc) => CafeDetails.fromMap(doc.data(), doc.id, vendorId))
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

  Future<List<Vendor>> getAllVendors() async {
    try {
      final querySnapshot = await _db.collection('Vendors').get();
      return querySnapshot.docs
          .map((doc) => Vendor.fromMap(doc.data()!, doc.id))
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

  Future<int> getCafeItemsCount(String vendorId, String cafeId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Items')
          .get();

      return querySnapshot.size; // Returns the number of documents
    } on FirebaseException catch (e) {
      print('Error: ${e.message}');
      throw 'Failed to get cafe items count';
    }
  }

  Future<String> fetchUserRole(String uid) async {
    try {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('Vendors').doc(uid).get();
      return doc['Role']; // Fetch and return the user's role
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
      print('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteCafe(String vendorId, String cafeId) async {
    try {
      await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .delete();
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

  Future<List<CafeDetails>> getAllCafes() async {
    try {
      final snapshot = await _db
          .collection('Vendors')
          .doc(VendorController.instance.getCurrentUserId())
          .collection('Cafe')
          .get();

      print(
          "Number of cafes fetched: ${snapshot.docs.length}"); // Debug log for number of cafes
      return snapshot.docs.map((doc) {
        print("Cafe data: ${doc.data()}"); // Debug log for each cafe document
        return CafeDetails.fromMap(
            doc.data()!, doc.id, VendorController.instance.getCurrentUserId());
      }).toList();
    } catch (e) {
      // Handle error (e.g., logging, rethrowing, etc.)
      return [];
    }
  }

  Future<List<CafeDetails>> getAllCafesFromAllVendors() async {
    List<CafeDetails> allCafes =
        []; // Initialize an empty list to hold all cafes

    try {
      // First, get all vendors
      final vendorSnapshot = await _db.collection('Vendors').get();

      // Iterate through each vendor
      for (var vendorDoc in vendorSnapshot.docs) {
        // For each vendor, get their cafes
        final cafeSnapshot = await vendorDoc.reference.collection('Cafe').get();

        // Map each cafe document to a CafeDetails object and add to the allCafes list
        allCafes.addAll(cafeSnapshot.docs.map((doc) {
          return CafeDetails.fromMap(doc.data()!, doc.id, vendorDoc.id);
        }));
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
      // Handle any errors
      print("Error fetching cafes from all vendors: $e");
      throw Exception('Failed to delete cafe: $e');
    }
    return allCafes; // Return the combined list of cafes
  }

  Future<void> addAdvertisementToCafe(
      String vendorId, String cafeId, Map<String, dynamic> advertData) async {
    try {
      final advertRef = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Advertisements')
          .doc();

      await advertRef.set({
        'Advertisement_ID': advertRef.id,
        ...advertData,
      });
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

  Future<List<Advertisement>> getAllAdvertisementsFromAllCafes() async {
    List<Advertisement> allAdvertisements =
        []; // Initialize an empty list to hold all advertisements

    try {
      // First, get all vendors
      final vendorSnapshot = await _db.collection('Vendors').get();

      // Iterate through each vendor
      for (var vendorDoc in vendorSnapshot.docs) {
        // For each vendor, get their cafes
        final cafeSnapshot = await vendorDoc.reference.collection('Cafe').get();

        // Iterate through each cafe
        for (var cafeDoc in cafeSnapshot.docs) {
          // For each cafe, get their advertisements
          final adSnapshot =
              await cafeDoc.reference.collection('Advertisements').get();

          // Map each advertisement document to an Advertisement object and add to the allAdvertisements list
          allAdvertisements.addAll(adSnapshot.docs.map((doc) {
            return Advertisement.fromMap(
                doc.data() as Map<String, dynamic>, doc.id);
          }));
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
      // Handle any errors
      print("Error fetching advertisements from all cafes: $e");
      throw Exception('Failed to fetch advertisements: $e');
    }

    return allAdvertisements; // Return the combined list of advertisements
  }

  Future<List<Advertisement>> getAllAdvertisementsForVendor(
      String vendorId) async {
    List<Advertisement> allAdvertisements = [];

    try {
      // Get cafes for the specific vendor
      final cafeSnapshot = await _db
          .collection('Vendors')
          .doc(vendorId) // Filter by the specific vendor's ID
          .collection('Cafe')
          .get();

      // Iterate through each cafe of the vendor
      for (var cafeDoc in cafeSnapshot.docs) {
        // For each cafe, get their advertisements
        final adSnapshot =
            await cafeDoc.reference.collection('Advertisements').get();

        // Map each advertisement document to an Advertisement object and add to the allAdvertisements list
        allAdvertisements.addAll(adSnapshot.docs.map((doc) {
          return Advertisement.fromMap(
              doc.data() as Map<String, dynamic>, doc.id);
        }));
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
      // Handle any errors
      print("Error fetching advertisements for the specific vendor: $e");
      throw Exception('Failed to fetch advertisements: $e');
    }

    return allAdvertisements; // Return the list of advertisements for the specific vendor
  }

  Future<List<CafeItem>> getAllItemsFromAllCafes() async {
    List<CafeItem> allItems =
        []; // Initialize an empty list to hold all advertisements

    try {
      // First, get all vendors
      final vendorSnapshot = await _db.collection('Vendors').get();

      // Iterate through each vendor
      for (var vendorDoc in vendorSnapshot.docs) {
        // For each vendor, get their cafes
        final cafeSnapshot = await vendorDoc.reference.collection('Cafe').get();

        // Iterate through each cafe
        for (var cafeDoc in cafeSnapshot.docs) {
          // For each cafe, get their items
          final adSnapshot = await cafeDoc.reference.collection('Items').get();

          // Map each advertisement document to an Items object and add to the allAdvertisements list
          allItems.addAll(adSnapshot.docs.map((doc) {
            return CafeItem.fromMap(doc.data() as Map<String, dynamic>, doc.id);
          }));
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
      // Handle any errors
      print("Error fetching advertisements from all cafes: $e");
      throw Exception('Failed to fetch advertisements: $e');
    }

    return allItems; // Return the combined list of advertisements
  }

  // Update Any Field in Specific Users Collection ------------------------------------
  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Vendors")
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

  // Update Any Field in Specific Users Collection ------------------------------------
  Future<void> updateSingleFieldAdvert(Map<String, dynamic> json,
      String vendorId, String cafeId, String adId) async {
    try {
      await _db
          .collection("Vendors")
          .doc(vendorId)
          .collection("Cafe")
          .doc(cafeId)
          .collection("Advertisements")
          .doc(adId)
          .update(json);
      print("Advertisement updated successfully!");
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
      print("Error updating: $e");
      throw Exception('Failed to update advertisements: $e');
    }
  }

  Future<void> deleteAd(String vendorId, String cafeId, String adId) async {
    try {
      await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection("Advertisements")
          .doc(adId)
          .delete();
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
      throw Exception('Failed to delete ad: $e');
    }
  }

  // Update Any Field in Specific Users Collection ------------------------------------
  Future<void> updateSingleFieldCafe(
      Map<String, dynamic> json, String vendorId, String cafeId) async {
    try {
      await _db
          .collection("Vendors")
          .doc(vendorId)
          .collection("Cafe")
          .doc(cafeId)
          .update(json);
      print("Cafe Details updated successfully!");
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
      print("Error updating: $e");
      throw Exception('Failed to update cafe: $e');
    }
  }

  Future<void> updateSingleMenuItem(
    Map<String, dynamic> json,
    String vendorId,
    String cafeId,
    String itemId,
  ) async {
    try {
      await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Items')
          .doc(itemId)
          .update(json);

      print('Menu item updated in Firestore');
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
      print("Error updating: $e");
      throw Exception('Failed to update item: $e');
    }
  }
}
