import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/register/verify_email.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/utils/popups/full_screen_loader.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';

class RegisterController extends GetxController {
  static RegisterController get instance => Get.find();

  // Variables
  final hidePassword = true.obs;
  final privacyPolicy = true.obs;
  final fullName = TextEditingController();
  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final phoneNumber = TextEditingController();
  final matricsNumber = TextEditingController();
  final gender = TextEditingController();
  final accommodation = TextEditingController();
  final monthlyAllowance = TextEditingController();
  final monthlyCommittments = TextEditingController();
  final vehicle = TextEditingController();
  final maritalStatus = TextEditingController();
  final childrenNumber = TextEditingController();
  final height = TextEditingController();
  final weight = TextEditingController();
  final birthdate = TextEditingController();
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final role = "Student";

  // Store userId after registration
  late String userId;
  final NetworkManager networkManager = Get.put(NetworkManager());
  final UserRepository userRepository = Get.put(UserRepository());

  // Register
  Future<void> register() async {
    try {
      //Start loading
      //TFullScreenLoader.openLoadingDialog(
      //  "Processing Your request", TImages.loading);

      //Check internet connection
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.');
        return;
      }

      // Form Validation
      if (!registerFormKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      // Privacy Policy Check
      if (!privacyPolicy.value) {
        TLoaders.errorSnackBar(
            title: 'Privacy Policy',
            message: 'You need to accept the privacy policy to proceed.');
        return;
      }

      // Register User in Firebase Auth + User Data
      final userCredential = await AuthenticatorRepository.instance
          .registerWithEmailandPassword(
              email.text.trim(), password.text.trim());

      // Default values for age and status
      int defaultAge = 0; // Replace with actual logic if needed
      int defaultStatus = 0; // Replace with actual logic if needed

      // Save User Data in Firebase Firestore
      final newUser = UserModel(
        id: userCredential.user!.uid,
        fullName: fullName.text.trim(),
        username: username.text.trim(),
        email: email.text.trim(),
        password: password.text.trim(),
        phoneNumber: phoneNumber.text.trim(),
        matricsNumber: matricsNumber.text.trim(),
        gender: gender.text.trim(),
        accommodation: accommodation.text.trim(),
        vehicle: vehicle.text.trim(),
        maritalStatus: maritalStatus.text.trim(),
        childrenNumber: childrenNumber.text.trim(),
        monthlyAllowance: monthlyAllowance.text.trim(),
        monthlyCommittments: monthlyCommittments.text.trim(),
        height: height.text.trim(),
        weight: weight.text.trim(),
        birthdate: birthdate.text.trim(),
        age: defaultAge,
        status: defaultStatus,
        role: role,
      );

      //Save User Data in Firestore
      await userRepository.saveUserRecord(newUser);

      //Remove Loader
      //TFullScreenLoader.stopLoading();

      //Show success Message
      TLoaders.successSnackBar(
          title: 'Congratulations',
          message: "Your account has been created! Verify email to continue.");

      // Store the userId for later use
      userId = newUser.id;

      //Move to Verify Email Screen
      //if (kDebugMode) {
      //print("Navigating to VerifyEmailScreen");
      //}
      Get.to(() => VerifyEmailScreen(email: email.text.trim()));
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error during registration: $e");
      TLoaders.errorSnackBar(title: 'Yikes!', message: e.toString());
    }
  }
}
