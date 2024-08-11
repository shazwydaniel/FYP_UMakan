import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/register/personal_details_controller.dart';
import 'package:fyp_umakan/features/authentication/screens/register/verify_email.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PersonalDetailsForm extends StatelessWidget {
  final String userId;

  const PersonalDetailsForm({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PersonalDetailsController());
    final dark = THelperFunctions.isDarkMode(context);

    return Form(
      key: controller.personalDetailsFormKey,
      child: Column(
        children: [
          Row(
            children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.accommodation,
                    validator: (value) => TValidator.validateEmptyText('Accommodation', value),
                    decoration: const InputDecoration(
                      labelText: 'Accommodation',
                      prefixIcon: Icon(Iconsax.house),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.vehicle,
                    validator: (value) => TValidator.validateEmptyText('Vehicle Ownership', value),
                    decoration: const InputDecoration(
                      labelText: 'Vehicle Owner (Yes / No)',
                      prefixIcon: Icon(Iconsax.car),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.maritalStatus,
                    validator: (value) => TValidator.validateEmptyText('Marital Status', value),
                    decoration: const InputDecoration(
                      labelText: 'Marital Status (Married / Single)',
                      prefixIcon: Icon(Iconsax.heart),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),

          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.childrenNumber,
                    validator: (value) => TValidator.validateEmptyText('Number of Children', value),
                    decoration: const InputDecoration(
                      labelText: 'Number of Children',
                      prefixIcon: Icon(Iconsax.star),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),
    
          Row(
            children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.monthlyAllowance,
                    validator: (value) => TValidator.validateEmptyText('Monthly Allowance', value),
                    decoration: const InputDecoration(
                      labelText: 'Monthly Allowance',
                      prefixIcon: Icon(Iconsax.money_recive),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),
    
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.monthlyCommittments,
                    validator: (value) => TValidator.validateEmptyText('Monthly Commitments', value),
                    decoration: const InputDecoration(
                      labelText: 'Monthly Committments (Non Food)',
                      prefixIcon: Icon(Iconsax.money_remove),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),
    
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.height,
                    validator: (value) => TValidator.validateEmptyText('Height', value),
                    decoration: const InputDecoration(
                      labelText: 'Height (cm)',
                      prefixIcon: Icon(Iconsax.ruler),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),
    
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.weight,
                    validator: (value) => TValidator.validateEmptyText('Weight', value),
                    decoration: const InputDecoration(
                      labelText: 'Weight (kg)',
                      prefixIcon: Icon(Iconsax.weight),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwInputFields),
    
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                    controller: controller.birthdate,
                    validator: (value) => TValidator.validateEmptyText('Birthdate', value),
                    decoration: const InputDecoration(
                      labelText: 'Birthdate (dd/mm/yyyy)',
                      prefixIcon: Icon(Iconsax.calendar),
                    ),
                  ),
                ),
            ],
          ),
    
          const SizedBox(height: TSizes.spaceBtwSections),
    
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () async {
                bool success = await controller.addPersonalDetails(userId);
                if (!success) {
                  Get.to(() => const VerifyEmailScreen());
                } else {
                  print('FAIL');
                }
                // bool isFilled = await controller.addPersonalDetails();
                // if (isFilled) {
                //   Get.to(() => const VerifyEmailScreen());
                // }
              }, 
            child: Text(TTexts.createAccount)),),
    
        ],
      ),
    );
  }
}