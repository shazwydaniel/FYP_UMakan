import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
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
      return CafeDetails.fromMap(doc.data()!, doc.id);
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
      final querySnapshot = await _db
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Items')
          .get();

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
      print('Unknown error: $e');
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
          .map((doc) => CafeDetails.fromMap(doc.data(), doc.id))
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
}
