import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/discover/screens/discover.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_history.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/navigation_menu.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class FoodJournalMainPage extends StatefulWidget {
  const FoodJournalMainPage({super.key});

  @override
  _FoodJournalMainPageState createState() => _FoodJournalMainPageState();
}

class _FoodJournalMainPageState extends State<FoodJournalMainPage> {
  @override
  void initState() {
    super.initState();
    // Load initial data here if necessary
  }

  void refreshData() {
    setState(() {
      // Trigger a rebuild to refresh the data
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final foodJController = Get.put(FoodJournalController());

    foodJController.fetchFoodJournalItems();
    String userId = foodJController.getCurrentUserId();

    List<JournalItem> filteredItems;

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
              padding: const EdgeInsets.only(
                left: 40,
                right: 40,
              ),
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
              final filteredItems = foodJController.mealItems
                  .where((item) => item.timestamp.isAfter(startOfDay))
                  .toList();

              // Check if there are no items logged yesterday
              if (filteredItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Text(
                      "No meals logged yet today",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .white, // Adjust the color based on your theme
                      ),
                    ),
                  ),
                );
              }

              return Container(
                height: 260,
                margin: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredItems.length,
                  itemBuilder: (context, index) {
                    final item = filteredItems[index];

                    return GestureDetector(
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Delete Meal from Journal'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Close'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    foodJController.deleteJournalItem(
                                        userId, item.id!);
                                    Navigator.of(context)
                                        .pop(); // Close the dialog
                                  },
                                  child: Text('Delete'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: SizedBox(
                        width: 190,
                        height: 250,
                        child: Card(
                          elevation: 0,
                          color: TColors.amber,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          margin: const EdgeInsets.only(right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: TColors.mustard,
                                  borderRadius: BorderRadius.circular(200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.25),
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipOval(
                                  child: item.imagePath != null &&
                                          item.imagePath.isNotEmpty
                                      ? Image.network(
                                          item.imagePath,
                                          fit: BoxFit.fill,
                                        )
                                      : Center(
                                          child: Icon(
                                            Icons.fastfood,
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                        ),
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
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          color:
                                              Colors.white, // Make text white
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 4), // Space between texts
                                    Center(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        decoration: BoxDecoration(
                                          color: TColors.mustard,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          item.cafe,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                    Center(
                                      child: Text(
                                        '${DateFormat('h:mm a').format(item.timestamp)} ',
                                        style: TextStyle(
                                          color: dark
                                              ? TColors.cream
                                              : TColors.cream,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                        height: 8), // Space before the circles
                                    // Preference Circles
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        if (item.isSpicy)
                                          Container(
                                            width: 24,
                                            height: 24,
                                            margin: EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 255, 134, 6),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'S',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        if (item.isVegetarian)
                                          Container(
                                            width: 24,
                                            height: 24,
                                            margin: EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 70, 215, 75),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'V',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        if (item.isLowSugar)
                                          Container(
                                            width: 24,
                                            height: 24,
                                            margin: EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              color: TColors.blush,
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'LS',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
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
                      ),
                    );
                  },
                ),
              );
            }),
            //Meal Yesterday (Text)
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
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
                ],
              ),
            ),

            // Display Yesterday Items (Cards)
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
                  foodJController.mealItems.where((item) {
                DateTime itemTime = item.timestamp;
                return itemTime.isAfter(startOfYesterday) &&
                    itemTime.isBefore(endOfYesterday);
              }).toList();

              // Check if there are no items logged yesterday
              if (filteredLunchItems.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                    child: Text(
                      "No meals logged yesterday",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors
                            .white, // Adjust the color based on your theme
                      ),
                    ),
                  ),
                );
              }

              return Container(
                height: 260,
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
                      width: 190,
                      height: 250,
                      child: Card(
                        elevation: 0,
                        color: TColors.amber,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        margin: const EdgeInsets.only(right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: TColors.mustard,
                                borderRadius: BorderRadius.circular(200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: item.imagePath != null &&
                                        item.imagePath.isNotEmpty
                                    ? Image.network(
                                        item.imagePath,
                                        fit: BoxFit.cover,
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 50,
                                          color: Colors.white,
                                        ),
                                      ),
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
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
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
                                        color: TColors.mustard,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        item.cafe,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
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
                                  Center(
                                    child: Text(
                                      '${DateFormat('h:mm a').format(item.timestamp)} cal',
                                      style: TextStyle(
                                        color: dark
                                            ? TColors.cream
                                            : TColors.cream,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (item.isSpicy)
                                        Container(
                                          width: 24,
                                          height: 24,
                                          margin: EdgeInsets.only(right: 6),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 255, 134, 6),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'S',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      if (item.isVegetarian)
                                        Container(
                                          width: 24,
                                          height: 24,
                                          margin: EdgeInsets.only(right: 6),
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 70, 215, 75),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'V',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      if (item.isLowSugar)
                                        Container(
                                          width: 24,
                                          height: 24,
                                          margin: EdgeInsets.only(right: 6),
                                          decoration: BoxDecoration(
                                            color: TColors.blush,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white, width: 2),
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'LS',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 10,
                                            ),
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

            //Summary Section
            Obx(() {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Logic to calculate and store average calories after the current frame is rendered
                for (int index = 0; index < 4; index++) {
                  final filteredItems =
                      foodJController.filterMealsTypesToday(index);
                  final totalCalories =
                      foodJController.totalCalories(filteredItems);

                  final averageCalories = filteredItems.isNotEmpty
                      ? (totalCalories / filteredItems.length)
                          .toStringAsFixed(2)
                      : '0.00';

                  foodJController.storeAverageCalories(index, averageCalories);

                  // Debugging prints for dailyCalories and weeklyAverages
                  print("Daily total for ${[
                    'Breakfast',
                    'Lunch',
                    'Dinner',
                    'Others'
                  ][index]}: $totalCalories");
                  print("Daily average for ${[
                    'Breakfast',
                    'Lunch',
                    'Dinner',
                    'Others'
                  ][index]}: $averageCalories");
                }
                // Print out the weeklyAverages map for debugging
                print("Weekly Averages: ${foodJController.weeklyAverages}");
              });

              return Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 10,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(4, (index) {
                    final filteredItems =
                        foodJController.filterMealsTypesToday(index);
                    final totalCalories =
                        foodJController.totalCalories(filteredItems);

                    // Calculate average calories
                    final dailyAverageCalories = filteredItems.isNotEmpty
                        ? (totalCalories / filteredItems.length)
                            .toStringAsFixed(2)
                        : '0.00';

                    // Weekly average calories from weeklyAverages map in the controller
                    final mealType =
                        ['breakfast', 'lunch', 'dinner', 'others'][index];
                    final weeklyAverageCalories = foodJController
                            .weeklyAverages[mealType]
                            ?.toStringAsFixed(2) ??
                        '0.00';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.only(left: 10),
                      child: Card(
                        elevation: 4,
                        color: TColors.cream,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JournalHistoryPage(
                                  mealType: [
                                    'Breakfast',
                                    'Lunch',
                                    'Dinner',
                                    'Others'
                                  ][index],
                                  allItems: foodJController
                                      .mealItems, // Pass items for the selected meal type
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context)
                                .size
                                .width, // Set card width
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      [
                                        'Breakfast',
                                        'Lunch',
                                        'Dinner',
                                        'Others'
                                      ][index],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      'Avg. cal/meal',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Total: $totalCalories cal',
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      '$dailyAverageCalories',
                                      style: const TextStyle(
                                        color: TColors.amber,
                                        fontSize: 20,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
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
      bottomNavigationBar: BottomAppBar(
        color: TColors.mustard,
        shape: CircularNotchedRectangle(),
        notchMargin: 0.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Iconsax.add_circle,
                          color: TColors.textDark, size: 40),
                      onPressed: () {
                        manualAdd(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void manualAdd(BuildContext context) {
    final TextEditingController itemName = TextEditingController();
    final TextEditingController itemCalories = TextEditingController();
    final TextEditingController itemPrice = TextEditingController();
    final TextEditingController itemLocation = TextEditingController();

    final foodJController2 = FoodJournalController.instance;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text("Add Meals",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    )),
              ),
              SizedBox(width: 100),
            ],
          ),

          backgroundColor: TColors.cream,
          // Title for the dialog
          content: SizedBox(
            height: 350,
            width: 200,
            child: Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10),
                  TextFormField(
                    controller: itemName,
                    decoration: InputDecoration(
                      labelText: 'Meal Name', // Label for the Meal Name field
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TextFormField(
                    controller: itemCalories,
                    decoration: InputDecoration(
                      labelText: 'Amount of Calories',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TextFormField(
                    controller: itemPrice,
                    decoration: InputDecoration(
                      labelText: 'Cost',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TextFormField(
                    controller: itemLocation,
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            Center(
              child: Container(
                width: 120,
                height: 50,
                decoration: BoxDecoration(
                  color: TColors.mustard,
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: TextButton(
                  onPressed: () async {
                    final uuid = Uuid();
                    // Add selected item to the food journal
                    final journalItem = JournalItem(
                      id: uuid.v4(),
                      name: itemName.text.trim(),
                      price: double.tryParse(itemPrice.text.trim()) ?? 0.0,
                      calories: int.tryParse(itemCalories.text.trim()) ?? 0,
                      cafe: itemLocation.text.trim(),
                      imagePath: '',
                      cafeId: '',
                      vendorId: '',
                      cafeLocation: '',
                      isUserGenerated: true,
                    );

                    String userId =
                        FoodJournalController.instance.getCurrentUserId();

                    // Optionally, add the item to the local lunch list
                    foodJController2.addFoodToJournal(userId, journalItem);

                    // Prepare expense data for the Money Journal
                    final expenseData = {
                      'itemName': itemName.text.trim(),
                      'price': double.tryParse(itemPrice.text.trim()) ?? 0.0,
                      'date': DateTime.now().toIso8601String(),
                      'type': 'Food',
                    };

                    // Access UserController and add the expense
                    final userController = UserController.instance;
                    userController.addExpense(userId, 'Food', expenseData);

                    try {
                      print('Meal added to food and money journal!');

                      // Close the dialog
                      Navigator.of(context).pop();
                    } catch (e) {
                      print('Error adding meal to journal: $e');
                    }
                  },
                  child: Text(
                    'ADD MEAL',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
