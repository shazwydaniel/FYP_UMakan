import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    initializeMealCounts();
    monitorBadgeUnlock();
    final userId = FirebaseAuth.instance.currentUser?.uid;
    /* if (userId != null) {
      initializeMealTracking(userId);
    }*/
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

  Future<void> initializeMealCounts() async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;
      if (userId == null) {
        print("User not logged in.");
        return;
      }

      final mealCountsRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Badges')
          .doc('mealCounts');

      final snapshot = await mealCountsRef.get();
      if (snapshot.exists) {
        final data = snapshot.data();
        breakfastCount.value = data?['breakfast'] ?? 0;
        lunchCount.value = data?['lunch'] ?? 0;
        dinnerCount.value = data?['dinner'] ?? 0;
        othersCount.value = data?['others'] ?? 0;
      } else {
        print("Meal counts not found. Initializing with default values.");
        await mealCountsRef.set({
          'breakfast': 0,
          'lunch': 0,
          'dinner': 0,
          'others': 0,
        });
      }
    } catch (e) {
      print("Error initializing meal counts: $e");
    }
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

      // Analyze meals for the current week
      await analyzeWeeklyMeals(userId, journalItem.name, journalItem.imagePath);

      // Fetch today's meals and update meal time flags
      await _updateMealCheck(userId);

      // Update streaks and achievements
      await _checkStreakAndAchievements(userId);

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

  //---------------------ACHIEVEMENT AND BADGE RELATED STUFF--------------------------//

  Future<void> _updateMealCheck(String userId) async {
    // Step 1: Get today's date
    DateTime now = DateTime.now();
    String todayString = now.toIso8601String().split("T")[0];

    // Step 2: Fetch today's logged meals
    final todayMeals = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('food_journal')
        .where('timestamp',
            isGreaterThanOrEqualTo: DateTime(now.year, now.month, now.day))
        .get();

    // Step 3: Determine which meal times have been logged
    bool hadBreakfast = false;
    bool hadLunch = false;
    bool hadDinner = false;
    bool hadOthers = false;

    for (var meal in todayMeals.docs) {
      DateTime mealTime = (meal.data()['timestamp'] as Timestamp).toDate();
      String mealPeriod = _getMealTime(mealTime);

      if (mealPeriod == "breakfast") hadBreakfast = true;
      if (mealPeriod == "lunch") hadLunch = true;
      if (mealPeriod == "dinner") hadDinner = true;
      if (mealPeriod == "others") hadOthers = true;
    }

    // Step 4: Update Meal_Check subcollection
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Meal_Check')
        .doc(todayString)
        .set({
      'hadBreakfast': hadBreakfast,
      'hadLunch': hadLunch,
      'hadDinner': hadDinner,
      'hadOthers': hadOthers,
    });

    print(
        "Meal_Check updated: Breakfast=$hadBreakfast, Lunch=$hadLunch, Dinner=$hadDinner, Others=$hadOthers");
  }

  String _getMealTime(DateTime now) {
    if (now.hour >= 6 && now.hour < 12) return "breakfast";
    if (now.hour >= 12 && now.hour < 16) return "lunch";
    if (now.hour >= 19 && now.hour < 21) return "dinner";
    if (now.hour >= 16 && now.hour < 19 ||
        now.hour >= 21 && now.hour < 24 ||
        now.hour >= 0 && now.hour < 6) return "others";
    return 'None';
  }

  void _updateMealStates() {
    DateTime now = DateTime.now();
    String mealTime = _getMealTime(now);

    if (mealTime == "breakfast") hadBreakfast = true;
    if (mealTime == "lunch") hadLunch = true;
    if (mealTime == "dinner") hadDinner = true;
    if (mealTime == "others") hadOthers = true;

    print(
        "Meal states updated: Breakfast: $hadBreakfast, Lunch: $hadLunch, Dinner: $hadDinner, Others: $hadOthers");
  }

  Future<void> _checkStreakAndAchievements(String userId) async {
    // Step 1: Get today's Meal_Check
    DateTime today = DateTime.now();
    String todayString = today.toIso8601String().split("T")[0];

    final mealCheckDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Meal_Check')
        .doc(todayString)
        .get();

    if (!mealCheckDoc.exists) return; // No meals logged today

    // Step 2: Count completed meal times
    final data = mealCheckDoc.data()!;
    int completedMealTimes = [
      data['hadBreakfast'] ?? false,
      data['hadLunch'] ?? false,
      data['hadDinner'] ?? false,
      data['hadOthers'] ?? false,
    ].where((logged) => logged == true).length;

    // Step 3: Update streak if 3+ meal times are logged
    if (completedMealTimes >= 3) {
      final streakDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('streaks')
          .doc('current')
          .get();

      int streak = streakDoc.exists ? streakDoc['streakCount'] : 0;
      streak += 1;

      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('streaks')
          .doc('current')
          .set({'streakCount': streak});

      print("Streak incremented to $streak.");

      await _updateAchievements(
          userId, streak); // Check and update achievements
    }
  }

  Future<void> _updateAchievements(String userId, int streak) async {
    final achievementsDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('achievements')
        .doc('current')
        .get();

    Map<String, bool> achievements = achievementsDoc.exists
        ? Map<String, bool>.from(achievementsDoc.data() ?? {})
        : {
            "initiator": false,
            "novice": false,
            "hero": false,
            "champion": false
          };

    if (streak == 1) achievements["initiator"] = true;
    if (streak == 3) achievements["novice"] = true;
    if (streak == 7) achievements["hero"] = true;
    if (streak == 30) achievements["champion"] = true;

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('achievements')
        .doc('current')
        .set(achievements);

    print("Achievements updated: $achievements");
  }

  void resetMealCheckAtMidnight(String userId) {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      DateTime now = DateTime.now();
      if (now.hour == 0 && now.minute == 0) {
        // At midnight
        String todayString = now.toIso8601String().split("T")[0];

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('Meal_Check')
            .doc(todayString)
            .set({
          'hadBreakfast': false,
          'hadLunch': false,
          'hadDinner': false,
          'hadOthers': false,
        });

        print("Meal_Check reset for $todayString.");
      }
    });
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

  /*Future<void> initializeMealTracking(String userId) async {
    final badgesDoc = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Badges')
        .doc('mealCounts');

    try {
      final snapshot = await badgesDoc.get();
      if (snapshot.exists) {
        breakfastCount.value = snapshot.data()?['breakfast'] ?? 0;
        lunchCount.value = snapshot.data()?['lunch'] ?? 0;
        dinnerCount.value = snapshot.data()?['dinner'] ?? 0;
        othersCount.value = snapshot.data()?['others'] ?? 0;
        lastUpdatedDate = snapshot.data()?['lastUpdatedDate'] != null
            ? DateTime.parse(snapshot.data()?['lastUpdatedDate'])
            : DateTime.now();
      }
    } catch (e) {
      print("Error fetching meal tracking data: $e");
    }
  }

  Future<void> trackMealAndDayCount(DateTime timestamp) async {
    String userId = userController.user.value.id;
    final mealCountsRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Badges')
        .doc('mealCounts');
    final streaksRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Badges')
        .doc('streakCount');

    try {
      // Fetch the current meal counts
      final snapshot = await mealCountsRef.get();
      Map<String, dynamic> currentCounts = snapshot.exists
          ? snapshot.data()!
          : {
              'breakfast': 0,
              'lunch': 0,
              'dinner': 0,
              'others': 0,
            };

      // Determine meal type
      String mealType = '';
      if (timestamp.hour >= 6 && timestamp.hour < 12) {
        mealType = 'breakfast';
      } else if (timestamp.hour >= 12 && timestamp.hour < 16) {
        mealType = 'lunch';
      } else if (timestamp.hour >= 19 && timestamp.hour < 21) {
        mealType = 'dinner';
      } else {
        mealType = 'others';
      }

      // Increment the meal count for the determined meal type
      currentCounts[mealType] = (currentCounts[mealType] ?? 0) + 1;

      // Update Firestore with the new counts
      await mealCountsRef.set(currentCounts);

      // Count distinct meal types logged for today
      int distinctMealTypes = currentCounts.values
          .where((count) => count > 0)
          .length; // Filter non-zero counts

      // Update streaks if conditions are met
      if (distinctMealTypes >= 3) {
        // Fetch current streak data
        final streakSnapshot = await streaksRef.get();
        int currentStreak = streakSnapshot.exists
            ? (streakSnapshot.data()?['value'] ?? 0) as int
            : 0;

        // Increment the streak
        await streaksRef.set({'value': currentStreak + 1});
        print('Streak updated: ${currentStreak + 1}');
      }

      print(
          'Meal counts updated: breakfast=${currentCounts['breakfast']}, lunch=${currentCounts['lunch']}, dinner=${currentCounts['dinner']}, others=${currentCounts['others']}');
    } catch (e) {
      print('Error in trackMealAndDayCount: $e');
    }
  }*/

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
  }
}
