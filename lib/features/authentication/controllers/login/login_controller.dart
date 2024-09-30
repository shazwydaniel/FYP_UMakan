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
    email.text = localStorage.read('REMEMBER_ME_EMAIL') ?? ''; // Fallback to empty string if null
    password.text = localStorage.read('REMEMBER_ME_PASSWORD') ?? ''; // Fallback to empty string if null
    super.onInit();
  }

  Future<bool> emailAndPasswordLogIn() async {
    try {
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        // TFullScreenLoader.stopLoading();
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

      // Removed by chatgpt
      AuthenticatorRepository.instance.screenRedirect();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }
}
