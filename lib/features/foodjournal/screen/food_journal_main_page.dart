// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class FoodJournalMainPage extends StatelessWidget {
  const FoodJournalMainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(JournalController());
    final foodJController = Get.put(FoodJournalController());

    foodJController.fetchFoodJournalItems();

    return Scaffold(
      backgroundColor: TColors.amber,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          backgroundColor: dark ? TColors.amber : TColors.amber,
          elevation: 0,
          leading: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back,
                    color: dark ? Colors.white : Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 0),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text and Description Column
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Food',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                          Text(
                            'Journal',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                          Text(
                            'Track and Log Your Meals.',
                            style: TextStyle(
                              fontSize: 15,
                              color: dark ? Colors.white : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      // Icon
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Icon(
                          Iconsax.flash,
                          size: 70,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //Today (Text)
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 20, top: 30),
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
                    'Today',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Display Today Items (Cards)
            Obx(() {
              // Get today's date without time (midnight)
              DateTime today = DateTime.now();
              DateTime startOfDay =
                  DateTime(today.year, today.month, today.day);

              // Filter items to show only those added today
              final filteredLunchItems = foodJController.lunchItems
                  .where((item) => item.timestamp.isAfter(startOfDay))
                  .toList();

              return Container(
                height: 230,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredLunchItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredLunchItems[index];
                    // Format the timestamp into a readable string
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(item.timestamp);

                    return SizedBox(
                      width: 220,
                      height: 250, // Width of each card
                      child: Card(
                        elevation: 0, // Optional: Add elevation if you want
                        color: TColors.amber, // Set card color to transparent
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        margin: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 120, // Height for the image
                              decoration: BoxDecoration(
                                color: TColors.mustard,
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.white, // Make text white
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4), // Space between texts
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.cafe,
                                        style: TextStyle(
                                          color: dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4), // Space between texts
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\RM${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: TColors.cream,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${item.calories} cal',
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 50),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
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
            }),
            //Lunch History (Text)
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 20, top: 10),
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
                    'History',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Display History Items (Cards)
            Obx(() {
              // Get previous's date without time (midnight)
              DateTime today = DateTime.now();
              DateTime startOfDay =
                  DateTime(today.year, today.month, today.day);

              // Filter items to show only those added previously
              final filteredLunchItems = foodJController.lunchItems
                  .where((item) => item.timestamp.isBefore(startOfDay))
                  .toList();

              return Container(
                height: 230,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredLunchItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredLunchItems[index];
                    // Format the timestamp into a readable string
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(item.timestamp);

                    return SizedBox(
                      width: 220,
                      height: 250, // Width of each card
                      child: Card(
                        elevation: 0, // Optional: Add elevation if you want
                        color: TColors.amber, // Set card color to transparent
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        margin: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 120, // Height for the image
                              decoration: BoxDecoration(
                                color: TColors.mustard,
                                borderRadius: BorderRadius.circular(200),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      item.name,
                                      style: const TextStyle(
                                        color: Colors.white, // Make text white
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4), // Space between texts
                                  Center(
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.cafe,
                                        style: TextStyle(
                                          color: dark
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 4), // Space between texts
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '\RM${item.price.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: TColors.cream,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        '${item.calories} cal',
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 50),
                                      Text(
                                        formattedDate,
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  )
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
            }),
          ],
        ),
      ),
    );
  }
}
