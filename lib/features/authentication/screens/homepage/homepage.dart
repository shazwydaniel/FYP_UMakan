// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/recommendation_controller.dart';

import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';

import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';

import 'package:fyp_umakan/utils/constants/sizes.dart';

import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(JournalController());
    final userController = Get.put(UserController());
    final advertController = Get.put(AdvertController());

    final recommendedController = Get.put(RecommendationController());
    final foodJController = Get.put(FoodJournalController());
    advertController.fetchAllAdvertisements();

    return Scaffold(
      backgroundColor: dark ? TColors.cream : TColors.cream,
      body:
          // RefreshIndicator(
          //   onRefresh: _refreshData,
          //   child:
          SingleChildScrollView(
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
                          padding: const EdgeInsets.all(
                              20), // Padding inside the card
                          decoration: BoxDecoration(
                            color: TColors
                                .bubbleRed, // Background color of the card
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // UMakan Recommends (Label)
                              Row(
                                children: [
                                  Icon(
                                    Iconsax.speedometer,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  // UMakan Recommends (Label)
                                  Text(
                                    'Based on Your Data',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Recommended to have',
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                    right: 2.0,
                                                  ),
                                                  child: Text(
                                                    'RM',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Obx(
                                                  () {
                                                    // Format the value with up to 2 decimal places
                                                    String formattedAllowance =
                                                        NumberFormat('0.00')
                                                            .format(userController
                                                                .user
                                                                .value
                                                                .recommendedMoneyAllowance);

                                                    return Text(
                                                      "$formattedAllowance",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                              userController.user.value
                                                  .recommendedMoneyAllowance;
                                          final remainingAllowance =
                                              userController.user.value
                                                  .actualRemainingFoodAllowance;

                                          return Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 5),
                                            decoration: BoxDecoration(
                                              color: remainingAllowance >=
                                                      recommendedAllowance
                                                  ? TColors.teal
                                                      .withOpacity(0.7)
                                                  : TColors.amber
                                                      .withOpacity(0.7),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  remainingAllowance >=
                                                          recommendedAllowance
                                                      ? Iconsax.emoji_happy
                                                      : Iconsax.emoji_sad,
                                                  color: Colors.white,
                                                  size: 16,
                                                ),
                                                const SizedBox(width: 5),
                                                Text(
                                                  remainingAllowance >=
                                                          recommendedAllowance
                                                      ? 'Enough'
                                                      : 'Not Enough',
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
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Recommended to consume',
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 10.0,
                                                    left: 2.0,
                                                  ),
                                                  child: Text(
                                                    'kcal',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                            color:
                                                TColors.amber.withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
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
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Meal Recommendations (Label)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
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
                    /*ElevatedButton(
                        onPressed: () {
                          foodJController.getStoredAverageCalories(0);
                          final recommendedMeals = recommendedController.getRecommendedList(
                              foodJController.getStoredAverageCalories(0));
                        },
                        child: Text("see recommended")),*/
                    // Meal Recommendations Section (Scrollable)
                    Obx(() {
                      return FutureBuilder<List<CafeItem>>(
                        future: recommendedController.getRecommendedList(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Loading indicator
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text(
                                    'Error: ${snapshot.error}')); // Display any error
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                                child: Text(
                                    'No recommended items available.')); // Empty list case
                          } else {
                            final recommendedMeals = snapshot.data!;

                            return Container(
                              height: 220,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 20),
                              child: ListView.builder(
                                itemCount: recommendedMeals.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  final item = recommendedMeals[index];
                                  return GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    "Meal Details",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  icon: Icon(Icons.close),
                                                  color: Colors.black,
                                                ),
                                              ],
                                            ),
                                            backgroundColor: TColors.cream,
                                            content: Container(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      border: Border.all(
                                                          color: Colors.black),
                                                    ),
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Meal Name: ${item.itemName}',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: TSizes
                                                                .spaceBtwSections),
                                                        Text(
                                                          'Calories: ${item.itemCalories} kcal',
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: TSizes
                                                                .spaceBtwSections),
                                                        Text(
                                                          'Price: RM${item.itemPrice.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            height: TSizes
                                                                .spaceBtwSections),
                                                        Text(
                                                          'Location: ${item.itemCafe}',
                                                          style: TextStyle(
                                                            fontSize: 14.0,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              Center(
                                                child: Container(
                                                  width: 120,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    color: TColors.bubbleOrange,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20.0),
                                                    border: Border.all(
                                                      color: Colors.black,
                                                      width: 2.0,
                                                    ),
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      final journalItem =
                                                          JournalItem('',
                                                              id: item.id,
                                                              name:
                                                                  item.itemName,
                                                              price: item
                                                                  .itemPrice,
                                                              calories: item
                                                                  .itemCalories,
                                                              cafe: item
                                                                  .itemCafe);

                                                      String userId =
                                                          FoodJournalController
                                                              .instance
                                                              .getCurrentUserId();

                                                      foodJController
                                                          .addFoodToJournal(
                                                              userId,
                                                              journalItem);
                                                      Navigator.of(context)
                                                          .pop();
                                                      print(
                                                          'Add to journal pressed');
                                                    },
                                                    child: Text(
                                                      'ADD ',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Card(
                                      elevation: 0,
                                      color: TColors.cream,
                                      margin: const EdgeInsets.only(
                                          top: 10, right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          // Circular container for the image
                                          Container(
                                            width: 120,
                                            height: 120,
                                            decoration: BoxDecoration(
                                              color: TColors.mustard,
                                              borderRadius:
                                                  BorderRadius.circular(200),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.25),
                                                  spreadRadius: 2,
                                                  blurRadius: 10,
                                                  offset: const Offset(0, 4),
                                                ),
                                              ],
                                              image: item.itemImage != null &&
                                                      item.itemImage.isNotEmpty
                                                  ? DecorationImage(
                                                      image: NetworkImage(
                                                          item.itemImage),
                                                      fit: BoxFit.cover,
                                                    )
                                                  : null, // Add fallback for missing image
                                            ),
                                            child: item.itemImage == null ||
                                                    item.itemImage.isEmpty
                                                ? Center(
                                                    child: Icon(
                                                      Icons.fastfood,
                                                      size: 40,
                                                      color: Colors.white,
                                                    ),
                                                  )
                                                : null,
                                          ),
                                          // Text Details
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    item.itemName,
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Center(
                                                  child: Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.6),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    child: Text(
                                                      item.itemCafe,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      '\RM${item.itemPrice.toStringAsFixed(2)}',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Container(
                                                      width: 6,
                                                      height: 6,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                    SizedBox(width: 6),
                                                    Text(
                                                      '${item.itemCalories} cal',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
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
                                  );
                                },
                              ),
                            );
                          }
                        },
                      );
                    }),

                    // Journals (Label)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),
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
                        margin: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 20),
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.shop_add,
                                color: dark ? Colors.white : Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Food Journal',
                                style: TextStyle(
                                  color: dark ? Colors.white : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Iconsax.money_recive,
                                color: dark ? Colors.white : Colors.white,
                                size: 20,
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Money Journal',
                                style: TextStyle(
                                  color: dark ? Colors.white : Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
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
                    Obx(
                      () => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: advertController.allAdvertisements
                              .where((advertisement) {
                                // Filter logic: check if today is within the range of startDate and endDate
                                DateTime today = DateTime.now();
                                DateTime? startDate = advertisement.startDate;
                                DateTime? endDate = advertisement.endDate;

                                // If both dates are not null, check the range
                                if (startDate != null && endDate != null) {
                                  return today.isAfter(startDate) &&
                                          today.isBefore(endDate) ||
                                      today.isAtSameMomentAs(startDate) ||
                                      today.isAtSameMomentAs(endDate);
                                }
                                // If either date is null, exclude the advertisement
                                return false;
                              })
                              .toList()
                              .asMap()
                              .entries
                              .map((entry) {
                                int index = entry.key; // Get the index
                                Advertisement advertisement =
                                    entry.value; // Get the advertisement

                                // Format the DateTime to a string (you can customize the format)
                                String formattedStartDate = advertisement
                                            .startDate !=
                                        null
                                    ? "${advertisement.startDate!.day}-${advertisement.startDate!.month}-${advertisement.startDate!.year}"
                                    : "No Start Date"; // Handle null case
                                String formattedEndDate = advertisement
                                            .endDate !=
                                        null
                                    ? "${advertisement.endDate!.day}-${advertisement.endDate!.month}-${advertisement.endDate!.year}"
                                    : "No End Date"; // Handle null case

                                return Container(
                                  width: 300,
                                  height: 170,
                                  margin: const EdgeInsets.only(
                                    left: 20,
                                    right: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? TColors.tangerine
                                        : TColors.cobalt,
                                    borderRadius: BorderRadius.circular(
                                        20), // Increased border radius for a softer look
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                        20.0), // Added padding for better content spacing
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                advertisement.detail,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      20, // Adjusted font size
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${advertisement.cafeName} (${advertisement.location})',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      18, // Adjusted font size
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 15),
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  vertical: 2,
                                                  horizontal: 8,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: index.isEven
                                                      ? TColors.bubbleOrange
                                                      : TColors.bubbleBlue
                                                          .withOpacity(0.8),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Text(
                                                  '${formattedStartDate} until ${formattedEndDate}',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
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
                                );
                              })
                              .toList(), // Convert Iterable to List
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
      // ),
    );
  }
}
