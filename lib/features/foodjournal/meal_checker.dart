import 'package:another_flushbar/flushbar.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/utils/helpers/timer_range_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MealChecker {
  final FoodJournalRepository _foodJournalRepo = FoodJournalRepository.instance;

  Future<bool> checkMealsForTimeRange(String userId) async {
    TimeRange currentRange = getCurrentTimeRange();
    print("checkMealsForTimeRange started for user: $userId");

    print(
        "Checking meals for time range: ${currentRange.start} - ${currentRange.end}");

    // Fetch meals for the current time range
    List<JournalItem> meals = await _foodJournalRepo.getMealsForDateRange(
      userId,
      currentRange.start,
      currentRange.end,
    );
    print("Fetched ${meals.length} meals for the current time range.");

    if (meals.isEmpty) {
      // Show a Flushbar notification if no meals are logged
      Flushbar(
        title: "Meal Reminder",
        message: "You haven't logged any meals for the current meal time.",
        duration: Duration(seconds: 5),
        backgroundColor: Colors.orange,
        flushbarPosition: FlushbarPosition.TOP,
        icon: Icon(
          Icons.fastfood,
          color: Colors.white,
        ),
      ).show(Get.context!); // Use Get.context! for context
    }
    // Return true if meals are logged, otherwise false
    return meals.isNotEmpty;
  }
}
