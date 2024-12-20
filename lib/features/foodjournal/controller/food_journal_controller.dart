import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/student_management/screens/badge_unlock_popup.dart';
import 'package:fyp_umakan/main.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../data/repositories/food_journal/badge_repository.dart';

class FoodJournalController extends GetxController {
  static FoodJournalController get instance => Get.find();

  final FoodJournalRepository _foodJournalRepo = FoodJournalRepository.instance;
  final BadgeRepository badgeRepo = BadgeRepository.instance;

  var mealItems = <JournalItem>[].obs;
  var todayCalories = 0.obs;
  var yesterdayCalories = 0.obs;
  var isLoading = false.obs;
  final userController = UserController.instance;
  var completedDays = 0.obs;

  // Meal type counts
  RxInt breakfastCount = 0.obs;
  RxInt lunchCount = 0.obs;
  RxInt dinnerCount = 0.obs;
  RxInt othersCount = 0.obs;

  // Store daily calories for each meal type
  Map<String, Map<String, int>> dailyCalories = {
    'breakfast': {},
    'lunch': {},
    'dinner': {},
    'others': {},
  };

  // Store weekly averages for each meal type
  RxMap<String, double> weeklyAverages = {
    'breakfast': 0.0,
    'lunch': 0.0,
    'dinner': 0.0,
    'others': 0.0,
  }.obs;

  final storage = GetStorage();

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
    //monitorBadgeUnlock();
    print("MEAL ITEMS $mealItems");
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

    // Fetch food journal items and initialize data
    fetchFoodJournalItems().then((_) {
      updateDailyCalories();
      calculateWeeklyAverages();
    });
  }

  void testFoodLogAnalysis() async {
    final userId = userController.user.value.id; // Current user's ID
    final analysis = await _foodJournalRepo.analyzeFoodLogs(userId);
    print("Food Frequency: ${analysis['foodFrequency']}");
    print("Location Frequency: ${analysis['locationFrequency']}");
  }

  Future<void> addFoodToJournal(String userId, JournalItem journalItem) async {
    try {
      final foodData = journalItem.toJson();
      await _foodJournalRepo.addFood(userId, foodData);

      mealItems.add(journalItem);

      for (int i = 0; i < 4; i++) {
        updateAndCacheAverageCalories(i);
      }

      trackMealAndDayCount(DateTime.parse(foodData['timestamp']));

      // Show success message with onTap to navigate
      Get.snackbar(
        'Success',
        'Item added to food journal',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        margin: const EdgeInsets.all(10),
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
      final userId = getCurrentUserId();
      print("Fetching Food Journal Items for User ID: $userId");

      print("Raw Food Journal List: $foodJournalList");

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
      print("Current User ID: ${user.uid}");
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
          isInMealTimeRange = itemTime.hour >= 12 && itemTime.hour < 16;
          break;
        case 2: // Dinner (7 PM - 9 PM)
          isInMealTimeRange = itemTime.hour >= 19 && itemTime.hour < 21;
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

  //  Method to calculate daily calories for each meal type
  void updateDailyCalories() {
    DateTime today = DateTime.now();
    String todayKey = DateFormat('yyyy-MM-dd').format(today);

    // Initialize or update daily totals for each meal type
    dailyCalories['breakfast']![todayKey] =
        calculateTotalCaloriesForMealType(0);
    dailyCalories['lunch']![todayKey] = calculateTotalCaloriesForMealType(1);
    dailyCalories['dinner']![todayKey] = calculateTotalCaloriesForMealType(2);
    dailyCalories['others']![todayKey] = calculateTotalCaloriesForMealType(3);

    // Store daily calories in persistent storage for weekly calculations
    storage.write('dailyCalories', dailyCalories);
  }

  // Helper method to calculate total calories for a meal type index
  int calculateTotalCaloriesForMealType(int index) {
    List<JournalItem> items = filterMealsTypesToday(index);
    return items.fold(0, (sum, item) => sum + (item.calories ?? 0));
  }

  void calculateWeeklyAverages() {
    DateTime today = DateTime.now();
    int currentWeekday = today.weekday;

    if (currentWeekday == DateTime.monday) {
      // Only calculate weekly averages on Mondays

      // Calculate the average calories for the previous week
      weeklyAverages['breakfast'] = calculateAverageForMealType('breakfast');
      weeklyAverages['lunch'] = calculateAverageForMealType('lunch');
      weeklyAverages['dinner'] = calculateAverageForMealType('dinner');
      weeklyAverages['others'] = calculateAverageForMealType('others');

      // Store the weekly averages in persistent storage
      storage.write('weeklyAverages', weeklyAverages);

      // Reset daily calories map for the new week
      resetDailyCalories();
    }
  }

  // Helper to calculate average calories for a given meal type
  double calculateAverageForMealType(String mealType) {
    var dailyTotals = dailyCalories[mealType]!.values;
    if (dailyTotals.isEmpty) return 0.0;
    int totalCalories = dailyTotals.reduce((sum, value) => sum + value);
    return totalCalories / dailyTotals.length;
  }

  // Reset daily calories data for the new week
  void resetDailyCalories() {
    dailyCalories = {
      'breakfast': {},
      'lunch': {},
      'dinner': {},
      'others': {},
    };
    storage.write('dailyCalories', dailyCalories);
  }

  Future<String> getMostLoggedCafeForVendor(String vendorId) async {
    final Map<String, int> cafeLogs =
        await _foodJournalRepo.getCafeLogsByVendor(vendorId);

    String mostLoggedCafe = '';
    int maxLogs = 0;

    cafeLogs.forEach((cafe, count) {
      if (count > maxLogs) {
        mostLoggedCafe = cafe;
        maxLogs = count;
      }
    });

    return mostLoggedCafe.isNotEmpty ? mostLoggedCafe : 'N/A';
  }

  Future<void> trackMealAndDayCount(DateTime timestamp) async {
    final now = DateTime.now();
    bool hasLoggedMealToday = false; // Local flag for this method

    // Check if it's a new day
    if (PersistentData.lastUpdatedDate.day != now.day ||
        PersistentData.lastUpdatedDate.month != now.month ||
        PersistentData.lastUpdatedDate.year != now.year) {
      //Check if user logged at least 3 meals types yesterday
      final prefs = await SharedPreferences.getInstance();
      final hasLoggedYesterday =
          prefs.getBool('hasLoggedMealYesterday') ?? false;

      //Reset day count if user did not complete previous day
      if (!hasLoggedYesterday) {
        PersistentData.dayCount = 0;
        print("Day count reset due to inactivity.");
      } else {
        print("User logged at least 3 meal types yesterday. Streak continues.");
      }

      // Reset meal counts
      await prefs.setBool('hasLoggedMealYesterday', false);
      breakfastCount.value = 0;
      lunchCount.value = 0;
      dinnerCount.value = 0;
      othersCount.value = 0;
      await PersistentData.saveData(PersistentData.dayCount, now);
    }

    // Determine meal type based on timestamp and mark it as logged
    if (timestamp.hour >= 6 && timestamp.hour < 12) {
      breakfastCount.value = 1;
      hasLoggedMealToday = true;
    } else if (timestamp.hour >= 12 && timestamp.hour < 16) {
      lunchCount.value = 1;
      hasLoggedMealToday = true;
    } else if (timestamp.hour >= 19 && timestamp.hour < 21) {
      dinnerCount.value = 1;
      hasLoggedMealToday = true;
    } else if ((timestamp.hour >= 0 && timestamp.hour < 6) ||
        (timestamp.hour >= 21) ||
        (timestamp.hour >= 16 && timestamp.hour < 19)) {
      othersCount.value = 1;
      hasLoggedMealToday = true;
    }

    // Count how many distinct meal types have been logged
    int distinctMealTypes = 0;
    if (breakfastCount.value > 0) distinctMealTypes++;
    if (lunchCount.value > 0) distinctMealTypes++;
    if (dinnerCount.value > 0) distinctMealTypes++;
    if (othersCount.value > 0) distinctMealTypes++;

    print("Breakfast count: ${breakfastCount.value}");
    print("Lunch count: ${lunchCount.value}");
    print("Dinner count: ${dinnerCount.value}");
    print("Other count: ${othersCount.value}");

    // Increment `dayCount` only when at least 3 distinct meal types are logged
    if (distinctMealTypes >= 3) {
      PersistentData.dayCount++;
      // Update streak and check for badges
      badgeRepo.updateStreakAndCheckBadges(PersistentData.dayCount);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasLoggedMealYesterday', true);

      breakfastCount.value = 0;
      lunchCount.value = 0;
      dinnerCount.value = 0;
      othersCount.value = 0;
      distinctMealTypes = 0;
    }
    await PersistentData.saveData(
        PersistentData.dayCount, PersistentData.lastUpdatedDate);
    print("Distinct meal types logged: $distinctMealTypes");
    print("Amount of completed days: ${PersistentData.dayCount}");
    print("Meal timestamp: ${timestamp.toString()}");
    print("Meal hour: ${timestamp.hour}");
  }

  Future<void> _saveData(int dayCount, DateTime lastUpdatedDate) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('dayCount', dayCount);
    await prefs.setString('lastUpdatedDate', lastUpdatedDate.toString());
  }

  // Badge widget determination logic
  Widget getBadgeWidget(int completedDays) {
    if (completedDays >= 30) {
      return Container(
        width: 155,
        height: 155,
        child: Image.asset(
          TImages.championBadge,
        ),
      );
      ;
    } else if (completedDays >= 7) {
      return Container(
        width: 155,
        height: 155,
        child: Image.asset(
          TImages.heroBadge,
        ),
      );
      ;
    } else if (completedDays >= 3) {
      return Container(
        width: 155,
        height: 155,
        child: Image.asset(
          TImages.noviceBadge,
        ),
      );
      ;
    } else if (completedDays >= 1) {
      return Container(
        width: 155,
        height: 155,
        child: Image.asset(
          TImages.initiatorBadge,
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  /*void monitorBadgeUnlock() {
    ever(dayCount, (count) {
      String? unlockedBadge;
      String? badgeImage;

      if (count == 1) {
        unlockedBadge = "Initiator";
        badgeImage = TImages.initiatorBadge;
      } else if (count == 3) {
        unlockedBadge = "Novice";
        badgeImage = TImages.noviceBadge;
      } else if (count == 7) {
        unlockedBadge = "Hero";
        badgeImage = TImages.heroBadge;
      } else if (count == 30) {
        unlockedBadge = "Champion";
        badgeImage = TImages.championBadge;
      }

      if (unlockedBadge != null) {
        Get.dialog(
          BadgeUnlockPopup(badgeName: unlockedBadge, badgeImage: badgeImage!),
        );
      }
    });
  }*/
}
