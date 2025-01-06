import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/common/widgets/success_screen/success_screen.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:get/get.dart';

class VerifyEmailController extends GetxController {
  static VerifyEmailController get instance => Get.find();

//Send email whenever verify screen appears and set timer for auto dierect
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  //Send email verification link
  sendEmailVerification() async {
    try {
      await AuthenticatorRepository.instance.sendEmailVerification();
      TLoaders.successSnackBar(
          title: 'Email Sent',
          message: 'Please Check your inbox and verify your email.');
    } catch (e) {
      TLoaders.errorSnackBar(
          title: "Oh Snap from Email Verification!", message: e.toString());
    }
  }

  ///Timer to automatically redirect on Email Verification
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        //if email verified is null, want to return false
        timer.cancel();
        print("Email verified, navigating to SuccessScreen");
        Get.off(() => const SuccessScreen(
              image: TImages.verifyIllustration,
              title: TTexts.yourAccountCreatedTitle,
              subTitle: TTexts.yourAccountCreatedSubTitle,
            ));
      }
    });
  }

  //Manually Check if Email Verified
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() => const SuccessScreen(
            image: TImages.verifyIllustration,
            title: TTexts.yourAccountCreatedTitle,
            subTitle: TTexts.yourAccountCreatedSubTitle,
          ));
    }
  }
}
