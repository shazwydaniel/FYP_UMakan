import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/foodjournal/screen/indulgence_popup.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/student_management/screens/badge_unlock_popup.dart';
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

  final Map<String, int> dailyMealCounts =
      {}; // Tracks meal counts for the current day
  DateTime lastCheckedDate = DateTime.now();

  var mealItems = <JournalItem>[].obs;
  var todayCalories = 0.obs;
  var yesterdayCalories = 0.obs;
  var isLoading = false.obs;
  final userController = UserController.instance;
  var completedDays = 0.obs;
  bool isTimerRunning = false;

  // Meal type counts
  RxInt breakfastCount = RxInt(0);
  RxInt lunchCount = RxInt(0);
  RxInt dinnerCount = RxInt(0);
  RxInt othersCount = RxInt(0);

  bool hadBreakfast = false;
  bool hadLunch = false;
  bool hadDinner = false;
  bool hadOthers = false;

  // Day count for completing at least 3 meal types
  var dayCount = 0.obs;

  // Calculate meal type count
  RxInt mealTypeCount = 0.obs;

  // Last updated date to reset counts
  DateTime lastUpdatedDate = DateTime.now();

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
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      print("User not logged in. Skipping initialization.");
      return;
    }

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
    // print("Food Frequency: ${analysis['foodFrequency']}");
    // print("Location Frequency: ${analysis['locationFrequency']}");
  }

  Future<void> addFoodToJournal(String userId, JournalItem journalItem) async {
    try {
      final foodData = journalItem.toJson();
      await _foodJournalRepo.addFood(userId, foodData);

      mealItems.add(journalItem);

      // Analyze meals for the current week
      await analyzeWeeklyMeals(userId, journalItem.name, journalItem.imagePath);

      // Update meal states
      //_updateMealStates(userId);

      // Check streaks and achievements
      //_checkStreakAndAchievements(userId);

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

  //---------------------STREAKS RELATED STUFF--------------------------//

  String _getMealTime(DateTime now) {
    if (now.hour >= 6 && now.hour < 12) {
      return "breakfast";
    }
    if (now.hour >= 12 && now.hour < 16) {
      return "lunch";
    }
    if (now.hour >= 19 && now.hour < 21) {
      return "dinner";
    }
    return "others";
  }

  Future<void> _updateMealStates(String userId) async {
    DateTime now = DateTime.now();
    String mealTime = _getMealTime(now);

    // Fetch current states from Firebase
    final mealStatesDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('MealStates')
        .doc('current')
        .get();

    if (mealStatesDoc.exists) {
      // Load states from Firebase
      Map<String, dynamic> data = mealStatesDoc.data()!;
      hadBreakfast = data['hadBreakfast'] ?? false;
      hadLunch = data['hadLunch'] ?? false;
      hadDinner = data['hadDinner'] ?? false;
      hadOthers = data['hadOthers'] ?? false;
    }

    // Update the current meal time state
    if (mealTime == "breakfast") hadBreakfast = true;
    if (mealTime == "lunch") hadLunch = true;
    if (mealTime == "dinner") hadDinner = true;
    if (mealTime == "others") hadOthers = true;

    // Save updated states to Firebase
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('MealStates')
        .doc('current')
        .set({
      'hadBreakfast': hadBreakfast,
      'hadLunch': hadLunch,
      'hadDinner': hadDinner,
      'hadOthers': hadOthers,
    });

    print(
        "Meal states updated: Breakfast: $hadBreakfast, Lunch: $hadLunch, Dinner: $hadDinner, Others: $hadOthers");
  }

  Future<void> _checkStreakAndAchievements(String userId) async {
    try {
      // Fetch meal states from Firebase
      final mealStatesDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('MealStates')
          .doc('current')
          .get();

      if (!mealStatesDoc.exists) return;

      final data = mealStatesDoc.data()!;
      int completedMealTimes = [
        data['hadBreakfast'] ?? false,
        data['hadLunch'] ?? false,
        data['hadDinner'] ?? false,
        data['hadOthers'] ?? false,
      ].where((logged) => logged == true).length;

      //supposed to be completedMealTimes == 3 but like... the code works when i put two??
      if (completedMealTimes == 2) {
        // Fetch streak document
        final streakDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('streaks')
            .doc('current')
            .get();

        int streak = streakDoc.exists ? streakDoc['streakCount'] : 0;
        DateTime? lastUpdated;

        if (streakDoc.exists && streakDoc.data()!.containsKey('lastUpdated')) {
          lastUpdated = (streakDoc['lastUpdated'] as Timestamp).toDate();
        }

        // Check if the streak was already updated today
        DateTime now = DateTime.now();
        if (lastUpdated != null &&
            lastUpdated.year == now.year &&
            lastUpdated.month == now.month &&
            lastUpdated.day == now.day) {
          print("Streak already updated for today. No action taken.");
          return;
        }

        // Increment streak and update Firestore
        streak += 1;

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('streaks')
            .doc('current')
            .set({
          'streakCount': streak,
          'lastUpdated':
              Timestamp.fromDate(now), // Add/update last updated date
        });

        print("Streak incremented to $streak.");

        // Update achievements
        await _updateAchievements(userId, streak);
        monitorBadgeUnlock();
      } else {
        print("Fewer than 3 meal times logged. Streak not incremented.");
      }
    } catch (e) {
      print(
          "Error checking and updating streaks from Food Journal Controller _checkStreakAndAchievements:  $e");
    }
  }

  Future<void> _updateAchievements(String userId, int streak) async {
    // Reference to the Achievements document
    final achievementsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Achievements')
        .doc('current');

    // Fetch existing achievements data
    final achievementsDoc = await achievementsRef.get();

    Map<String, dynamic> achievements = achievementsDoc.exists
        ? achievementsDoc.data() ?? {}
        : {
            "initiator": false,
            "novice": false,
            "hero": false,
            "champion": false,
            "lastUnlocked": {
              "initiator": null,
              "novice": null,
              "hero": null,
              "champion": null,
            },
          };

    // Initialize lastUnlocked if it doesn't exist
    achievements["lastUnlocked"] ??= {
      "initiator": null,
      "novice": null,
      "hero": null,
      "champion": null,
    };

    Map<String, dynamic> lastUnlocked =
        Map<String, dynamic>.from(achievements["lastUnlocked"]);

    // Update achievements and their lastUnlocked timestamps
    if (streak == 1 && achievements["initiator"] == false) {
      achievements["initiator"] = true;
      lastUnlocked["initiator"] = DateTime.now().toIso8601String();
    }
    if (streak == 3 && achievements["novice"] == false) {
      achievements["novice"] = true;
      lastUnlocked["novice"] = DateTime.now().toIso8601String();
    }
    if (streak == 7 && achievements["hero"] == false) {
      achievements["hero"] = true;
      lastUnlocked["hero"] = DateTime.now().toIso8601String();
    }
    if (streak == 30 && achievements["champion"] == false) {
      achievements["champion"] = true;
      lastUnlocked["champion"] = DateTime.now().toIso8601String();
    }

    // Add lastUnlocked back to the achievements map
    achievements["lastUnlocked"] = lastUnlocked;

    // Update the document in Firestore
    await achievementsRef.set(achievements);

    print("Achievements updated with lastUnlocked: $achievements");
  }

  Future<void> resetMealStatesAtMidnight(String userId) async {
    try {
      // Fetch the latest logout timestamp from Firebase
      final logoutDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('LogoutRecords')
          .doc('latest')
          .get();

      if (logoutDoc.exists) {
        final Timestamp lastLogoutTimestamp = logoutDoc['timestamp'];
        final DateTime lastLogoutDate = lastLogoutTimestamp.toDate();
        final DateTime now = DateTime.now();

        // Check if the last logout day is not today
        if (lastLogoutDate.day != now.day ||
            lastLogoutDate.month != now.month ||
            lastLogoutDate.year != now.year) {
          print("Resetting meal states for a new day for user: $userId.");

          // Reset meal states in Firebase
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(userId)
              .collection('MealStates')
              .doc('current')
              .set({
            'hadBreakfast': false,
            'hadLunch': false,
            'hadDinner': false,
            'hadOthers': false,
          });

          print("Meal states reset in Firebase for user: $userId.");

          // Optionally, update the local variables (if used)
          hadBreakfast = false;
          hadLunch = false;
          hadDinner = false;
          hadOthers = false;
        } else {
          print("Meal states are already up-to-date for user: $userId.");
        }
      } else {
        print("No logout record found for user: $userId. Skipping reset.");
      }
    } catch (e) {
      print("Error resetting meal states: $e");
    }
  }

  Future<void> checkAndResetStreak(String userId) async {
    // Get the current time and calculate the previous day
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day - 1, 0, 0, 0);
    DateTime endOfDay = DateTime(now.year, now.month, now.day - 1, 23, 59, 59);

    try {
      // Fetch meal logs for the previous day
      final mealLogs = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('FoodJournal')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .where('timestamp', isLessThanOrEqualTo: endOfDay)
          .get();

      // Categorize logs by meal time
      List<DateTime> timestamps = mealLogs.docs
          .map((doc) => (doc['timestamp'] as Timestamp).toDate())
          .toList();

      bool loggedBreakfast = timestamps
          .any((time) => time.hour >= 6 && time.hour < 12); // 6 AM - 12 PM
      bool loggedLunch = timestamps
          .any((time) => time.hour >= 12 && time.hour < 16); // 12 PM - 4 PM
      bool loggedDinner = timestamps
          .any((time) => time.hour >= 19 && time.hour < 21); // 7 PM - 9 PM
      bool loggedOthers = timestamps.any((time) =>
          !(time.hour >= 6 && time.hour < 12) &&
          !(time.hour >= 12 && time.hour < 16) &&
          !(time.hour >= 19 && time.hour < 21)); // Any other time

      int completedMealTimes = [
        loggedBreakfast,
        loggedLunch,
        loggedDinner,
        loggedOthers,
      ].where((logged) => logged).length;

      // Reset streak if fewer than 3 meal times were logged
      if (completedMealTimes < 3) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('streaks')
            .doc('current')
            .set({'streakCount': 0});

        print("Streak reset to 0 due to insufficient meal logs for the day.");
      } else {
        print("Streak maintained: 3 or more meal times logged.");
      }
    } catch (e) {
      print("Error checking and resetting streak: $e");
    }
  }

  //For HomePage
  Future<int> fetchStreakCount(String userId) async {
    try {
      final streakDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('streaks')
          .doc('current')
          .get();

      if (streakDoc.exists) {
        final data = streakDoc.data();
        print("Streak count = $data .");
        // print("Raw data from Firestore: ${streakDoc.data()}");

        return data?['streakCount'] ?? 0;
      } else {
        print("Streak document does not exist.");
        return 0;
      }
    } catch (e) {
      print("Error fetching streak count: $e");
      return 0;
    }
  }

  //---------------------POP UP NOTIFICATION FOR INDULEGENCE --------------------------//

  Future<void> analyzeWeeklyMeals(
      String userId, String mealName, String mealImage) async {
    try {
      // Step 1: Get the start and end of the current week
      DateTime now = DateTime.now();
      DateTime startOfWeek = now.subtract(
          Duration(days: now.weekday - 1)); // Start of the week (Monday)
      DateTime endOfWeek =
          startOfWeek.add(Duration(days: 6)); // End of the week (Sunday)

      // Step 2: Fetch all food journal items
      final allMeals = await fetchFoodJournalItems();

      // Step 3: Filter meals for the current week
      final weeklyMeals = allMeals.where((meal) {
        return meal.timestamp
                .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
            meal.timestamp.isBefore(endOfWeek.add(const Duration(seconds: 1)));
      }).toList();

      print("Weekly Meals: $weeklyMeals");

      // Step 4: Count occurrences of the specified meal
      int mealCount = weeklyMeals.where((meal) => meal.name == mealName).length;

      // Step 5: Trigger popup if the meal is eaten 3+ times
      if (mealCount >= 3) {
        Get.dialog(
          IndulgencePopup(
            mealName: mealName,
            mealImage: mealImage,
          ),
        );
      }
    } catch (e) {
      print('Error analyzing weekly meals: $e');
    }
  }

  // Fetch
  Future<List<JournalItem>> fetchFoodJournalItems() async {
    try {
      final userId = getCurrentUserId();
      final foodJournalList = await _foodJournalRepo.getFoodJournalItem(userId);

      //print("Fetching Food Journal Items for User ID: $userId");
      //print("Raw Food Journal List: $foodJournalList");

      if (foodJournalList.isNotEmpty) {
        mealItems.assignAll(foodJournalList);
        print("Items Food Journal fetched: $mealItems");
        return foodJournalList;
      } else {
        print('No items found in Food Journal');
        mealItems.clear();
        return [];
      }
    } catch (e) {
      print('Error fetching cafes: $e');
      mealItems.clear();
      return [];
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

  //---------------------STORING METHODS (MIGHT REMOVE) --------------------------//

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

  //---------------------CALCULATION --------------------------//

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

  void monitorBadgeUnlock() {
    // Reference to the Achievements collection
    final achievementsRef = FirebaseFirestore.instance
        .collection("Users")
        .doc(getCurrentUserId())
        .collection("Achievements")
        .doc("current");

    achievementsRef.snapshots().listen((snapshot) async {
      if (!snapshot.exists) {
        print("No achievements found for this user.");
        return;
      }

      final achievements = snapshot.data();
      final lastUnlocked =
          achievements?["lastUnlocked"] as Map<String, dynamic>? ?? {};

      String? unlockedBadge;
      String? badgeImage;

      Future<void> unlockBadge(
          String key, String badgeName, String badgeImagePath) async {
        if (achievements?[key] == true && (lastUnlocked[key] == null)) {
          unlockedBadge = badgeName;
          badgeImage = badgeImagePath;

          // Update the lastUnlocked field in Firestore
          await achievementsRef.update({
            "lastUnlocked.$key": DateTime.now().toIso8601String(),
          });
        }
      }

      // Check and unlock badges
      await unlockBadge("initiator", "Initiator", TImages.initiatorBadge);
      await unlockBadge("novice", "Novice", TImages.noviceBadge);
      await unlockBadge("hero", "Hero", TImages.heroBadge);
      await unlockBadge("champion", "Champion", TImages.championBadge);

      // Show popup only if a badge was unlocked
      if (unlockedBadge != null) {
        Get.dialog(
          BadgeUnlockPopup(
            badgeName: unlockedBadge!,
            badgeImage: badgeImage!,
          ),
        );
      }
    });
  }

  Future<String> uploadImage(
      File imageFile, String userId, String fJournalId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
            'manual_journal_images/$userId/$fJournalId/${DateTime.now().toIso8601String()}',
          );

      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Image upload failed.');
    }
  }
}
