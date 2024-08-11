import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/screens/register/widgets/personal_details_form.dart';
import 'package:fyp_umakan/features/authentication/screens/register/widgets/register_form.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PersonalDetailsScreen extends StatelessWidget {
  final String userId;

  const PersonalDetailsScreen({
    super.key,
    required this.userId,
  });

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
              const SizedBox(height: TSizes.spaceBtwSections),

              Text('Personal Details', style: Theme.of(context).textTheme.headlineMedium),

              const SizedBox(height: TSizes.spaceBtwSections),

              PersonalDetailsForm(userId: userId),

            ],
          ),
        ),
      ),
    );
  }
}