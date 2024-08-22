import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/appbar/appbar.dart';

import 'package:fyp_umakan/features/student_management/controllers/update_profile_controller.dart';

import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FinancialDetailsEdit extends StatelessWidget {
  const FinancialDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfileController());
    return Scaffold(
      backgroundColor: TColors.bubbleOrange,
      appBar: const TAppBar(
          showBackArrow: true,
          title: Text(
            'Edit Financial Details',
            style: TextStyle(
              fontSize: 16, // Adjust the font size as needed
              fontWeight: FontWeight.normal,
              color: Colors.white,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Financial details here',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Text fields and buttons
            Form(
                key: controller.updateProfileFormKey,
                child: Column(
                  children: [
                    //Monthly Allowance (Textfield)
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.monthlyAllowance,
                      validator: (value) => TValidator.validateEmptyText(
                          'Monthly Allowance', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.monthlyAllowance,
                        prefixIcon: Icon(
                          Iconsax.money_recive,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Underline color when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.white), // Underline color when focused
                        ),
                      ),
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),

                    //Monthly Commitments (Textfield)
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.monthlyCommittments,
                      validator: (value) => TValidator.validateEmptyText(
                          'Monthly Commitments', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.monthlyCommitments,
                        prefixIcon: Icon(
                          Iconsax.money_remove,
                          color: Colors.white,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .white), // Underline color when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.white), // Underline color when focused
                        ),
                      ),
                    ),
                    SizedBox(height: TSizes.spaceBtwSections),
                  ],
                )),
            SizedBox(height: TSizes.spaceBtwSections),

            //Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.updateProfile(),
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
