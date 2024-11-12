import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FoodJournalController extends GetxController {
  static FoodJournalController get instance => Get.find();
  final FoodJournalRepository _foodJournalRepo = FoodJournalRepository.instance;

  var mealItems = <JournalItem>[].obs;
  var todayCalories = 0.obs;
  var yesterdayCalories = 0.obs;
  var isLoading = false.obs;
  final userController = UserController.instance;

  var weekStartDate =
      DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
  // Store the weekly average in a variable
  double weeklyAverageCalories = 0.0;

  // Cached averages for breakfast, lunch, dinner, and others
  var cachedAverageCalories = {0: '0.00', 1: '0.00', 2: '0.00', 3: '0.00'}.obs;

  // A map to store averageCalories for each meal type
  var averageCaloriesMap = <int, RxString>{}.obs;

  @override
  void onInit() {
    super.onInit();
    // Automatically calculate calories whenever mealItems changes
    ever(mealItems, (_) {
      todayCalories.value = calculateTodayCalories();
      yesterdayCalories.value = calculateYesterdayCalories();
    });

    // Fetch and initialize data, then update averageCaloriesMap and cached averages
    fetchFoodJournalItems().then((_) {
      for (int i = 0; i < 4; i++) {
        updateAndCacheAverageCalories(i);
      }
    });
  }

  Future<void> addFoodToJournal(String userId, JournalItem journalItem) async {
    try {
      final foodData = journalItem.toJson();
      await _foodJournalRepo.addFood(userId, foodData);
      mealItems.add(journalItem);
      print("Lunch Items after adding new item: ${mealItems}");

      // Update and cache average calories after adding a new item
      for (int i = 0; i < 4; i++) {
        updateAndCacheAverageCalories(i);
      }

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
      final foodJournalList =
          await _foodJournalRepo.getFoodJournalItem(getCurrentUserId());

      if (foodJournalList.isNotEmpty) {
        mealItems.assignAll(foodJournalList);
        print("Items Food Journal fetched: $mealItems");
      } else {
        print('No items found in Food Journal');
        mealItems.clear();
      }
    } catch (e) {
      print('Error fetching cafes: $e');
      mealItems.clear();
    }
  }

  String getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception('No user is currently signed in');
    }
  }

  int calculateTodayCalories() {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);

    final todayItems = mealItems.where((item) {
      DateTime itemDate = DateTime(
          item.timestamp.year, item.timestamp.month, item.timestamp.day);
      return itemDate == startOfDay;
    }).toList();

    return todayItems.fold(0, (sum, item) => sum + (item.calories ?? 0));
    ;
  }

  int calculateYesterdayCalories() {
    DateTime today = DateTime.now();
    DateTime startOfDay = DateTime(today.year, today.month, today.day);
    DateTime startOfYesterday = startOfDay.subtract(const Duration(days: 1));
    final yesterdayItems = mealItems.where((item) {
      DateTime itemDate = DateTime(
          item.timestamp.year, item.timestamp.month, item.timestamp.day);
      return itemDate == startOfYesterday;
    }).toList();
    return yesterdayItems.fold(0, (sum, item) => sum + (item.calories ?? 0));
  }

  //Delete Item
  Future<void> deleteJournalItem(String vendorId, String cafeId) async {
    try {
      await _foodJournalRepo.deleteItem(vendorId, cafeId);
      mealItems.removeWhere((lunchItem) => lunchItem.id == cafeId);
      print("Lunch Items after deleting new item: ${mealItems}");
      // Update cached averages after deletion
      for (int i = 0; i < 4; i++) {
        updateAndCacheAverageCalories(i);
      }
    } catch (e) {
      // Handle error, maybe show a snackbar or dialog
      Get.snackbar('Error', 'Could not delete cafe: $e');
    }
  }

  int totalCalories(List<JournalItem> filteredItems) {
    return filteredItems.fold<int>(
      0,
      (sum, item) => sum + (item.calories ?? 0),
    );
  }

  // This method will filter the meal items based on meal type and week range
  List<JournalItem> filterMealsTypesToday(int index) {
    DateTime now = DateTime.now();
    DateTime todayStart = DateTime(now.year, now.month, now.day);
    DateTime todayEnd =
        todayStart.add(Duration(days: 1)).subtract(Duration(milliseconds: 1));

    return mealItems.where((item) {
      DateTime itemTime = item.timestamp;

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
    print('updated calories map : $averageCaloriesMap');
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

  // Update and cache average calories for a specific meal type
  void updateAndCacheAverageCalories(int index) {
    List<JournalItem> items = filterMealsTypesToday(index);
    int totalCal = totalCalories(items);

    String averageCalories = items.isNotEmpty
        ? (totalCal / items.length).toStringAsFixed(2)
        : '0.00';

    // Cache the average for future use
    cachedAverageCalories[index] = averageCalories;
    storeAverageCalories(index, averageCalories);
  }

  double calculateBMR() {
    final weight = double.tryParse(userController.user.value.weight) ?? 0.0;
    final height = double.tryParse(userController.user.value.height) ?? 0.0;
    final age = userController.user.value.age;
    final gender = userController.user.value.gender;

    double bmr;

    if (gender == 'Male') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) + 5;
    } else if (gender == 'Female') {
      bmr = (10 * weight) + (6.25 * height) - (5 * age) - 161;
    } else {
      throw Exception("Invalid gender"); // Optional: Handle invalid gender
    }

    return bmr;
  }
}
