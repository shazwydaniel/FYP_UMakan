import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/appbar/appbar.dart';
import 'package:fyp_umakan/features/student_management/controllers/update_profile_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class PreferenceEditPage extends StatelessWidget {
  const PreferenceEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Use UpdateProfileController for handling preferences
    final controller = Get.put(UpdateProfileController());

    // Temporary variables for holding the state of preferences
    final prefSpicyTemp = RxBool(controller.prefSpicy.value);
    final prefVegetarianTemp = RxBool(controller.prefVegetarian.value);
    final prefLowSugarTemp = RxBool(controller.prefLowSugar.value);

    return Scaffold(
      backgroundColor: TColors.bubbleOrange,
      appBar: const TAppBar(
          showBackArrow: true,
          title: Text(
            'Edit Preferences',
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
            Text(
              'Set your food preferences',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Preferences Form
            Obx(() => Form(
                  child: Column(
                    children: [
                      // Prefer Spicy
                      SwitchListTile(
                        title: const Text(
                          'Show Spicy Food',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        value: prefSpicyTemp.value,
                        onChanged: (value) {
                          prefSpicyTemp.value = value;
                        },
                        activeColor: TColors.mustard,
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Prefer Vegetarian
                      SwitchListTile(
                        title: const Text(
                          'Show Vegetarian Food',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        value: prefVegetarianTemp.value,
                        onChanged: (value) {
                          prefVegetarianTemp.value = value;
                        },
                        activeColor: TColors.mustard,
                      ),

                      const SizedBox(height: TSizes.spaceBtwSections),

                      // Prefer Low Sugar
                      SwitchListTile(
                        title: const Text(
                          'Show Low Sugar Food',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        value: prefLowSugarTemp.value,
                        onChanged: (value) {
                          prefLowSugarTemp.value = value;
                        },
                        activeColor: TColors.mustard,
                      ),
                    ],
                  ),
                )),

            const SizedBox(height: TSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Update the actual preferences when the Save button is clicked
                  controller.prefSpicy.value = prefSpicyTemp.value;
                  controller.prefVegetarian.value = prefVegetarianTemp.value;
                  controller.prefLowSugar.value = prefLowSugarTemp.value;

                  // Call the updatePreferences method to save in Firebase
                  controller.updatePreferences();
                  // Navigate back
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: TColors.mustard,
                  side: BorderSide(
                      color: Colors.black, // Border color of the button
                      width: 2.0),
                ),
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
