import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authentication/screens/register/verify_email.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/model/vendor_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:fyp_umakan/vendor_navigation_menu.dart';
import 'package:get/get.dart';

class VendorController extends GetxController {
  static VendorController get instance => Get.find();

  final VendorRepository vendorRepository = Get.put(VendorRepository());

  Rx<Vendor> vendor = Vendor.empty().obs;
  Rx<CafeDetails> cafe = CafeDetails.empty().obs;
  final cafes = <CafeDetails>[].obs; // Observable list of cafes

  //String get currentVendorId => vendor.value.id;

  final privacyPolicy = true.obs;

  //Variables for Register
  final vendorEmail = TextEditingController();
  final vendorPassword = TextEditingController();
  final vendorName = TextEditingController();
  final contactInfo = TextEditingController();

  //Variable for Add Cafe
  final cafeName = TextEditingController();
  final cafeImage = TextEditingController();
  final cafeLocation = TextEditingController();
  final openingTime = TextEditingController();
  final closingTime = TextEditingController();

  //Variable for Update Cafe
  final cafeNameUpdate = TextEditingController();
  final cafeImageUpdate = TextEditingController();
  final cafeLocationUpdate = TextEditingController();
  final openingTimeUpdate = TextEditingController();
  final closingTimeUpdate = TextEditingController();

  //Variables for Menu Item
  final itemName = TextEditingController();
  final itemPrice = TextEditingController();
  final itemCalories = TextEditingController();
  final itemImage = TextEditingController();
  final itemLocation = TextEditingController();
  final role = 'Vendors';

  //To add
  GlobalKey<FormState> vendorFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> cafeFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> itemFormKey = GlobalKey<FormState>();

  //To update
  GlobalKey<FormState> updateCafeKey = GlobalKey<FormState>();

  final profileLoading = false.obs;
  // Store userId after login
  late String userId;
  final NetworkManager networkManager = Get.put(NetworkManager());

  String get currentUserId => vendor.value.id;

  @override
  void onInit() {
    super.onInit();
    fetchUserRecord();
    print(
        "VendorController initialized for user ID: ${FirebaseAuth.instance.currentUser?.uid}");
    try {
      userId = getCurrentUserId();
      print("Current user id: $userId");
    } catch (e) {
      print("Error: $e");
    }
  }

  // Fetch User Record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await vendorRepository.fetchUserDetails();
      print("Fetched user: ${user.vendorName}"); // Debug print
      this.vendor(user);
      vendor(user);
    } catch (e) {
      print("Error fetching vendor: $e");
      vendor(Vendor.empty());
    } finally {
      //profileLoading.value = false;
    }
  }

  String getCurrentUserId() {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Return the user ID (UID)
      return user.uid;
    } else {
      // Handle the case when there is no user logged in
      throw Exception('No user is currently signed in');
    }
  }

  // Register method in VendorController
  Future<void> register() async {
    try {
      // Check internet connection
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.');
        return;
      }

      // Form Validation
      if (!vendorFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      // Register User in Firebase Auth + User Data
      final userCredential = await VendorRepository.instance.registerVendor(
        vendorEmail.text.trim(),
        vendorPassword.text.trim(),
        vendorName.text.trim(),
        contactInfo.text.trim(),
      );

      // Save User Data in Firebase Firestore
      final newUser = Vendor(
        id: userCredential.user!.uid, // Get the user ID from the credential
        vendorName: vendorName.text.trim(),
        vendorEmail: vendorEmail.text.trim(),
        contactInfo: contactInfo.text.trim(),
        password: vendorPassword.text.trim(),
        role: role,
      );

      // Save User Data in Firestore
      await vendorRepository.createVendor(newUser);

      // Store the userId for later use
      userId = newUser.id;

      Get.to(() => VerifyEmailScreen(email: vendorEmail.text.trim()));
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error during Vendor Registration: $e");
      TLoaders.errorSnackBar(title: 'Yikes!', message: e.toString());
    }
  }

  //Add Cafe
  Future<void> addCafe(String vendorId, String? imageUrl) async {
    try {
      // Create a map for the cafe data
      Map<String, dynamic> cafeData = {
        'cafeName': cafeName.text.trim(),
        'cafeLocation': cafeLocation.text.trim(),
        'openingTime': openingTime.text.trim(),
        'closingTime': closingTime.text.trim(),
        if (imageUrl != null)
          'cafeImage': imageUrl, // Add image URL if available
      };

      // Add the cafe details to Firestore
      await vendorRepository.addCafeToVendor(vendorId, cafeData);

      // Update the CafeDetails model in the controller
      cafe.update((cafe) {
        if (cafe != null) {
          cafe.name = cafeName.text.trim();
          cafe.location = cafeLocation.text.trim();
          cafe.openingTime = openingTime.text.trim();
          cafe.closingTime = closingTime.text.trim();
          cafe.image =
              imageUrl ?? ''; // Use an empty string if imageUrl is null
        }
      });

      // Print confirmation
      print('Cafe added with image URL: $imageUrl');
    } catch (e) {
      // Handle error
      print('Error adding cafe: $e');
    }
  }

  // Fetch
  Future<void> fetchCafesForVendor(String vendorId) async {
    try {
      // Fetch list of cafes from the repository
      final cafeList = await vendorRepository.getCafesForVendor(vendorId);

      // Check if cafes were found
      if (cafeList.isNotEmpty) {
        // Assign the fetched cafes to the observable list
        cafes.assignAll(cafeList);
        print("Cafes fetched: ${cafes.length}");
      } else {
        print('No cafes found for vendor');
        cafes.clear(); // Optionally clear if no cafes are found
      }
    } catch (e) {
      print('Error fetching cafes: $e');
      cafes.clear(); // Handle error by clearing the list
    }
  }

  // Get total cafe
  Future<int> getTotalCafe(String vendorId) async {
    try {
      final cafeList = await vendorRepository.getCafesForVendor(vendorId);

      if (cafeList.isNotEmpty) {
        cafes.assignAll(cafeList);
      }
      return cafes.length;
    } catch (e) {
      throw ('Error fetching length: $e');
    }
  }

  //Delete Cafe
  Future<void> deleteCafe(String vendorId, String cafeId) async {
    try {
      await vendorRepository.deleteCafe(vendorId, cafeId);
      cafes.removeWhere((cafe) => cafe.id == cafeId); // Update local list
    } catch (e) {
      // Handle error, maybe show a snackbar or dialog
      Get.snackbar('Error', 'Could not delete cafe: $e');
    }
  }

  Future<void> updateCafeDetails(
      String vendorId, String cafeId, String? imageUrl) async {
    try {
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.');
        return;
      }

      if (!updateCafeKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      Map<String, dynamic> updatedData = {
        'cafeName': cafeNameUpdate.text.trim(),
        'cafeLocation': cafeLocationUpdate.text.trim(),
        'closingTime': closingTimeUpdate.text.trim(),
        'openingTime': openingTimeUpdate.text.trim(),
      };

      if (imageUrl != null) {
        updatedData['cafeImage'] = imageUrl;
      }

      await vendorRepository.updateSingleFieldCafe(
          updatedData, vendorId, cafeId);

      cafe.value.name = cafeNameUpdate.text.trim();
      cafe.value.location = cafeLocationUpdate.text.trim();
      cafe.value.openingTime = openingTimeUpdate.text.trim();
      cafe.value.closingTime = closingTimeUpdate.text.trim();
      cafe.value.image = imageUrl ?? '';

      TLoaders.successSnackBar(
          title: 'Success!', message: "Your cafe details have been updated!");
      Get.off(() => const VendorNavigationMenu());
    } catch (e) {
      debugPrint("Error updating cafe: $e");
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  Future<String> uploadImage(
      File imageFile, String vendorId, String cafeName) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
            'cafe_images/$vendorId/$cafeName/${DateTime.now().toIso8601String()}',
          );

      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Image upload failed.');
    }
  }
}
