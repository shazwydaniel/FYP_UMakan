import 'dart:async';

import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
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

  Future<List<CafeItem>> getRecommendedList(int averageCalories) async {
    final foodMoney = userController.user.value.actualRemainingFoodAllowance;
    final vendorRepo = VendorRepository.instance;

    // Calculate weekly allowance (divide total by 4 assuming 4 weeks in a month)
    double weeklyAllowance = foodMoney / 4;

    // Calculate daily allowance (divide weekly allowance by 7 for 7 days a week)
    double dailyAllowance = weeklyAllowance / 7;

    // Calculate meal-specific allowance (divide daily allowance by 3 for 3 main meals)
    double mealAllowance = dailyAllowance / 3;

    // Get all items
    List<CafeItem> items = await vendorRepo.getAllItemsFromAllCafes();

    // Filter items by calories and price only
    List<CafeItem> recommendedItems = items.where((item) {
      bool withinCalorieLimit = item.itemCalories <= averageCalories;
      bool withinPriceLimit = item.itemPrice <= mealAllowance;

      return withinCalorieLimit && withinPriceLimit;
    }).toList();

    print('Average Calories: $averageCalories');
    print('Meal Allowance: $mealAllowance');
    print('Recommended items: $recommendedItems');
    print('Total items: ${recommendedItems.length}');

    return recommendedItems; // Return the list of recommended items
  }

  int getCurrentTimeFrameIndex() {
    DateTime now = DateTime.now();
    if (now.hour >= 6 && now.hour < 12) {
      print("current index : 0, for breakfast");
      return 0; // Breakfast
    } else if (now.hour >= 12 && now.hour < 16) {
      print("current index : 1, for lunch");
      return 1; // Lunch
    } else if (now.hour >= 16 && now.hour < 21) {
      print("current index : 2, for dinner");
      return 2; // Dinner
    } else {
      print("current index : 3, for others");
      return 3; // Others
    }
  }
}
