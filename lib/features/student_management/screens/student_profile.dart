// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/features/student_management/controllers/user_controller.dart";
import "package:fyp_umakan/features/student_management/screens/financial_details_edit.dart";
import "package:fyp_umakan/features/student_management/screens/health_details_edit.dart";
import "package:fyp_umakan/features/student_management/screens/personal_detail_edit.dart";
import "package:fyp_umakan/features/vendor/screens/vendor_register.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
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
    final controller = UserController.instance;

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

            // Personal Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
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
                                  // Full Name
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
                                  const SizedBox(height: 10),

                                  // Calculated Recommendations (Cards)
                                  Column(
                                    children: [
                                      // Recommended Food Allowance - Monthly (Value)
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: TColors.cobalt,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Title Text
                                                    Text(
                                                      'Monthly Food Allowance',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Recommended to have',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 10.0,
                                                            right: 2.0,
                                                          ),
                                                          child: Text(
                                                            'RM',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Obx(
                                                          () {
                                                            // Format the value with up to 2 decimal places
                                                            String
                                                                formattedAllowance =
                                                                NumberFormat(
                                                                        '0.00')
                                                                    .format(controller
                                                                        .user
                                                                        .value
                                                                        .recommendedMoneyAllowance);

                                                            return Text(
                                                              "$formattedAllowance",
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 28,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Right Side Text Elements
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Obx(() {
                                                  final recommendedAllowance =
                                                      controller.user.value
                                                          .recommendedMoneyAllowance;
                                                  final remainingAllowance =
                                                      controller.user.value
                                                          .actualRemainingFoodAllowance;

                                                  return Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 5),
                                                    decoration: BoxDecoration(
                                                      color: remainingAllowance >=
                                                              recommendedAllowance
                                                          ? TColors.teal
                                                              .withOpacity(0.7)
                                                          : TColors.amber
                                                              .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          remainingAllowance >=
                                                                  recommendedAllowance
                                                              ? Iconsax
                                                                  .emoji_happy
                                                              : Iconsax
                                                                  .emoji_sad,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                        const SizedBox(
                                                            width: 5),
                                                        Text(
                                                          remainingAllowance >=
                                                                  recommendedAllowance
                                                              ? 'Enough'
                                                              : 'Not Enough',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // Recommended Calorie Intake - Daily (Value)
                                      Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                          color: TColors.indigo,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          // boxShadow: [
                                          //   BoxShadow(
                                          //     color: Colors.black.withOpacity(0.1),
                                          //     spreadRadius: 1,
                                          //     blurRadius: 3,
                                          //     offset: Offset(0, 8),
                                          //   ),
                                          // ],
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
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Title Text
                                                    Text(
                                                      'Daily Calorie Intake',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Recommended to consume',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                    Row(
                                                      children: [
                                                        Obx(
                                                          () => Text(
                                                            "${controller.user.value.recommendedCalorieIntake}",
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 28,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(
                                                            top: 10.0,
                                                            left: 2.0,
                                                          ),
                                                          child: Text(
                                                            'kcal',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // Right Side Text Elements
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child:
                                                    // Status of Calorie Intake (Card)
                                                    Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: TColors.amber
                                                        .withOpacity(0.7),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(
                                                        Iconsax.emoji_sad,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                      const SizedBox(width: 5),
                                                      // Status of Calorie Intake (Label)
                                                      Text(
                                                        'Exceeded',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12,
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
                                    ],
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

            // Financial Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
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
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
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
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
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
                                  const SizedBox(height: 10),

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

                                  const SizedBox(height: 10),

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

            //Logout button (Button)
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
                                  await AuthenticatorRepository.instance
                                      .logout();
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
                    side: const BorderSide(color: TColors.amber),
                    backgroundColor: TColors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
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

            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 40),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => VendorRegisterPage());
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: TColors.bubbleGreen),
                    backgroundColor: TColors.bubbleGreen,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Vendor',
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
