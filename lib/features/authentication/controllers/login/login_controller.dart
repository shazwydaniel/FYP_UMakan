import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ??
        ''; // Fallback to empty string if null
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ??
        ''; // Fallback to empty string if null
    super.onInit();
  }

  Future<bool> emailAndPasswordLogIn() async {
    try {
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        return false;
      }

      // Remember Me
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login Using Email and Password
      final userCredentials = await AuthenticatorRepository.instance
          .loginWithEmailandPassword(email.text.trim(), password.text.trim());

      AuthenticatorRepository.instance.screenRedirect();
      return true;
    } on FirebaseAuthException catch (e) {
      // Handle specific FirebaseAuthException errors
      if (e.code == 'wrong-password') {
        Get.snackbar(
          "Login Failed",
          "The password you entered is incorrect.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      } else if (e.code == 'user-not-found') {
        Get.snackbar(
          "Login Failed",
          "No user found with this email.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
        );
      }
      return false;
    } catch (e) {
      // Generic error handling
      Get.snackbar(
        "Login Failed",
        "Password incorrect. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
      );
      return false;
    }
  }
}
