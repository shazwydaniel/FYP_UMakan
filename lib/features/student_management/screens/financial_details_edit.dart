import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/appbar/appbar.dart';

import 'package:fyp_umakan/features/student_management/controllers/update_profile_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';

import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/text_strings.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class FinancialDetailsEdit extends StatelessWidget {
  const FinancialDetailsEdit({super.key});

  Future<String> _fetchFinancialStatus(String userId) async {
    try {
      final financialStatusDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(userId)
          .collection("financial_status")
          .doc("current")
          .get();

      return financialStatusDoc.data()?["status"] ?? "Unknown";
    } catch (e) {
      print("Error fetching financial status: $e");
      return "Unknown";
    }
  }

  Future<void> _showUpdatedFinancialStatus(String userId) async {
    // Add a small delay to ensure the latest status is fetched
    await Future.delayed(Duration(seconds: 1));

    final financialStatus = await _fetchFinancialStatus(userId);

    // Define notification properties based on the financial status
    Color statusColor;
    IconData statusIcon;
    String statusText;

    if (financialStatus == "Surplus") {
      statusColor = TColors.teal.withOpacity(0.7);
      statusIcon = Iconsax.emoji_happy;
      statusText = "Surplus";
    } else if (financialStatus == "Moderate") {
      statusColor = TColors.marigold.withOpacity(0.7);
      statusIcon = Iconsax.emoji_normal;
      statusText = "Moderate";
    } else if (financialStatus == "Deficit") {
      statusColor = TColors.amber.withOpacity(0.7);
      statusIcon = Iconsax.emoji_sad;
      statusText = "Deficit";
    } else {
      statusColor = TColors.charcoal.withOpacity(0.7);
      statusIcon = Iconsax.warning_2;
      statusText = "Unknown";
    }

    // Show notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.snackbar(
        "Financial Status Update",
        "You now have $statusText Food Allowance",
        snackPosition: SnackPosition.TOP,
        backgroundColor: statusColor,
        colorText: Colors.white,
        icon: Icon(statusIcon, color: Colors.white),
        duration: Duration(seconds: 3),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UpdateProfileController());
    final userController = UserController.instance;

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
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Financial details here',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Text fields and buttons
            Form(
              key: controller.updateProfileFormKey,
              child: Column(
                children: [
                  // Monthly Allowance (Textfield)
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
                            color:
                                Colors.white), // Underline color when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Colors.white), // Underline color when focused
                      ),
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),

                  // Monthly Commitments (Textfield)
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
                            color:
                                Colors.white), // Underline color when not focused
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
              ),
            ),
            SizedBox(height: TSizes.spaceBtwSections),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Call the update functions
                    await controller.updateProfile();
                    await controller.updateFoodMoney();

                    // Trigger recalculation of calculated fields, including financial status
                    await userController.updateCalculatedFields();

                    // Show the latest financial status after the update
                    final userId = userController.user.value.id;
                    await _showUpdatedFinancialStatus(userId);

                    print(userController.user.value.actualRemainingFoodAllowance);
                  } catch (e) {
                    print("Error updating financial details: $e");
                    Get.snackbar(
                      "Error",
                      "Failed to update financial details. Please try again.",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: TColors.amber,
                      colorText: Colors.white,
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}