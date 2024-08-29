// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/register/widgets/register_form.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
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
    final controller = Get.put(JournalController());
    final userController = Get.put(UserController());

    return Scaffold(
      backgroundColor: dark ? TColors.darkGreen : TColors.cream,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipPath(
              clipper: TCustomCurvedEdges(),
              child: Container(
                color: TColors.amber,
                padding: const EdgeInsets.all(0),
                child: SizedBox(
                  height: 580,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Title 1
                            Positioned(
                              top: 90,
                              left: 40,
                              child: Text(
                                'Welcome,',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: dark ? Colors.white : Colors.white,
                                ),
                              ),
                            ),

                            // Title 2
                            Positioned(
                              top: 140,
                              left: 40,
                              child: Obx(
                                () => Text(
                                  "${userController.user.value.username} !",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: dark ? Colors.white : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Stats Highlights (Label)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 10, top: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20), // Padding inside the card
                          decoration: BoxDecoration(
                            color: TColors.bubbleRed, // Background color of the card
                            borderRadius: BorderRadius.circular(20), // Rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // UMakan Recommends (Label)
                              Text.rich(
                                TextSpan(
                                  children: [
                                    // TextSpan(
                                    //   text: 'UM',
                                    //   style: TextStyle(
                                    //     fontSize: 28,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: TColors.teal,
                                    //   ),
                                    // ),
                                    // TextSpan(
                                    //   text: 'akan',
                                    //   style: TextStyle(
                                    //     fontSize: 28,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: TColors.mustard,
                                    //   ),
                                    // ),
                                    // TextSpan(
                                    //   text: '.  ',
                                    //   style: TextStyle(
                                    //     fontSize: 28,
                                    //     fontWeight: FontWeight.bold,
                                    //     color: TColors.amber,
                                    //   ),
                                    // ),
                                    TextSpan(
                                      text: 'We Suggest You To Have',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              // Recommended Food Allowance - Monthly (Value)
                              Container(
                                height: 120,
                                decoration: BoxDecoration(
                                  color: TColors.cobalt,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
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
                                            // Title Text
                                            Text(
                                              'Food Allowance',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Monthly',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, right:2.0,),
                                                  child: Text(
                                                    'RM',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () => Text(
                                                    "${userController.user.value.recommendedMoneyAllowance}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.bold,
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
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Obx(() {
                                              final recommendedAllowance = userController.user.value.recommendedMoneyAllowance;
                                              final remainingAllowance = userController.user.value.actualRemainingFoodAllowance;

                                              return Container(
                                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                                decoration: BoxDecoration(
                                                  color: remainingAllowance >= recommendedAllowance ? TColors.teal.withOpacity(0.7) : TColors.amber.withOpacity(0.7),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      remainingAllowance >= recommendedAllowance
                                                          ? Iconsax.emoji_happy
                                                          : Iconsax.emoji_sad,
                                                      color: Colors.white,
                                                      size: 16,
                                                    ),
                                                    const SizedBox(width: 5),
                                                    Text(
                                                      remainingAllowance >= recommendedAllowance ? 'Enough' : 'Not Enough',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ),
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
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      spreadRadius: 1,
                                      blurRadius: 3,
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
                                            // Title Text
                                            Text(
                                              'Calorie Intake',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Daily',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Obx(
                                                  () => Text(
                                                    "${userController.user.value.recommendedCalorieIntake}",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 28,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(top: 10.0, left:2.0,),
                                                  child: Text(
                                                    'kcal',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.bold,
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
                                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: TColors.amber.withOpacity(0.7),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Iconsax.emoji_sad, color: Colors.white, size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  // Status of Calorie Intake (Label)
                                                  Text(
                                                    'Exceeded',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
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
                        ),
                      ),
                      SizedBox(height: 35),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                      // Meal Recommendations (Label)
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 4,
                              height: 40,
                              color: TColors.teal,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Meal Recommendations',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.black : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Meal Recommendations Section (Scrollable)
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(4, (index) {
                              return Container(
                                width: 150,
                                margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                  color: TColors.mustard,
                                  borderRadius: BorderRadius.circular(150),
                                  image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/meal_image_${index + 1}.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                // child: Center(
                                //   child: Text(
                                //     'Meal ${index + 1}',
                                //     style: TextStyle(
                                //       color: dark ? Colors.white : Colors.black,
                                //       fontSize: 18,
                                //       fontWeight: FontWeight.bold,
                                //     ),
                                //   ),
                                // ),
                              );
                            }),
                          ),
                        ),
                      ),
                    // Journals (Label)
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 4,
                            height: 40,
                            color: TColors.amber,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Journals',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.black : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Food Journal Button
                    GestureDetector(
                      onTap: () => controller.navigateToJournal('Food Journal'),
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: TColors.amber,
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
                        child: Center(
                          child: Text(
                            'Food Journal',
                            style: TextStyle(
                              color: dark ? Colors.white : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Money Journal Button
                    GestureDetector(
                      onTap: () =>
                          controller.navigateToJournal('Money Journal'),
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: TColors.teal,
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
                        child: Center(
                          child: Text(
                            'Money Journal',
                            style: TextStyle(
                              color: dark ? Colors.white : Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Ads (Label)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 4, // Thin vertical line width
                            height: 40, // Adjust the height as needed
                            color: TColors.cobalt,
                          ),
                          const SizedBox(
                              width: 10), // Space between the line and text
                          Text(
                            'Advertisements',
                            style: TextStyle(
                              fontSize: 20, // Adjust the font size as needed
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.black : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Cafe's Ads (Cards) (Horizontally Scrollable)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(4, (index) {
                          return Container(
                            width: 300,
                            margin: const EdgeInsets.only(
                              left: 20,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              color: index.isEven ? TColors.cobalt : TColors.bubbleOrange,
                              borderRadius: BorderRadius.circular(20), // Increased border radius for a softer look
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20.0), // Added padding for better content spacing
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Buy 2 Shawarma\nFree 1!',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20, // Adjusted font size
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8), // Spacing between texts
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 2,
                                            horizontal: 8,
                                          ),
                                          decoration: BoxDecoration(
                                            color: index.isEven ? TColors.bubbleBlue.withOpacity(0.8) : TColors.darkGreen.withOpacity(0.4),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            '6.6.24 - 10.6.24',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          right: 0,
                                          child: Row(
                                            children: [
                                              Text(
                                                'KK12',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 35,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
