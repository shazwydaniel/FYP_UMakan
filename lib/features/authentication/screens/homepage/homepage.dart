// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/recommendation_controller.dart';

import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/foodjournal/controller/badge_controller.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';

import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/all_advertisments.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';

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
    Get.put(BadgeController());

    final recommendedController = Get.put(RecommendationController());
    recommendedController
        .calculateAndStoreAverages(userController.user.value.id);
    final foodJController = Get.put(FoodJournalController());
    final userIdforMealReset = userController.user.value.id;

    if (userIdforMealReset != null && userIdforMealReset.isNotEmpty) {
      foodJController.resetMealStatesAtMidnight(userIdforMealReset);
      print("userId is ready. Reset meal states.");
    } else {
      print("Error: userId is null or empty. Cannot reset meal states.");
    }

    advertController.fetchAllAdvertisements();
    // print("FOOD JOURNAL ITEMS  : ${foodJController.mealItems}");
    // print("AMOUNT of completed days : ${foodJController.dayCount}");
    // print("RECOMMENDED STUFF  : ${recommendedController.getRecommendedList()}");

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
                  height: 600,
                  child: Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            // Title 1
                            Positioned(
                              top: 80,
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
                              top: 130,
                              left: 40,
                              child: Obx(
                                () => Text(
                                  "${userController.user.value.username}",
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: dark ? Colors.white : Colors.white,
                                  ),
                                ),
                              ),
                            ),

                            /*Positioned(
                              top: 50,
                              right: 30,
                              child: Container(
                                child: Obx(() {
                                  final controller =
                                      FoodJournalController.instance;

                                  // Get the appropriate badge widget
                                  return controller.getBadgeWidget(
                                      controller.dayCount.value);
                                }),
                              ),
                            ),*/
                          ],
                        ),
                      ),

                      // Stats Highlights (Label)
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30, right: 30, bottom: 15, top: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: TColors.bubbleRed,
                            borderRadius: BorderRadius.circular(20),
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

                              const SizedBox(height: 5),

                              // Current Date Line
                              Text(
                                'As per ${DateFormat('EEEE, d MMMM yyyy').format(DateTime.now())}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.white.withOpacity(0.8),
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
                                                                .updatedRecommendedAllowance);

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
                                      // User's Financial Status (Tag)
                                      Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Obx(() {
                                          return StreamBuilder<
                                              DocumentSnapshot>(
                                            stream: userController
                                                    .currentUserId.isEmpty
                                                ? null // Prevent Firestore query if ID is empty
                                                : FirebaseFirestore.instance
                                                    .collection('Users')
                                                    .doc(userController
                                                        .user.value.id)
                                                    .collection(
                                                        'financial_status')
                                                    .doc('current')
                                                    .snapshots(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(); // Loading indicator
                                              } else if (snapshot.hasError ||
                                                  !snapshot.hasData ||
                                                  !snapshot.data!.exists) {
                                                return Text(
                                                  ' No Data',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ); // Handle error or missing data
                                              } else {
                                                final financialStatus = snapshot
                                                    .data!
                                                    .get('status');

                                                Color statusColor;
                                                IconData statusIcon;
                                                String statusText;

                                                if (financialStatus ==
                                                    "Surplus") {
                                                  statusColor = TColors.teal
                                                      .withOpacity(0.7);
                                                  statusIcon =
                                                      Iconsax.emoji_happy;
                                                  statusText = "Surplus";
                                                } else if (financialStatus ==
                                                    "Moderate") {
                                                  statusColor = TColors.marigold
                                                      .withOpacity(0.7);
                                                  statusIcon =
                                                      Iconsax.emoji_normal;
                                                  statusText = "Moderate";
                                                } else {
                                                  statusColor = TColors.amber
                                                      .withOpacity(0.7);
                                                  statusIcon =
                                                      Iconsax.emoji_sad;
                                                  statusText = "Deficit";
                                                }

                                                // Show notification on status change
                                                // WidgetsBinding.instance
                                                //     .addPostFrameCallback((_) {
                                                //   Get.snackbar(
                                                //     "Financial Status Update",
                                                //     "You now have $statusText Food Allowance",
                                                //     snackPosition:
                                                //         SnackPosition.TOP,
                                                //     backgroundColor:
                                                //         statusColor,
                                                //     colorText: Colors.white,
                                                //     icon: Icon(statusIcon,
                                                //         color: Colors.white),
                                                //     duration:
                                                //         Duration(seconds: 3),
                                                //   );
                                                // });

                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: statusColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(statusIcon,
                                                          color: Colors.white,
                                                          size: 16),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        statusText,
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
                                              }
                                            },
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
                                      // User's Calorie Intake Status (Tag)
                                      /*Positioned(
                                        bottom: 0,
                                        right: 0,
                                        child: Obx(() {
                                          return FutureBuilder<
                                              DocumentSnapshot>(
                                            future: FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(userController
                                                    .user.value.id)
                                                .collection(
                                                    'calorie_intake_status')
                                                .doc('current')
                                                .get(),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return CircularProgressIndicator(); // Loading indicator
                                              } else if (snapshot.hasError ||
                                                  !snapshot.hasData ||
                                                  !snapshot.data!.exists) {
                                                return Text(
                                                  'No Data',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ); // Handle error or missing data
                                              } else {
                                                final calorieStatus = snapshot
                                                    .data!
                                                    .get('status');

                                                Color statusColor;
                                                IconData statusIcon;
                                                String statusText;

                                                if (calorieStatus ==
                                                    "Underconsumed") {
                                                  statusColor = TColors.amber
                                                      .withOpacity(0.7);
                                                  statusIcon =
                                                      Iconsax.emoji_sad;
                                                  statusText = "Underconsumed";
                                                } else if (calorieStatus ==
                                                    "Met Target") {
                                                  statusColor = TColors.teal
                                                      .withOpacity(0.7);
                                                  statusIcon =
                                                      Iconsax.emoji_happy;
                                                  statusText = "Met Target";
                                                } else {
                                                  statusColor = TColors.amber
                                                      .withOpacity(0.7);
                                                  statusIcon =
                                                      Iconsax.emoji_normal;
                                                  statusText = "Overconsumed";
                                                }

                                                return Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 5),
                                                  decoration: BoxDecoration(
                                                    color: statusColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Icon(statusIcon,
                                                          color: Colors.white,
                                                          size: 16),
                                                      const SizedBox(width: 5),
                                                      Text(
                                                        statusText,
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
                                              }
                                            },
                                          );
                                        }),
                                      ),*/
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
              padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
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
                            color: TColors.mustard,
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
                          Spacer(),
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: TColors.cream,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Stack(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 30, vertical: 30),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                // Title
                                                Text(
                                                  "Recommendations",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: TColors.charcoal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                const SizedBox(height: 15),

                                                // Description
                                                Text(
                                                  "Meals are recommended based on your average calories and spendings and preference choices",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: TColors.charcoal,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Exit Button (Top-right corner)
                                          Positioned(
                                            top: 10,
                                            right: 10,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    const Color.fromARGB(
                                                        0, 192, 186, 186),
                                                radius: 14,
                                                child: Icon(
                                                  Icons.close,
                                                  color: TColors.amber,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(right: 30),
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor:
                                    const Color.fromARGB(0, 192, 186, 186),
                                child: Icon(
                                  Icons.info_outline,
                                  color: TColors.charcoal,
                                  size: 26,
                                ),
                              ),
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
                        future: recommendedController
                            .getRecommendedList(userController.user.value.id),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(
                                child:
                                    CircularProgressIndicator()); // Loading indicator
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 10.0),
                                child: Text(
                                  'Add items to food journal or change preferences to view!',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ); // Empty list case
                          } else {
                            final recommendedMeals = snapshot.data!;
                            print('Recommended Meals: $recommendedMeals');

                            return Container(
                              height: 270,
                              margin: const EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
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
                                            backgroundColor: Colors.transparent,
                                            contentPadding: EdgeInsets.zero,
                                            content: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: TColors.cream,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 10,
                                                    offset: Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: Colors.black,
                                                          width:
                                                              2, // Border width
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(12),
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        child: item.itemImage
                                                                    .isNotEmpty &&
                                                                item.itemImage !=
                                                                    "default_image_url"
                                                            ? Image.network(
                                                                item.itemImage,
                                                                width: 200,
                                                                height: 200,
                                                                fit: BoxFit
                                                                    .cover,
                                                              )
                                                            : Container(
                                                                width: 200,
                                                                height: 200,
                                                                color: TColors
                                                                    .mustard,
                                                                child: Icon(
                                                                  Icons
                                                                      .fastfood,
                                                                  size: 100,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                      ),
                                                    ),
                                                  ),

                                                  // Details Section
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          item.itemName,
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(height: 8),
                                                        Text(
                                                          'Calories: ${item.itemCalories} kcal',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          'Price: RM${item.itemPrice.toStringAsFixed(2)}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        SizedBox(height: 4),
                                                        Text(
                                                          'Location: ${item.itemCafe}',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      if (item.isSpicy)
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 6),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  255, 134, 6),
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2)),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'S',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      if (item.isVegetarian)
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 6),
                                                          decoration: BoxDecoration(
                                                              color: const Color
                                                                  .fromARGB(255,
                                                                  70, 215, 75),
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2)),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'V',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ),
                                                      if (item.isLowSugar)
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 6),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  TColors.blush,
                                                              shape: BoxShape
                                                                  .circle,
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black,
                                                                  width: 2)),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            'LS',
                                                            style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),

                                                  // Buttons Section
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        // Cancel Button
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child: Text(
                                                            'Cancel',
                                                            style: TextStyle(
                                                              color: TColors
                                                                  .textDark,
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ),
                                                        // Add Button
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            final journalItem = JournalItem(
                                                                imagePath: item
                                                                    .itemImage,
                                                                id: item.id,
                                                                name: item
                                                                    .itemName,
                                                                price: item
                                                                    .itemPrice,
                                                                calories: item
                                                                    .itemCalories,
                                                                cafe: item
                                                                    .itemCafe,
                                                                vendorId: item
                                                                    .vendorId,
                                                                cafeId:
                                                                    item.cafeId,
                                                                cafeLocation: item
                                                                    .itemLocation,
                                                                isLowSugar: item
                                                                    .isLowSugar,
                                                                isSpicy: item
                                                                    .isSpicy,
                                                                isVegetarian: item
                                                                    .isVegetarian);

                                                            String userId =
                                                                FoodJournalController
                                                                    .instance
                                                                    .getCurrentUserId();

                                                            // Add the meal to the Food Journal
                                                            foodJController
                                                                .addFoodToJournal(
                                                                    userId,
                                                                    journalItem);

                                                            // Prepare expense data for the Money Journal
                                                            final expenseData =
                                                                {
                                                              'itemName':
                                                                  item.itemName,
                                                              'price': item
                                                                  .itemPrice,
                                                              'date': DateTime
                                                                      .now()
                                                                  .toIso8601String(),
                                                              'type': 'Food',
                                                            };

                                                            // Access UserController and add the expense
                                                            final userController =
                                                                UserController
                                                                    .instance;
                                                            userController
                                                                .addExpense(
                                                                    userId,
                                                                    'Food',
                                                                    expenseData);

                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                            print(
                                                                'Add to journal pressed');
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                TColors.mustard,
                                                            foregroundColor:
                                                                Colors.black,
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                              horizontal: 24,
                                                              vertical: 12,
                                                            ),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10),
                                                            ),
                                                            side: BorderSide(
                                                              color: Colors
                                                                  .black, // Border color
                                                              width:
                                                                  2, // Border width
                                                            ),
                                                          ),
                                                          child: Text(
                                                            'Add',
                                                            style: TextStyle(
                                                                fontSize: 16),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 15),
                                                ],
                                              ),
                                            ),
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
                                                      BorderRadius.circular(
                                                          200),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.25),
                                                      spreadRadius: 2,
                                                      blurRadius: 10,
                                                      offset:
                                                          const Offset(0, 4),
                                                    ),
                                                  ],
                                                  image: item.itemImage
                                                              .isNotEmpty &&
                                                          item.itemImage !=
                                                              "default_image_url"
                                                      ? DecorationImage(
                                                          image: NetworkImage(
                                                              item.itemImage),
                                                          fit: BoxFit.cover,
                                                        )
                                                      : null),
                                              child: item.itemImage.isEmpty ||
                                                      item.itemImage ==
                                                          "default_image_url"
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.fastfood,
                                                        size: 40,
                                                        color: Colors.white,
                                                      ),
                                                    )
                                                  : null),
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
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
                                                      color: TColors.mustard,
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
                                                Text(
                                                  item.itemLocation,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                // Preference Circles
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    if (item.isSpicy)
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: EdgeInsets.only(
                                                            right: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 255, 134, 6),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'S',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    if (item.isVegetarian)
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: EdgeInsets.only(
                                                            right: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: const Color
                                                              .fromARGB(
                                                              255, 70, 215, 75),
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'V',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    if (item.isLowSugar)
                                                      Container(
                                                        width: 24,
                                                        height: 24,
                                                        margin: EdgeInsets.only(
                                                            right: 6),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: TColors.blush,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                        alignment:
                                                            Alignment.center,
                                                        child: Text(
                                                          'LS',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 10,
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
                          left: 20, right: 20, bottom: 20, top: 10),
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
                        height: 180,
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
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Icon and "Food Journal"
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Iconsax.shop_add,
                                    color: dark ? Colors.white : Colors.white,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
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
                              const SizedBox(height: 10),
                              // White tag container for "Your Streaks"
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: TColors.bubbleRed,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Obx(
                                  () => FutureBuilder<int>(
                                    future: foodJController.fetchStreakCount(
                                        userController.user.value.id),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Text(
                                          'Loading streak...',
                                          style: TextStyle(
                                            color: TColors.textLight,
                                            fontSize: 13,
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text(
                                          'Error loading streak',
                                          style: TextStyle(
                                            color: TColors.textLight,
                                            fontSize: 13,
                                          ),
                                        );
                                      } else {
                                        final streakCount = snapshot.data ?? 0;
                                        final dayLabel =
                                            (streakCount == 1) ? 'day' : 'days';
                                        return Text(
                                          'Your Streaks: $streakCount $dayLabel',
                                          style: TextStyle(
                                            color: TColors.textLight,
                                            fontSize: 13,
                                          ),
                                        );
                                      }
                                    },
                                  ),
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
                      () {
                        final advertisements = advertController
                            .allAdvertisements
                            .where((advertisement) {
                          // Filter logic: check if today is within the range of startDate and endDate
                          DateTime today = DateTime.now();
                          DateTime? startDate = advertisement.startDate;
                          DateTime? endDate = advertisement.endDate;

                          // If both dates are not null, check the range
                          if (startDate != null && endDate != null) {
                            return today.isAfter(startDate
                                    .subtract(const Duration(days: 1))) &&
                                today.isBefore(
                                    endDate.add(const Duration(days: 1)));
                          }
                          // If either date is null, exclude the advertisement
                          return false;
                        }).toList();

                        if (advertisements.isEmpty) {
                          // Show a message if there are no advertisements
                          return Center(
                            child: Text(
                              "No advertisements currently available.",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        // Limit advertisements to 5
                        final displayedAds = advertisements.take(5).toList();

                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              // Display advertisements
                              ...displayedAds.asMap().entries.map((entry) {
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
                                      left: 20, right: 10),
                                  decoration: BoxDecoration(
                                    color: index.isEven
                                        ? TColors.tangerine
                                        : TColors.cobalt,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
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
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Text(
                                                '${advertisement.cafeName} (${advertisement.location})',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
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
                              }).toList(),

                              // Add the circular card with an arrow at the end
                              GestureDetector(
                                onTap: () {
                                  // Navigate to a page showing all advertisements
                                  Get.to(() => AllAdvertisementsPage());
                                },
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  margin: const EdgeInsets.only(
                                      left: 20, right: 10),
                                  decoration: BoxDecoration(
                                    color: TColors.teal,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    SizedBox(height: 20),
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
