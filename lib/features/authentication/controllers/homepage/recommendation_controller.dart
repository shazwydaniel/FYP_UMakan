import 'dart:async';

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

    // Update the time frame index every minute
    Timer.periodic(Duration(minutes: 1), (_) {
      currentTimeFrameIndex.value = getCurrentTimeFrameIndex();
    });
    print(getCurrentTimeFrameIndex());
  }

  Future<List<CafeItem>> getRecommendedList(String userId) async {
    // Step 1: Calculate user-specific constraints
    final foodMoney = userController.user.value.actualRemainingFoodAllowance;
    final BMR = userController.calculateBMR();

    double dailyAllowance = foodMoney / 30;
    double allowancePerMeal = dailyAllowance / 4;
    double caloriesPerMeal = BMR / 4;

    print('Allowance Per Meal: $allowancePerMeal');
    print('Calories Per Meal: $caloriesPerMeal');

    // Step 2: Fetch user preferences
    final userPreferences = userController.user.value;
    bool prefSpicy = userPreferences.prefSpicy;
    bool prefVegetarian = userPreferences.prefVegetarian;
    bool prefLowSugar = userPreferences.prefLowSugar;

    print('Prefer Spicy: $prefSpicy');
    print('Prefer Vegetarian: $prefVegetarian');
    print('Prefer Low Sugar: $prefLowSugar');

    // Step 3: Analyze food logs
    print('Current user from Recommendation Controller: $userId');
    Map<String, dynamic> analysis =
        await foodJournalRepo.analyzeFoodLogs(userId);

    // Safely cast or transform `locationFrequency`
    Map<String, int> locationFrequency =
        Map<String, int>.from(analysis['locationFrequency'] ?? {});

    print('Location Frequency: ${analysis['locationFrequency']}');

    // Step 4: Get the top 3 most frequent cafés
    List<MapEntry<String, int>> sortedEntries =
        locationFrequency.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    List<String> topFrequentCafes =
        sortedEntries.take(3).map((entry) => entry.key).toList();

    print('Top Frequent Cafes: $topFrequentCafes');

    // Step 5: Fetch all items from all cafés
    List<CafeItem> allItems = await vendorRepo.getAllItemsFromAllCafes();

    // Step 6: Filter items from the top frequent cafés and apply constraints
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

      // If preferences are false, exclude items with those characteristics
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
}
