import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/features/authentication/models/user_model.dart';
import 'package:fyp_umakan/features/authentication/screens/register/widgets/register_form.dart';
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
                  height: 450,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Title 1
                            Positioned(
                              top: 100,
                              left: 40,
                              child: Text(
                                'Recommend-',
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
                              child: Text(
                                'ations',
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
                      // Meal Recommendations Label
                      Padding(
                        padding: const EdgeInsets.only(left: 40, right: 40, bottom:20, top:10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 4,  // Thin vertical line width
                              height: 40, // Adjust the height as needed
                              color: TColors.teal,
                            ),
                            const SizedBox(width: 10), // Space between the line and text
                            Text(
                              'Lunch',
                              style: TextStyle(
                                fontSize: 20,  // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.white : Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Scrollable Meal Recommendations Section
                      Container(
                        height: 150, // Height of the square cards
                        margin: const EdgeInsets.only(left: 40, right: 40, bottom: 40),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: List.generate(5, (index) {
                              return Container(
                                width: 150, // Width of the square cards
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: TColors.mustard,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Meal ${index + 1}',
                                    style: TextStyle(
                                      color: dark ? Colors.white : Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
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
                    // Journals Label
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom:20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 4,  // Thin vertical line width
                              height: 40, // Adjust the height as needed
                              color: TColors.amber,
                            ),
                            const SizedBox(width: 10), // Space between the line and text
                            Text(
                              'Journals',
                              style: TextStyle(
                                fontSize: 20,  // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.black : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Money Journal Button
                    Container(
                      height: 150, // Height of the rectangle card
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: TColors.teal,
                        borderRadius: BorderRadius.circular(10),
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
                    // Food Journal Button
                    Container(
                      height: 150, // Height of the rectangle card
                      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: TColors.amber,
                        borderRadius: BorderRadius.circular(10),
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
                    // Ads Label
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, bottom:20, top:20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 4,  // Thin vertical line width
                              height: 40, // Adjust the height as needed
                              color: TColors.cobalt,
                            ),
                            const SizedBox(width: 10), // Space between the line and text
                            Text(
                              'Promotions',
                              style: TextStyle(
                                fontSize: 20,  // Adjust the font size as needed
                                fontWeight: FontWeight.bold,
                                color: dark ? Colors.black : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Horizontally Scrollable Cards for Cafe's Ads and Promotions
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(5, (index) {
                            return Container(
                              width: 300, // Width of the rectangle cards
                              height: 100, // Height of the rectangle cards
                              margin: const EdgeInsets.only(left: 20, bottom: 20, right: 10),
                              decoration: BoxDecoration(
                                color: index.isEven ? TColors.cobalt : TColors.bubbleOrange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'Promotion ${index + 1}',
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