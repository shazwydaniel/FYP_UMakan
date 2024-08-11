import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/success_screen/success_screen.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,

      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(onPressed: () => Get.offAll(() => const LoginScreen()), icon: const Icon(CupertinoIcons.clear)),
        ],
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Image(image: const AssetImage(TImages.deliveredEmailIllustration), width: THelperFunctions.screenWidth()*1.2),

              const SizedBox(height: TSizes.spaceBtwSections),

              Text(TTexts.confirmEmail.capitalize!, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text('UMakanSupport@gmail.com', style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(TTexts.confirmEmailSubTitle, style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),

              const SizedBox(height: TSizes.spaceBtwSections),

              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () => Get.to(() => const SuccessScreen()), child: const Text(TTexts.tContinue))),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(width: double.infinity, child: TextButton(onPressed: (){}, child: const Text(TTexts.resendEmail))),
            ],
          ),
        ),
      ),
    );
  }
}