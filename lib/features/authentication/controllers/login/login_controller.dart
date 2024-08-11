import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController{
  // Variables
  final rememberMe = false.obs;
  final hidePassword = true.obs;
  final localStorage = GetStorage();
  final email = TextEditingController();
  final password = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  Future<bool> emailAndPasswordLogIn() async {
    try{
      // Form Validation
      if(!loginFormKey.currentState!.validate()){
        // TFullScreenLoader.stopLoading();
        return false;
      }

      // Remember Me
      if(rememberMe.value){
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // Login Using Email and Password
      final userCredentials = await AuthenticatorRepository.instance.loginWithEmailandPassword(email.text.trim(), password.text.trim());

      // Fetch user data from Firestore
      // final user = await UserRepository.instance.getUserData(userCredentials.user!.uid);

      
      // Navigate to HomePage and pass user data
      // Get.off(() => HomePageScreen(user: user));

      // Removed by chatgpt
      AuthenticatorRepository.instance.screenRedirect();
      return true;
    } catch (e){
      print('Login error: $e');
      return false;
    }
  }


}