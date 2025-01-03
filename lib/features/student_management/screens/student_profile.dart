// ignore_for_file: prefer_const_constructors

import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/features/admin/admin_feedback.dart";
import "package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart";
import "package:fyp_umakan/features/student_management/controllers/user_controller.dart";
import "package:fyp_umakan/features/student_management/screens/financial_details_edit.dart";
import "package:fyp_umakan/features/student_management/screens/health_details_edit.dart";
import "package:fyp_umakan/features/student_management/screens/personal_detail_edit.dart";
import "package:fyp_umakan/features/student_management/screens/preference_details_edit.dart";
import "package:fyp_umakan/features/vendor/screens/vendor_register.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/constants/image_strings.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:fyp_umakan/vendor_navigation_menu.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_navigation/src/snackbar/snackbar.dart";
import "package:iconsax/iconsax.dart";
import "package:intl/intl.dart";

class StudentProfilePageScreen extends StatelessWidget {
  const StudentProfilePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(UserController());
    final fooodJController = FoodJournalController.instance;

    return Scaffold(
      backgroundColor: TColors.bubbleOrange,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.user.value.username} !",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Achievements (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.mustard,
                  ),
                  const SizedBox(width: 10), // Space between the line and text

                  Text(
                    'Your Achievements',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Achievements Cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Row(
                children: [
                  _buildBadgeCard(
                    context,
                    dark,
                    "Initiator",
                    "Tap to see detail",
                    "Log meals for at least three meal times on the first day to unlock.",
                    "Congratulations! You logged meals for at least three meal times on the first day",
                    TImages.initiatorBadge,
                    "initiator",
                  ),
                  const SizedBox(width: 10),
                  _buildBadgeCard(
                    context,
                    dark,
                    "Novice",
                    "Tap to see detail",
                    "Unlock by logging meals for at least three meal times for 3 consecutive days.",
                    "Congratulations! You logged meals for at least three meal times 3 consecutive days",
                    TImages.noviceBadge,
                    "novice",
                  ),
                  const SizedBox(width: 10),
                  _buildBadgeCard(
                    context,
                    dark,
                    "Hero",
                    "Tap to see detail",
                    "Unlock by logging meals for at least three meal times for 7 consecutive days.",
                    "Congratulations! You logged meals for at least three meal times 7 consecutive days",
                    TImages.heroBadge,
                    "hero",
                  ),
                  const SizedBox(width: 10),
                  _buildBadgeCard(
                    context,
                    dark,
                    "Champion",
                    "Tap to see detail",
                    "Unlock by logging meals for at least three meal times for 30 consecutive days.",
                    "Congratulations! You logged meals for at least three meal times 30 consecutive days",
                    TImages.championBadge,
                    "champion",
                  ),
                ],
              ),
            ),

            // Personal Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.teal,
                  ),
                  const SizedBox(width: 10), // Space between the line and text

                  Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 180),
                ],
              ),
            ),

            // Personal Details (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PersonalDetailsEdit()),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: TColors.cream,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    controller.user.value.fullName,
                                    style: TextStyle(
                                      color: dark ? Colors.black : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Matric ID
                                  Text(
                                    controller.user.value.matricsNumber,
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Email
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.user.value.email,
                                      style: TextStyle(
                                        color:
                                            dark ? Colors.black : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Number
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.user.value.phoneNumber,
                                      style: TextStyle(
                                        color:
                                            dark ? Colors.black : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Accommodation
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.user.value.accommodation,
                                      style: TextStyle(
                                        color:
                                            dark ? Colors.black : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Social Media (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.blush,
                  ),
                  const SizedBox(width: 10),

                  Text(
                    'Link Your Socials',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 180),
                ],
              ),
            ),

            // Telegram Handle Section (Card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: TColors.cream,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Title
                            Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Telegram Handle Input
                            Obx(
                              () => TextFormField(
                                initialValue: controller.user.value.telegramHandle ?? '',
                                decoration: InputDecoration(
                                  labelText: "Telegram Handle",
                                  hintText: "@yourhandle",
                                  border: OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (value) {
                                  controller.updateTelegramHandle(value);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            // Save Button
                            Center(
                              child: TextButton(
                                onPressed: () async {
                                  try {
                                    await controller.saveTelegramHandle();
                                    Get.snackbar(
                                      "Success",
                                      "Telegram handle updated successfully!",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                    Navigator.pop(context); // Close the modal
                                  } catch (e) {
                                    Get.snackbar(
                                      "Error",
                                      "Failed to update Telegram handle: $e",
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                  }
                                },
                                style: TextButton.styleFrom(
                                  backgroundColor: TColors.teal,
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    side: const BorderSide(color: Colors.black, width: 2.0),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  color: TColors.cream,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/telegram.png',
                          height: 30,
                          width: 30,
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Label
                              Text(
                                "Telegram Handle",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              // Value
                              Obx(
                                () => Text(
                                  controller.user.value.telegramHandle?.isNotEmpty == true
                                      ? controller.user.value.telegramHandle!
                                      : "No Telegram handle set",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Financial Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.cobalt,
                  ),
                  const SizedBox(width: 10), // Space between the line and text

                  Text(
                    'Financial Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 180),
                ],
              ),
            ),

            // Financial Details (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  // First Card
                  GestureDetector(
                    onTap: () {
                      // Navigate to the new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FinancialDetailsEdit()),
                      );
                    },
                    child: Container(
                      height: 135,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: TColors.cream,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Stack(
                          children: [
                            // Left side text elements
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Monthly Allowances',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 34),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Overall',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right side price elements
                            Positioned(
                              bottom: -16.0,
                              right: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22.0),
                                    child: Text(
                                      'RM',
                                      style: TextStyle(
                                        color: TColors.darkGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    controller.user.value.monthlyAllowance,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Second Card
                  GestureDetector(
                    onTap: () {
                      // Navigate to the new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FinancialDetailsEdit()),
                      );
                    },
                    child: Container(
                      height: 220,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: TColors.cream,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 10,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Stack(
                          children: [
                            // Left side text elements
                            Positioned(
                              left: 0,
                              top: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Expenses',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 34),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Non-Food',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Right side price elements
                            Positioned(
                              top: 42.0,
                              right: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22.0),
                                    child: Text(
                                      'RM',
                                      style: TextStyle(
                                        color: TColors.darkGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    controller.user.value.monthlyCommittments,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 50,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                                top: 120.0,
                                left: 0,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 22.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 5.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'For Food',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                            Positioned(
                              top: 120.0,
                              right: 0,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 22.0),
                                    child: Text(
                                      'RM',
                                      style: TextStyle(
                                        color: TColors.darkGreen,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Obx(
                                    () => Text(
                                      controller.user.value
                                          .actualRemainingFoodAllowance
                                          .toString(),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Health Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.amber,
                  ),
                  const SizedBox(width: 10), // Space between the line and text

                  Text(
                    'Health Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 180),
                  //Edit button (Button)
                ],
              ),
            ),

            //Health Details (Card)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  // First Card (Card)
                  GestureDetector(
                    onTap: () {
                      // Navigate to the new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HealthDetailsEdit()),
                      );
                    },
                    child: Card(
                      elevation: 5, // Set the elevation to add shadow
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // Rounded corners
                      ),
                      color: TColors.cream, // Background color of the card
                      margin: const EdgeInsets.only(
                          bottom: 20), // Margin around the card
                      child: Padding(
                        padding:
                            const EdgeInsets.all(20), // Padding inside the card
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Align items at the top
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align texts to the left
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center vertically within the card
                                children: [
                                  // Weight Label
                                  Text(
                                    "weight",
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // Weight
                                  Text(
                                    '${controller.user.value.weight}kg',
                                    style: TextStyle(
                                      color: dark ? Colors.black : Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),

                                  // Height label
                                  Text(
                                    'height',
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  // Height
                                  Text(
                                    '${controller.user.value.height}cm',
                                    style: TextStyle(
                                      color: dark ? Colors.black : Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // Birthdate label
                                  Text(
                                    'birthdate',
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  //Birthdate
                                  Text(
                                    controller.user.value.birthdate,
                                    style: TextStyle(
                                      color: dark ? Colors.black : Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // BMR label
                                  Text(
                                    'Basal Metabolic Rate (BMR)',
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  //Birthdate
                                  Text(
                                    "${controller.calculateBMR()}",
                                    style: TextStyle(
                                      color: dark ? Colors.black : Colors.black,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Preference Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.cloud,
                  ),
                  const SizedBox(width: 10), // Space between the line and text

                  Text(
                    'Preference Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 180),
                  //Edit button (Button)
                ],
              ),
            ),

            // Preference Details (Card)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the preferences edit page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreferenceEditPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: TColors.cream,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Spicy Preference
                                  Text(
                                    "Spicy",
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Obx(() => Text(
                                        controller.user.value.prefSpicy
                                            ? "Yes"
                                            : "No",
                                        style: TextStyle(
                                          color: dark
                                              ? Colors.black
                                              : Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  const SizedBox(height: 20),

                                  // Vegetarian Preference
                                  Text(
                                    "Vegetarian",
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Obx(() => Text(
                                        controller.user.value.prefVegetarian
                                            ? "Yes"
                                            : "No",
                                        style: TextStyle(
                                          color: dark
                                              ? Colors.black
                                              : Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                  const SizedBox(height: 20),

                                  // Low Sugar Preference
                                  Text(
                                    "Low Sugar",
                                    style: TextStyle(
                                      color: dark
                                          ? Colors.black
                                          : const Color.fromARGB(
                                              255, 71, 71, 71),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Obx(() => Text(
                                        controller.user.value.prefLowSugar
                                            ? "Yes"
                                            : "No",
                                        style: TextStyle(
                                          color: dark
                                              ? Colors.black
                                              : Colors.black,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Help/Feedback Button
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 10),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FeedbackPage(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2.0),
                    backgroundColor: TColors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.feedback,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Help/Feedback",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: TColors.cream,
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop(); // Close the dialog
                                try {
                                  await AuthenticatorRepository.instance.logout();
                                } catch (e) {
                                  Get.snackbar(
                                    'Logout Error',
                                    e.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: TColors.amber,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text('Log Out'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.black, width: 2.0),
                    backgroundColor: TColors.amber,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Iconsax.logout, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildBadgeCard(
  BuildContext context,
  bool dark,
  String badgeName,
  String initialDescription,
  String tappedDescription,
  String unLockedDescription,
  String badgeImageUnlocked,
  String achievementField,
) {
  final controller = Get.find<UserController>();

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('Users')
        .doc(controller.user.value.id)
        .collection('Achievements')
        .doc('current')
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Show a loader while fetching
      }

      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
        return Text("Error loading achievement data");
      }

      // Check if the achievement is unlocked
      final achievementData = snapshot.data!;
      bool isUnlocked = achievementData[achievementField] ?? false;

      return GestureDetector(
        onTap: () {
          // Show badge details in full view
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 420,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: TColors.cream,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Badge Image
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isUnlocked ? Colors.transparent : Colors.grey,
                        ),
                        child: isUnlocked
                            ? Image.asset(
                                badgeImageUnlocked,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.lock,
                                size: 50,
                                color: Colors.white,
                              ),
                      ),
                      SizedBox(height: 20),

                      Text(
                        badgeName,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: dark ? Colors.black : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        isUnlocked ? unLockedDescription : tappedDescription,
                        style: TextStyle(
                          fontSize: 16,
                          color: dark
                              ? const Color.fromARGB(255, 71, 71, 71)
                              : const Color.fromARGB(255, 71, 71, 71),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: Card(
          elevation: 5,
          color: TColors.cream,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Badge Image or Locked State
                isUnlocked
                    ? Image.asset(
                        badgeImageUnlocked,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover, // Ensures the image scales properly
                      )
                    : Container(
                        width: 130, // Adjust the circle size here
                        height: 130,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Icon(
                          Icons.lock,
                          size: 50, // Adjust the size of the lock icon
                          color: Colors.white,
                        ),
                      ),

                const SizedBox(height: 10),
                Text(
                  badgeName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Text(
                  initialDescription,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color.fromARGB(255, 71, 71, 71),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
