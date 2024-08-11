import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/register/widgets/register_form.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,

      appBar: AppBar(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Image(image: const AssetImage(TImages.appLogo), width: THelperFunctions.screenWidth()),

              const SizedBox(height: TSizes.spaceBtwSections),

              Text('Home Page', style: Theme.of(context).textTheme.headlineMedium, textAlign: TextAlign.center),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text('Description', style: Theme.of(context).textTheme.labelMedium, textAlign: TextAlign.center),

              const SizedBox(height: TSizes.spaceBtwSections),

              // Text('Name: ${user.fullName}'),
              // Text('Email: ${user.email}'),

              
            ],
          ),
        ),
      ),

    );
  }
}