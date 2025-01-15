import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/foodjournal/screen/food_journal_main_page.dart';
import 'package:fyp_umakan/features/moneyjournal/screens/money_journal_main_page.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_register.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecommendationController extends GetxController {
  static RecommendationController get instance => Get.find();

  final userController = UserController.instance;

  final vendorRepo = VendorRepository.instance;
  final foodJournalController = FoodJournalController.instance;
  final foodJournalRepo = FoodJournalRepository.instance;

  var currentTimeFrameIndex = 3.obs;

  @override
  void onInit() {
    super.onInit();
    // Set the initial time frame index
    currentTimeFrameIndex.value = getCurrentTimeFrameIndex();
    calculateAndStoreAverages(userController.user.value.id);

    // Update the time frame index every minute
    Timer.periodic(Duration(minutes: 1), (_) {
      currentTimeFrameIndex.value = getCurrentTimeFrameIndex();
    });
    print(getCurrentTimeFrameIndex());
  }

  Future<List<CafeItem>> getRecommendedList(String userId) async {
    // Step 1: Calculate default user-specific constraints
    final foodMoney = userController.user.value.actualRemainingFoodAllowance;
    final BMR = userController.calculateBMR();

    double dailyAllowance = foodMoney / 30;
    double defaultAllowancePerMeal = dailyAllowance / 4;
    double defaultCaloriesPerMeal = BMR / 4;

    print('Default Allowance Per Meal: $defaultAllowancePerMeal');
    print('Default Calories Per Meal: $defaultCaloriesPerMeal');

    // Step 2: Fetch average values from Firebase
    final averagesDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .collection('Averages')
        .doc('weekly_averages')
        .get();

    if (!averagesDoc.exists) {
      print("No averages found for the user.");
      return [];
    }

    final averagesData = averagesDoc.data()!;
    final averageCalories =
        Map<String, dynamic>.from(averagesData['averageCalories']);
    final averageCost = Map<String, dynamic>.from(averagesData['averageCost']);

    print('Fetched Average Calories: $averageCalories');
    print('Fetched Average Cost: $averageCost');

    // Step 3: Define time ranges for meals
    final timeFrames = {
      'Breakfast': {'start': 6, 'end': 12},
      'Lunch': {'start': 12, 'end': 16},
      'Dinner': {'start': 19, 'end': 21},
      'Others': {
        'ranges': [
          {'start': 0, 'end': 6},
          {'start': 16, 'end': 19},
          {'start': 21, 'end': 24},
        ]
      },
    };

    // Step 3: Determine the current meal time
    final now = DateTime.now();
    String currentMealTime = 'Others';

    for (var frame in timeFrames.entries) {
      if (frame.key != 'Others') {
        final start = frame.value['start'] as int;
        final end = frame.value['end'] as int;

        if (now.hour >= start && now.hour < end) {
          currentMealTime = frame.key;
          print(
              'Current meal time determined: $currentMealTime (Time Range: $start:00 - $end:00)');
          break;
        }
      } else {
        for (var range in (frame.value['ranges'] as List<Map<String, int>>)) {
          final start = range['start']!;
          final end = range['end']!;

          if ((now.hour >= start && now.hour < end) ||
              (start > end && (now.hour >= start || now.hour < end))) {
            currentMealTime = 'Others';
            print(
                'Current meal time determined: $currentMealTime (Time Range: $start:00 - $end:00)');
            break;
          }
        }
      }
    }

// Debugging output for the final result
    print('Final determined meal time: $currentMealTime');

    // Step 4: Get average constraints for the current meal time or fallback to default
    final caloriesPerMeal = (averageCalories[currentMealTime] != 0
            ? averageCalories[currentMealTime]
            : defaultCaloriesPerMeal)
        .round();
    final allowancePerMeal = (averageCost[currentMealTime] != 0
            ? averageCost[currentMealTime]
            : defaultAllowancePerMeal)
        .round();

    print('Allowance Per Meal: $allowancePerMeal');
    print('Calories Per Meal: $caloriesPerMeal');

    // Step 5: Fetch user preferences
    final userPreferences = userController.user.value;
    bool prefSpicy = userPreferences.prefSpicy;
    bool prefVegetarian = userPreferences.prefVegetarian;
    bool prefLowSugar = userPreferences.prefLowSugar;

    // Step 6: Analyze food logs to identify top cafés
    print('Current user from Recommendation Controller: $userId');
    Map<String, dynamic> analysis =
        await foodJournalRepo.analyzeFoodLogs(userId);

    // Safely cast or transform locationFrequency
    Map<String, int> locationFrequency =
        Map<String, int>.from(analysis['locationFrequency'] ?? {});

    print('Location Frequency: ${analysis['locationFrequency']}');

    // Get the top 3 most frequent cafés
    List<MapEntry<String, int>> sortedEntries =
        locationFrequency.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    List<String> topFrequentCafes =
        sortedEntries.take(3).map((entry) => entry.key).toList();

    print('Top Frequent Cafes: $topFrequentCafes');

    // Step 7: Fetch all café items
    List<CafeItem> allItems = await vendorRepo.getAllItemsFromAllCafes();

    // Step 8: Filter items from the top frequent cafés and apply constraints
    List<CafeItem> recommendedItems = allItems.where((item) {
      bool withinCalorieLimit = item.itemCalories <= caloriesPerMeal;
      bool withinPriceLimit = item.itemPrice <= allowancePerMeal;
      bool isFromTopCafe = topFrequentCafes.contains(item.itemLocation);

      // Apply user preferences
      bool matchesPreference = true;
      if (prefSpicy) matchesPreference = matchesPreference && item.isSpicy;
      if (prefVegetarian)
        matchesPreference = matchesPreference && item.isVegetarian;
      if (prefLowSugar)
        matchesPreference = matchesPreference && item.isLowSugar;

      // Exclude items if preferences are false
      if (!prefSpicy && item.isSpicy) matchesPreference = false;
      if (!prefVegetarian && item.isVegetarian) matchesPreference = false;
      if (!prefLowSugar && item.isLowSugar) matchesPreference = false;

      return isFromTopCafe &&
          withinCalorieLimit &&
          withinPriceLimit &&
          matchesPreference;
    }).toList();

    print('Recommended Items: ${recommendedItems.length} items');

    // Return the filtered list
    return recommendedItems;
  }

  int getCurrentTimeFrameIndex() {
    DateTime now = DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
      print("current index : 0, for breakfast");
      return 0; // Breakfast
    } else if (now.hour >= 12 && now.hour < 16) {
      print("current index : 1, for lunch");
      return 1; // Lunch
    } else if (now.hour >= 19 && now.hour < 24) {
      print("current index : 2, for dinner");
      return 2; // Dinner
    } else if (now.hour >= 16 && now.hour < 17 ||
        now.hour >= 0 && now.hour < 6) {
      print("current index : 3, for others");
      return 3; // Others
    } else {
      print("current index : 4, outside of options");
      return 4;
    }
  }

  Future<void> calculateAndStoreAverages(String userId) async {
    // Define time ranges for meals
    final timeFrames = {
      'Breakfast': {'start': 6, 'end': 12}, // 6AM - 12PM
      'Lunch': {'start': 12, 'end': 16}, // 12PM - 4PM
      'Dinner': {'start': 19, 'end': 21}, // 7PM - 9PM
      'Others': {
        'ranges': [
          {'start': 0, 'end': 6}, // 12AM - 6AM
          {'start': 16, 'end': 19}, // 4PM - 7PM
          {'start': 21, 'end': 24}, // 9PM - 11:59PM
        ]
      },
    };

    // Get current week's start and end date
    final now = DateTime.now();
    final startOfWeek =
        DateTime(now.year, now.month, now.day - (now.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    try {
      // Fetch food journal entries for the week
      QuerySnapshot foodJournalEntries = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('food_journal')
          .get();

      // Initialize data structure to calculate averages
      Map<String, List<Map<String, dynamic>>> groupedEntries = {
        'Breakfast': [],
        'Lunch': [],
        'Dinner': [],
        'Others': [],
      };

      // Group entries by meal time
      for (var entry in foodJournalEntries.docs) {
        final timestampString = entry['timestamp'];
        final timestamp =
            DateTime.parse(timestampString); // Parse string to DateTime
        final cost = entry['price'] ?? 0.0;
        final calories = entry['calories'] ?? 0.0;

        if (timestamp.isBefore(startOfWeek) || timestamp.isAfter(endOfWeek)) {
          continue; // Skip entries outside of the current week
        }

        // Check which time frame the entry belongs to
        for (var frame in timeFrames.entries) {
          if (frame.key != 'Others') {
            final start = frame.value['start'] as int? ?? 0;
            final end = frame.value['end'] as int? ?? 24;

            if (timestamp.hour >= start && timestamp.hour < end) {
              groupedEntries[frame.key]!
                  .add({'cost': cost, 'calories': calories});
              break;
            }
          } else {
            // Special handling for "Others" (multiple time ranges)
            for (var range
                in (frame.value['ranges'] as List<Map<String, int>>?) ?? []) {
              final start = range['start']!;
              final end = range['end']!;
              if ((timestamp.hour >= start && timestamp.hour < end) ||
                  (start > end &&
                      (timestamp.hour >= start || timestamp.hour < end))) {
                groupedEntries['Others']!
                    .add({'cost': cost, 'calories': calories});
                break;
              }
            }
          }
        }
      }

      // Calculate averages
      Map<String, double> averageCalories = {};
      Map<String, double> averageCost = {};

      for (var frame in groupedEntries.entries) {
        final entries = frame.value;
        if (entries.isNotEmpty) {
          averageCalories[frame.key] =
              entries.fold(0.0, (sum, e) => sum + e['calories']) /
                  entries.length;
          averageCost[frame.key] =
              entries.fold(0.0, (sum, e) => sum + e['cost']) / entries.length;
        } else {
          // Default to 0 if no data is available
          averageCalories[frame.key] = 0.0;
          averageCost[frame.key] = 0.0;
        }
      }

      // Save to Firebase
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('Averages')
          .doc('weekly_averages')
          .set({
        'averageCalories': averageCalories,
        'averageCost': averageCost,
        'updatedAt': Timestamp.now(),
      });

      print("Averages successfully calculated and stored!");
    } catch (e) {
      print("Error calculating and storing averages: $e");
    }
  }
}
