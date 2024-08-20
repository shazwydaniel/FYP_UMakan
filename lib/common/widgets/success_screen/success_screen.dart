import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/styles/spacing_styles.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen(
      {super.key,
      required this.image,
      required this.title,
      required this.subTitle,
      this.onPressed});

  final String image, title, subTitle;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              //Image
              Image.asset(
                image,
                width: MediaQuery.of(context).size.width,
              ),

              const SizedBox(height: TSizes.spaceBtwSections),

              //Title and Subtitle
              Text(title,
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(subTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                  textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwSections),

              //Buttons (Buttons)
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: onPressed ??
                          () {
                            // Navigate to LoginScreen if no onPressed callback is provided
                            Get.offAll(() => const LoginScreen());
                          },
                      child: const Text(TTexts.tContinue))),
            ],
          ),
        ),
      ),
    );
  }
}
