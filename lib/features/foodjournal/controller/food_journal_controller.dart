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

  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void onInit() {
    super.onInit();
    initializeMealCounts();
    monitorBadgeUnlock();

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
      _updateMealStates(userId);

      // Check streaks and achievements
      _checkStreakAndAchievements(userId);

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

    if (completedMealTimes >= 3) {
      // Increment streak
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

      // Update achievements
      await _updateAchievements(userId, streak);
    } else {
      print("Fewer than 3 meal times logged. Streak not incremented.");
    }
  }

  Future<void> _updateAchievements(String userId, int streak) async {
    final achievementsDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Achievements')
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
        .collection('Achievements')
        .doc('current')
        .set(achievements);

    print("Achievements updated: $achievements");
  }

  void resetMealStatesAtMidnight(String userId) {
    Timer.periodic(Duration(minutes: 1), (timer) async {
      DateTime now = DateTime.now();

      if (now.hour == 0 && now.minute == 0) {
        // Fetch streak and carry forward
        final streakDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('streaks')
            .doc('current')
            .get();

        int currentStreak =
            streakDoc.exists ? streakDoc['streakCount'] ?? 0 : 0;

        print("Streak carried forward: $currentStreak");

        // Reset daily meal states for a new day
        hadBreakfast = false;
        hadLunch = false;
        hadDinner = false;
        hadOthers = false;

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

        print("Meal states reset for a new day.");
      }
    });
  }

  Future<void> evaluateStreakAtEndOfDay(String userId) async {
    DateTime now = DateTime.now();
    if (now.hour == 23 && now.minute == 59) {
      // Fetch today's MealStates from Firebase
      final mealStatesDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('MealStates')
          .doc('current')
          .get();

      if (mealStatesDoc.exists) {
        final data = mealStatesDoc.data()!;
        int completedMealTimes = [
          data['hadBreakfast'] ?? false,
          data['hadLunch'] ?? false,
          data['hadDinner'] ?? false,
          data['hadOthers'] ?? false,
        ].where((logged) => logged == true).length;

        // Fetch current streak
        final streakDoc = await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('streaks')
            .doc('current')
            .get();

        int streak = streakDoc.exists ? streakDoc['streakCount'] ?? 0 : 0;

        // Update streak based on completion
        if (completedMealTimes >= 3) {
          streak += 1;
          print("Streak incremented to $streak.");
        } else {
          streak = 0;
          print("Streak reset to 0 due to insufficient meal logs.");
        }

        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userId)
            .collection('streaks')
            .doc('current')
            .set({'streakCount': streak});
      }
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

    achievementsRef.snapshots().listen((snapshot) {
      if (!snapshot.exists) {
        print("No achievements found for this user.");
        return;
      }

      final achievements = snapshot.data();
      String? unlockedBadge;
      String? badgeImage;

      if (achievements?["initiator"] == true) {
        unlockedBadge = "Initiator";
        badgeImage = TImages.initiatorBadge;
      } else if (achievements?["novice"] == true) {
        unlockedBadge = "Novice";
        badgeImage = TImages.noviceBadge;
      } else if (achievements?["hero"] == true) {
        unlockedBadge = "Hero";
        badgeImage = TImages.heroBadge;
      } else if (achievements?["champion"] == true) {
        unlockedBadge = "Champion";
        badgeImage = TImages.championBadge;
      }

      if (unlockedBadge != null) {
        Get.dialog(
          BadgeUnlockPopup(
            badgeName: unlockedBadge,
            badgeImage: badgeImage!,
          ),
        );
      }
    });
  }
}
