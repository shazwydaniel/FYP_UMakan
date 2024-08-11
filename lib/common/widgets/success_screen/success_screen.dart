import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/styles/spacing_styles.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({super.key});

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
              Image(image: const AssetImage(TImages.staticSuccessIllustration), width: THelperFunctions.screenWidth() * 1.2),

              const SizedBox(height: TSizes.spaceBtwSections),

              Text(TTexts.yourAccountCreatedTitle.capitalize!, style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.yourAccountCreatedSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),

              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => const LoginScreen()), child: const Text(TTexts.tContinue))),
            ],
          ),
        ),
      ),
    );
  }
}