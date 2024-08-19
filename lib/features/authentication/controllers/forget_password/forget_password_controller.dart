import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/authentication/screens/password_config/reset_password.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:fyp_umakan/utils/popups/full_screen_loader.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  static ForgetPasswordController get instance => Get.find();

  //Variables
  final email = TextEditingController();
  GlobalKey<FormState> forgetPasswordKey = GlobalKey<FormState>();

  final NetworkManager networkManager = Get.put(NetworkManager());

  //Send Reset Password Email
  sendPasswordResetEmail() async {
    try {
      //Start loading
      TFullScreenLoader.openLoadingDialog(
          "Processing Your request", TImages.loading);

      //Check internet connection
      final isConnected = await networkManager.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if (!forgetPasswordKey.currentState!.validate()) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Send Email to Reset Password
      await AuthenticatorRepository.instance
          .sendPasswordResetEmail(email.text.trim());

      //Stop loading screen
      TFullScreenLoader.stopLoading();

      //Show Success Screen
      TLoaders.successSnackBar(
          title: 'Email Sent', message: 'Email link sent to reset password'.tr);

      //Redirect
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  resendPasswordResetEmail(String email) async {
    try {
      //Start loading
      TFullScreenLoader.openLoadingDialog(
          "Processing Your request", TImages.loading);

      //Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TFullScreenLoader.stopLoading();
        return;
      }

      //Send Email to Reset Password
      await AuthenticatorRepository.instance.sendPasswordResetEmail(email);

      //Stop loading screen
      TFullScreenLoader.stopLoading();

      //Show Success Screen
      TLoaders.successSnackBar(
          title: 'Email Sent', message: 'Email link sent to reset password'.tr);
    } catch (e) {
      TFullScreenLoader.stopLoading();
      TLoaders.errorSnackBar(title: 'AlamakS!', message: e.toString());
    }
  }
}
