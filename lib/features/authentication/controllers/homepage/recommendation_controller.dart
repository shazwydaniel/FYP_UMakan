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

  Future<List<CafeItem>> getRecommendedList() async {
    final foodMoney = userController.user.value.actualRemainingFoodAllowance;
    final BMR = userController.calculateBMR();

    double dailyAllowance = foodMoney / 30;
    double allowancePerMeal = dailyAllowance / 4;

    double caloriesPerMeal = (BMR / 4);

    // Analyze food logs
    String userId = userController.user.value.id;
    Map<String, dynamic> analysis =
        await foodJournalRepo.analyzeFoodLogs(userId);

    Map<String, int> locationFrequency = analysis['locationFrequency'];
    Map<String, int> foodFrequency = analysis['foodFrequency'];

    // Step 1: Get the top 3 most frequent cafes
    List<MapEntry<String, int>> sortedEntries =
        locationFrequency.entries.toList();
    sortedEntries.sort((a, b) => b.value.compareTo(a.value));
    List<String> topFrequentCafes =
        sortedEntries.take(3).map((entry) => entry.key).toList();

    // Step 2: Fetch all items from all cafes
    List<CafeItem> allItems = await vendorRepo.getAllItemsFromAllCafes();

    // Step 3: Filter items from the top frequent cafes
    List<CafeItem> itemsFromFrequentCafes = allItems.where((item) {
      return topFrequentCafes
          .contains(item.itemLocation); // Include items from the top cafes only
    }).toList();

    print("Top Frequent Cafes: $topFrequentCafes");
    print("All Cafe Items: ${allItems.length}");
    print("Items From Frequent Cafes: ${itemsFromFrequentCafes.length}");

    // Step 4: Filter out frequent foods and apply constraints
    List<String> frequentlyLoggedFoodIds = foodFrequency.keys.toList();

    List<CafeItem> recommendedItems = itemsFromFrequentCafes.where((item) {
      bool isNewFood =
          !frequentlyLoggedFoodIds.contains(item.id); // Exclude frequent foods
      bool withinCalorieLimit = item.itemCalories <= caloriesPerMeal;
      bool withinPriceLimit = item.itemPrice <= allowancePerMeal;

      return isNewFood && withinCalorieLimit && withinPriceLimit;
    }).toList();
    print("Final Recommended Items: ${recommendedItems.length}");
    print("Recommended Items Count: ${recommendedItems.length}");
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
