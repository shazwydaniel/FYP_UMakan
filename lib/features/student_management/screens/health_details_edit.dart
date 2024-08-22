import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/appbar/appbar.dart';

import 'package:fyp_umakan/features/student_management/controllers/update_profile_controller.dart';

import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HealthDetailsEdit extends StatelessWidget {
  const HealthDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfileController());
    return Scaffold(
      backgroundColor: TColors.bubbleOrange,
      appBar: const TAppBar(
          showBackArrow: true,
          title: Text(
            'Edit Health Details',
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
            Text('Edit Health details here',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Text fields and buttons
            Form(
                key: controller.updateProfileFormKey,
                child: Column(
                  children: [
                    //Weight (Textfield)
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.weight,
                      validator: (value) =>
                          TValidator.validateEmptyText('Weight', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.weight,
                        prefixIcon: Icon(
                          Iconsax.weight,
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

                    //Height (Textfield)
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.height,
                      validator: (value) =>
                          TValidator.validateEmptyText('Height', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.height,
                        prefixIcon: Icon(
                          Iconsax.ruler,
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

                    //Birthdate (Textfield)
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.birthDate,
                      validator: (value) =>
                          TValidator.validateEmptyText('Birthdate', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.birthdate,
                        prefixIcon: Icon(
                          Iconsax.cake,
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
