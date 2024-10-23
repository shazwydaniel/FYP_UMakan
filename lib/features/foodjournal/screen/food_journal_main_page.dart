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

    // Helper function to get the week number of the year
    int getWeekNumber(DateTime date) {
      var firstDayOfYear = DateTime(date.year, 1, 1);
      var dayOfYear = date.difference(firstDayOfYear).inDays + 1;
      return ((dayOfYear - date.weekday + 10) / 7).floor();
    }

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
                        padding: const EdgeInsets.only(top: 15, right: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            shape:
                                BoxShape.circle, // Make the container circular
                            color: Colors
                                .transparent, // Set a transparent background
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(
                                50), // Set border radius for ripple effect
                            onTap: () {
                              // Show the pop-up dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text(
                                        'Your Title Here'), // Set your dialog title
                                    content: Text(
                                        'Your pop-up content here.'), // Set your dialog content
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .pop(); // Close the dialog
                                        },
                                        child: Text('Close'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Iconsax.shop_add,
                              size: 75,
                              color: Colors.white,
                            ),
                          ),
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
                  left: 30, right: 30, bottom: 10, top: 20),
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
                  const SizedBox(width: 5),
                  Obx(
                    () => Text(
                      '(${foodJController.todayCalories} cal)',
                      style: TextStyle(
                        fontSize: 15,
                        color: dark ? Colors.white : Colors.white,
                      ),
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
                    // Format the timestamp to display only the time in 12-hour format with AM/PM
                    String formattedTime =
                        DateFormat('hh:mm a').format(item.timestamp);

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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.25), // Shadow color with opacity
                                    spreadRadius:
                                        2, // How much the shadow spreads
                                    blurRadius: 10, // How blurry the shadow is
                                    offset: const Offset(
                                        0, 4), // Horizontal and vertical offset
                                  ),
                                ],
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
                                        fontSize: 14,
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
                                          fontSize: 14,
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
                                          fontSize: 14,
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
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 70),
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 14,
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
            //Meal Yesterday (Text)
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 10, top: 10),
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
                    'Yesterday',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Obx(
                    () => Text(
                      '(${foodJController.yesterdayCalories.value} cal)',
                      style: TextStyle(
                        fontSize: 15,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Display History Items (Cards)
            Obx(() {
              // Get previous's date without time (midnight)
              DateTime today = DateTime.now();
              DateTime startOfDay =
                  DateTime(today.year, today.month, today.day);

              // Get the start and end of yesterday
              DateTime startOfYesterday =
                  startOfDay.subtract(const Duration(days: 1));
              DateTime endOfYesterday =
                  startOfDay.subtract(const Duration(seconds: 1));

              // Filter items to show only those added on yesterday
              final filteredLunchItems =
                  foodJController.lunchItems.where((item) {
                DateTime itemTime = item.timestamp;
                return itemTime.isAfter(startOfYesterday) &&
                    itemTime.isBefore(endOfYesterday);
              }).toList();

              return Container(
                height: 230,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredLunchItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredLunchItems[index];
                    // Format the timestamp into a readable string
                    String formattedTime =
                        DateFormat('hh:mm a').format(item.timestamp);

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
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(
                                        0.25), // Shadow color with opacity
                                    spreadRadius:
                                        2, // How much the shadow spreads
                                    blurRadius: 10, // How blurry the shadow is
                                    offset: const Offset(
                                        0, 4), // Horizontal and vertical offset
                                  ),
                                ],
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
                                        fontSize: 14,
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
                                          fontSize: 14,
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
                                          fontSize: 14,
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
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 70),
                                      Text(
                                        formattedTime,
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 14,
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
            //Meal Summary (Text)
            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 10, top: 10),
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
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Meal Summary (Card)
            Obx(() {
              // List of meal labels
              final mealLabels = ['Breakfast', 'Lunch', 'Dinner', 'Others'];

              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Align cards to the start
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align to the left
                  children: List.generate(4, (index) {
                    // Filter the items based on meal type and time ranges
                    final filteredItems =
                        foodJController.lunchItems.where((item) {
                      DateTime itemTime = item.timestamp;

                      switch (index) {
                        case 0: // Breakfast (6 AM - 11 AM)
                          return itemTime.hour >= 6 && itemTime.hour < 11;
                        case 1: // Lunch (11 AM - 3 PM)
                          return itemTime.hour >= 11 && itemTime.hour < 15;
                        case 2: // Dinner (3 PM - 9 PM)
                          return itemTime.hour >= 15 && itemTime.hour < 21;
                        case 3: // Others (anything outside the above ranges)
                          return itemTime.hour < 6 || itemTime.hour >= 21;
                        default:
                          return false;
                      }
                    }).toList();

                    // Group filtered items by week and day
                    Map<int, Map<DateTime, List<dynamic>>> itemsByWeek = {};

                    for (var item in filteredItems) {
                      DateTime itemDate = DateTime(item.timestamp.year,
                          item.timestamp.month, item.timestamp.day);

                      // Get the week number of the item
                      int weekNumber = getWeekNumber(itemDate);

                      // Initialize the week group if it doesn't exist
                      if (!itemsByWeek.containsKey(weekNumber)) {
                        itemsByWeek[weekNumber] = {};
                      }

                      // Initialize the day group within the week
                      if (!itemsByWeek[weekNumber]!.containsKey(itemDate)) {
                        itemsByWeek[weekNumber]![itemDate] = [];
                      }

                      // Add the item to the respective week and day
                      itemsByWeek[weekNumber]![itemDate]!.add(item);
                    }

                    // Calculate the total calories and total unique days per week
                    int totalWeeklyCalories = 0;
                    int totalUniqueDays = 0;

                    itemsByWeek.forEach((weekNumber, daysMap) {
                      int weeklyCalories =
                          0; // To hold the sum of calories for the week
                      int uniqueDaysInWeek =
                          daysMap.keys.length; // Unique days in the week

                      // Sum up the calories for this week
                      daysMap.forEach((day, items) {
                        // Ensure you handle item.calories safely as a num
                        weeklyCalories += items.fold<num>(0, (sum, item) {
                          // Check if item.calories is not null and cast it to int if necessary
                          return sum +
                              (item.calories ?? 0)
                                  .toInt(); // Convert to int to avoid type issues
                        }).toInt(); // Cast the final sum to int for consistency
                      });

                      // Add to total calories and day count
                      totalWeeklyCalories += weeklyCalories;
                      totalUniqueDays += uniqueDaysInWeek;
                    });

                    // Calculate the total calories for the previous week for the current meal type
                    int previousWeekCalories = 0;
                    int previousUniqueDays = 0;

                    // Calculate the previous week's total calories and unique days
                    final previousWeekStart = DateTime.now()
                        .subtract(Duration(days: 14)); // Start from 14 days ago
                    final previousWeekEnd = DateTime.now()
                        .subtract(Duration(days: 7)); // End at 7 days ago

                    // Filter items for the previous week for the specific meal type
                    for (var item in foodJController.lunchItems) {
                      DateTime itemDate = DateTime(item.timestamp.year,
                          item.timestamp.month, item.timestamp.day);

                      // Check if the item is in the previous week
                      if (itemDate.isAfter(previousWeekStart) &&
                          itemDate.isBefore(previousWeekEnd)) {
                        // Filter based on meal type
                        switch (index) {
                          case 0: // Breakfast
                            if (item.timestamp.hour >= 6 &&
                                item.timestamp.hour < 11) {
                              previousWeekCalories +=
                                  item.calories ?? 0; // Handle null safely
                              previousUniqueDays++;
                            }
                            break;
                          case 1: // Lunch
                            if (item.timestamp.hour >= 11 &&
                                item.timestamp.hour < 15) {
                              previousWeekCalories +=
                                  item.calories ?? 0; // Handle null safely
                              previousUniqueDays++;
                            }
                            break;
                          case 2: // Dinner
                            if (item.timestamp.hour >= 15 &&
                                item.timestamp.hour < 21) {
                              previousWeekCalories +=
                                  item.calories ?? 0; // Handle null safely
                              previousUniqueDays++;
                            }
                            break;
                          case 3: // Others
                            if (item.timestamp.hour < 6 ||
                                item.timestamp.hour >= 21) {
                              previousWeekCalories +=
                                  item.calories ?? 0; // Handle null safely
                              previousUniqueDays++;
                            }
                            break;
                        }
                      }
                    }

                    // Calculate the weekly daily average calories for the previous week
                    final previousWeeklyDailyAverageCalories =
                        previousUniqueDays > 0
                            ? (previousWeekCalories / previousUniqueDays)
                                .round()
                            : 0;

                    // Calculate the total calories for each meal type
                    final totalCalories = filteredItems.fold<int>(
                      0,
                      (sum, item) =>
                          sum + (item.calories ?? 0), // Handle null safely
                    );

                    return Container(
                      margin: const EdgeInsets.only(
                          bottom: 10), // Space between lists
                      padding: const EdgeInsets.only(left: 10),
                      child: Card(
                        elevation: 4, // Add elevation for better visual
                        color: TColors.mustard, // Card color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          width: MediaQuery.of(context)
                              .size
                              .width, // Set card width
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Row to align meal label on the left and other info on the right
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    mealLabels[index], // Meal label
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // Add any text you want on the right side
                                  Text(
                                    'Daily Avg. Cal', // Replace with your right-side text
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8), // Space between texts
                              // Row to align "Daily Average" on the left and another text on the right
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: $totalCalories cal', // Weekly average calories
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                  // Add another text on the right side

                                  Text(
                                    '$previousWeeklyDailyAverageCalories cal', // Replace with right-side info
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8), // Space between texts
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
