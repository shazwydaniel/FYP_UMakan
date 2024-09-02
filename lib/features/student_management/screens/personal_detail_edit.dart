import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/appbar/appbar.dart';
import 'package:fyp_umakan/data/repositories/user/user_repository.dart';
import 'package:fyp_umakan/features/student_management/controllers/update_profile_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class PersonalDetailsEdit extends StatelessWidget {
  const PersonalDetailsEdit({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfileController());

    return Scaffold(
      backgroundColor: TColors.bubbleOrange,
      appBar: const TAppBar(
          showBackArrow: true,
          title: Text(
            'Edit Profile',
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
            Text('Edit profile details here',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: TSizes.spaceBtwSections),

            //Text fields and buttons
            Form(
                key: controller.updateProfileFormKey,
                child: Column(
                  children: [
                    //full Name
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.fullName,
                      validator: (value) =>
                          TValidator.validateEmptyText('Full Name', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.fullName,
                        prefixIcon: Icon(
                          Iconsax.user,
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

                    //Matric ID
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.matricsNumber,
                      validator: (value) =>
                          TValidator.validateEmptyText('Matrics Number', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.matricsNumber,
                        prefixIcon: Icon(
                          Iconsax.key,
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

                    //Phone Number
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.phoneNumber,
                      validator: (value) =>
                          TValidator.validateEmptyText('Phone Number', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.phoneNo,
                        prefixIcon: Icon(
                          Iconsax.call,
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

                    //Accomodation
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      controller: controller.accommodation,
                      validator: (value) =>
                          TValidator.validateEmptyText('Accommodation', value),
                      expands: false,
                      decoration: const InputDecoration(
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        labelText: TTexts.accommodation,
                        prefixIcon: Icon(
                          Iconsax.home_1,
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
