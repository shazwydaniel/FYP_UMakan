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
                  height: 660,
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
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'UM',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.teal,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'akan',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.mustard,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '.  ',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: TColors.amber,
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Recommends',
                                      style: TextStyle(
                                        fontSize: 23,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12), // Padding inside the card
                                decoration: BoxDecoration(
                                  color: TColors.cobalt, // Background color of the card
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Food Allowance",
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "RM${userController.user.value.recommendedMoneyAllowance}",
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.all(12), // Padding inside the card
                                decoration: BoxDecoration(
                                  color: TColors.cobalt, // Background color of the card
                                  borderRadius: BorderRadius.circular(12), // Rounded corners
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        "Daily Calorie Intake",
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    ),
                                    Obx(
                                      () => Text(
                                        "${userController.user.value.recommendedCalorieIntake} kcal",
                                        style: TextStyle(
                                          color: Colors.white, // Text color
                                          fontSize: 18,
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

                      // Meal Recommendations (Label)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 10, top: 10),
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
                                color: dark ? Colors.white : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Meal Recommendations Section (Scrollable)
                      Container(
                        height: 150,
                        margin: const EdgeInsets.only(
                            left: 40, right: 40, bottom: 40, top:5),
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
                                    fit: BoxFit.cover,
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
                    // Journals (Label)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
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
                    // Food Journal Button
                    GestureDetector(
                      onTap: () => controller.navigateToJournal('Food Journal'),
                      child: Container(
                        height: 150,
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
                        decoration: BoxDecoration(
                          color: TColors.amber,
                          borderRadius: BorderRadius.circular(20),
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
                            'Ads',
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
                        children: List.generate(5, (index) {
                          return Container(
                            width: 300,
                            height: 100,
                            margin: const EdgeInsets.only(
                                left: 20, bottom: 20, right: 10),
                            decoration: BoxDecoration(
                              color: index.isEven
                                  ? TColors.cobalt
                                  : TColors.bubbleOrange,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Ad ${index + 1}',
                                style: TextStyle(
                                  color: dark ? Colors.white : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
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
