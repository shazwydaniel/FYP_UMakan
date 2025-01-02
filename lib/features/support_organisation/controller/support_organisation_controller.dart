import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/support_organisation/support_organisation_repository.dart';
import 'package:fyp_umakan/features/support_organisation/model/support_organisation_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';

class SupportOrganisationController extends GetxController {
  static SupportOrganisationController get instance => Get.find();

  final SupportOrganisationRepository _repository = SupportOrganisationRepository();

  // Rx variable for organisation data
  final organisation = Rxn<SupportOrganisationModel>();

  // Form key for validation
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController organisationNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();

  // Reactive dropdown values
  final location = 'In Campus'.obs; // Default to "In Campus"
  final activeStatus = 'Active'.obs; // Default to "Active"
  final hidePassword = true.obs;
  final profilePicture = 'assets/images/default_profile_icon.png'.obs; // Default profile picture

  // Dropdown options
  final List<String> locationOptions = ['In Campus', 'Outside Campus'];
  final List<String> statusOptions = ['Active', 'Non-operational'];

  // Privacy policy agreement
  final privacyPolicy = false.obs;

  // Method to register a new Support Organisation
  Future<void> registerOrganisation(SupportOrganisationModel org) async {
    try {
      await _repository.createSupportOrganisation(org);
      organisation.value = org;
    } catch (e) {
      print('Error registering organisation: $e');
      rethrow;
    }
  }

  // Method to fetch existing Support Organisation data
  Future<void> fetchOrganisation(String id) async {
    try {
      final fetchedOrg = await _repository.getSupportOrganisation(id);
      if (fetchedOrg != null) {
        organisation.value = fetchedOrg;
      }
    } catch (e) {
      print('Error fetching organisation: $e');
      rethrow;
    }
  }

  // Method to fetch all Support Organisations
  Future<List<SupportOrganisationModel>> fetchAllOrganisations() async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('SupportOrganisation')
          .get();

      return querySnapshot.docs.map((doc) {
        return SupportOrganisationModel.fromMap(doc.id, doc.data());
      }).toList();
    } catch (e) {
      print('Error fetching all organisations: $e');
      rethrow;
    }
  }

  // Method to pick a profile picture
  Future<void> pickProfilePicture(String organisationId) async {
    try {
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        // Automatically upload the selected image to Firebase
        final uploadedImageUrl = await uploadImage(File(image.path), organisationId);

        // Update the profilePicture with the Firebase URL
        profilePicture.value = uploadedImageUrl;

        // Update the profile picture in Firestore
        if (organisation.value != null) {
          final updatedOrg = organisation.value!.copyWith(profilePicture: uploadedImageUrl);
          await _repository.createSupportOrganisation(updatedOrg);
        }
      }
    } catch (e) {
      print('Error picking or uploading profile picture: $e');
    }
  }

  // Method to upload a profile picture to Firebase Storage
  Future<String> uploadImage(File imageFile, String organisationId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'organisation_images/$organisationId/${DateTime.now().toIso8601String()}');

      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl; // Return the URL to store in Firestore
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Image upload failed.');
    }
  }

  // Form submission handler
  Future<void> register() async {
    try {
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        Get.snackbar('No Internet', 'Please check your connection.');
        return;
      }

      // Form Validation
      if (!formKey.currentState!.validate()) {
        Get.snackbar('Invalid Input', 'Please fill all required fields.');
        return;
      }

      // Authenticate and create user in Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // Prepare Support Organisation data
      final org = SupportOrganisationModel(
        id: userCredential.user!.uid, // Use Firebase UID
        organisationName: organisationNameController.text.trim(),
        email: emailController.text.trim(),
        contactNumber: contactNumberController.text.trim(),
        profilePicture: 'assets/images/default_profile_icon.png', // Default profile picture
        location: location.value,
        activeStatus: activeStatus.value,
        role: 'Support Organisation',
      );

      // Save to Firestore
      await registerOrganisation(org);

      Get.snackbar('Success', 'Support Organisation registered successfully');
    } catch (e) {
      // Log and show error
      print('Error during registration: $e');
      Get.snackbar('Error', 'Failed to register support organisation.');
    }
  }

  @override
  void onClose() {
    // Dispose controllers when not needed
    organisationNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    contactNumberController.dispose();
    super.onClose();
  }
}