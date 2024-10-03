import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
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

  //Variables for Register
  final vendorEmail = TextEditingController();
  final vendorPassword = TextEditingController();
  final vendorName = TextEditingController();
  final contactInfo = TextEditingController();

  //Variable for Cafe
  final cafeName = TextEditingController();
  final cafeLogo = TextEditingController();
  final cafeLocation = TextEditingController();

  //Variables for Menu Item
  final itemName = TextEditingController();
  final itemPrice = TextEditingController();
  final itemCalories = TextEditingController();
  final itemImage = TextEditingController();
  final itemLocation = TextEditingController();
  final role = 'Vendors';

  GlobalKey<FormState> vendorFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> cafeFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> itemFormKey = GlobalKey<FormState>();

  final profileLoading = false.obs;
  // Store userId after login
  late String userId;
  final NetworkManager networkManager = Get.put(NetworkManager());

  String get currentUserId => vendor.value.id;

  @override
  void onInit() {
    super.onInit();
    // Get the current user ID when the controller is initialized
    userId = getCurrentUserId();
    print("Current user id: ${userId}");
    fetchUserRecord();
  }

  // Fetch User Record
  Future<void> fetchUserRecord() async {
    try {
      profileLoading.value = true;
      final user = await vendorRepository.fetchUserDetails();
      print("Fetched user: ${user.vendorName}"); // Debug print
      this.vendor(user);
    } catch (e) {
      print("Error fetching vendor: $e");
      vendor(Vendor.empty());
    } finally {
      profileLoading.value = false;
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
  Future<void> addCafe(String vendorId) async {
    try {
      // Create a map for the cafe data
      Map<String, dynamic> cafeData = {
        'cafeName': cafeName.text.trim(),
        'cafeLocation': cafeLocation.text.trim(),
      };

      // Add the cafe details to Firestore
      await vendorRepository.addCafeToVendor(vendorId, cafeData);

      // Update the CafeDetails model in the controller
      cafe.update((cafe) {
        if (cafe != null) {
          cafe.name = cafeName.text.trim();
          cafe.location = cafeLocation.text.trim();
        }
      });

      // Print confirmation
      print('Cafe added!');
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
}
