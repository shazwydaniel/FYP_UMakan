import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodJournalController extends GetxController {
  static FoodJournalController get instance => Get.find();
  final FoodJournalRepository _foodJournalRepo = FoodJournalRepository.instance;

  var mealItems = <JournalItem>[].obs;
  var todayCalories = 0.obs;
  var yesterdayCalories = 0.obs;
  var isLoading = false.obs;

  var weekStartDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  // Store the weekly average in a variable
  double weeklyAverageCalories = 0.0;

  // List to store the daily average calories for each day of the week (7 days)
  List<double> dailyAverageCalories =
      List.filled(7, 0.0); // Initialize with 0.0 for each day

  List<double> averageCaloriesByMeal = [
    0.0,
    0.0,
    0.0,
    0.0
  ]; // Index 0: Breakfast, 1: Lunch, etc.
  Timer? _timer;

  // A map to store averageCalories for each meal type
  var averageCaloriesMap = <int, RxString>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Automatically calculate calories whenever lunchItems changes
    ever(mealItems, (_) {
      todayCalories.value = calculateTodayCalories();
      yesterdayCalories.value = calculateYesterdayCalories();
    });
  }

  Future<void> addFoodToJournal(String userId, JournalItem journalItem) async {
    try {
      // Convert the journalItem to a map (JSON)
      final foodData = journalItem.toJson();

      // Call the repository to add the item to Firestore
      await _foodJournalRepo.addFood(userId, foodData);

      // Add the item to the observable list after Firestore operation
      mealItems.add(journalItem);
      // Call after updating lunchItems

      // Print the contents of lunchItems to debug
      print("Lunch Items after adding new item: ${mealItems}");

      // Show success message with onTap to navigate
      Get.snackbar(
        'Success',
        'Item added to food journal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
        mainButton: TextButton(
          onPressed: () {
            // Navigate to the desired page
            Get.to(() => FoodJournalMainPage());
          },
          child: const Text(
            'View Journal',
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    } catch (e) {
      // Handle errors and show appropriate message
      Get.snackbar(
        'Error',
        'Failed to add item: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Fetch
  Future<void> fetchFoodJournalItems() async {
    try {
      // Fetch list of cafes from the repository
      final foodJournalList =
          await _foodJournalRepo.getFoodJournalItem(getCurrentUserId());

      // Check if cafes were found
      if (foodJournalList.isNotEmpty) {
        // Assign the fetched cafes to the observable list
        mealItems.assignAll(foodJournalList);
        print("Items Food Journal fetched: ${mealItems.length}");
      } else {
        print('No items found in Food Journal');
        mealItems.clear(); // Optionally clear if no cafes are found
      }
    } catch (e) {
      print('Error fetching cafes: $e');
      mealItems.clear(); // Handle error by clearing the list
    }
  }

  String getCurrentUserId() {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Return the user ID (UID)
      return user.uid;
    } else {
      // Handle the case when there is no user logged in
      throw Exception('No user is currently signed in');
    }
  }

  //Calculate calories for today
  int calculateTodayCalories() {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);

    // Filter items for today's date and sum their calories
    final todayItems = mealItems.where((item) {
      DateTime itemDate = DateTime(
          item.timestamp.year, item.timestamp.month, item.timestamp.day);
      return itemDate == startOfDay;
    }).toList();

    // Calculate total calories
    int totalCalories =
        todayItems.fold(0, (sum, item) => sum + (item.calories ?? 0));

    return totalCalories;
  }

  int calculateYesterdayCalories() {
    DateTime today = DateTime.now();

    // Get start of today (midnight)
    DateTime startOfDay = DateTime(today.year, today.month, today.day);

    // Get start of yesterday
    DateTime startOfYesterday = startOfDay.subtract(const Duration(days: 1));

    // Filter items for yesterday's date and sum their calories
    final yesterdayItems = mealItems.where((item) {
      DateTime itemDate = DateTime(
          item.timestamp.year, item.timestamp.month, item.timestamp.day);

      // Check if the item is from yesterday
      return itemDate == startOfYesterday;
    }).toList();

    // Calculate total calories for yesterday
    int totalCalories =
        yesterdayItems.fold(0, (sum, item) => sum + (item.calories ?? 0));

    return totalCalories;
  }

  //Delete Item
  Future<void> deleteJournalItem(String vendorId, String cafeId) async {
    try {
      await _foodJournalRepo.deleteItem(vendorId, cafeId);
      mealItems.removeWhere((lunchItem) => lunchItem.id == cafeId);

      print("Lunch Items after deleting new item: ${mealItems}");
    } catch (e) {
      // Handle error, maybe show a snackbar or dialog
      Get.snackbar('Error', 'Could not delete cafe: $e');
    }
  }

  int totalCalories(List<JournalItem> filteredItems) {
    int filteredStuff = filteredItems.fold<int>(
      0,
      (sum, item) => sum + (item.calories ?? 0), // Handle null safely
    );
    return filteredStuff;
  }

  // This method will filter the meal items based on meal type and week range
  List<JournalItem> averageCaloriesToday(int index) {
    DateTime now = DateTime.now();
    DateTime todayStart =
        DateTime(now.year, now.month, now.day); // Start of today
    DateTime todayEnd = todayStart
        .add(Duration(days: 1))
        .subtract(Duration(milliseconds: 1)); // End of today (23:59:59)

    return mealItems.where((item) {
      DateTime itemTime = item.timestamp;

      // Meal type filtering based on time ranges
      bool isInMealTimeRange = false;
      switch (index) {
        case 0: // Breakfast (6 AM - 12 PM)
          isInMealTimeRange = itemTime.hour >= 6 && itemTime.hour < 12;
          break;
        case 1: // Lunch (12 PM - 4 PM)
          isInMealTimeRange = itemTime.hour >= 11 && itemTime.hour < 15;
          break;
        case 2: // Dinner (7 PM - 9 PM)
          isInMealTimeRange = itemTime.hour >= 15 && itemTime.hour < 21;
          break;
        case 3: // Others (anything outside the above ranges)
          isInMealTimeRange = (itemTime.hour >= 16 && itemTime.hour < 19) ||
              (itemTime.hour >= 21 || itemTime.hour < 6);
          break;
        default:
          isInMealTimeRange = false;
      }

      // Date filtering: Ensure the item is from today
      DateTime itemDate = DateTime(itemTime.year, itemTime.month, itemTime.day);
      bool isInToday =
          itemDate.isAfter(todayStart.subtract(Duration(days: 1))) &&
              itemDate.isBefore(todayEnd.add(Duration(days: 1)));

      return isInMealTimeRange && isInToday;
    }).toList();
  }

  // Method to store average calories
  void storeAverageCalories(int index, String averageCalories) {
    // If the index is not already in the map, add it
    if (!averageCaloriesMap.containsKey(index)) {
      averageCaloriesMap[index] = RxString('0.00');
    }

    // Update the value for the corresponding index
    averageCaloriesMap[index]!.value = averageCalories;
    print('map : $averageCaloriesMap');
  }

  // Method to get stored average calories for a specific meal type
  int getStoredAverageCalories(int index) {
    // Check if the value exists for the given index
    if (averageCaloriesMap.containsKey(index)) {
      // Parse the stored string into a double and convert it to an int (rounding)
      print(
          'Got stored average value ${double.tryParse(averageCaloriesMap[index]!.value)?.toInt()}');
      return double.tryParse(averageCaloriesMap[index]!.value)?.toInt() ?? 0;
    }
    return 0; // Return 0 if no value exists
  }

/*
  Future<void> storeAverageCalories(int index, String averageCalories) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'averageCalories_$index'; // Key for each meal type
    prefs.setString(key, averageCalories); // Store the value
  }

  // Retrieve stored average calories:
  Future<String> getStoredAverageCalories(int index) async {
    final prefs = await SharedPreferences.getInstance();
    String key = 'averageCalories_$index'; // Key for each meal type
    return prefs.getString(key) ?? '0.00'; // Default to '0.00' if not found
  }*/
}
