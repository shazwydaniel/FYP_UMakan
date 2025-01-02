import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/helpers/notification_helper.dart';
import 'package:fyp_umakan/utils/helpers/timer_range_helper.dart';

import 'meal_checker.dart';

bool _isMealCheckScheduled = false; // Add this flag

void scheduleMealCheck(String userId) {
  if (_isMealCheckScheduled) {
    print("scheduleMealCheck is already running.");
    return;
  }

  _isMealCheckScheduled = true; // Set the flag
  print("Starting scheduleMealCheck...");

  Timer.periodic(Duration(minutes: 1), (timer) async {
    DateTime now = DateTime.now();

    // Initialize the MealChecker
    // final mealChecker = MealChecker();

    // Breakfast notification at 11:00 AM

    if (now.hour == 11 && now.minute == 0) {
      TimeRange breakfastRange = getCurrentTimeRange();

      showMealReminderNotification(
        userId,
        breakfastRange,
        'Log Your Breakfast',
        "Don't forget to log your breakfast today!",
      );
    }

    // Lunch notification at 3:00 PM
    if (now.hour == 15 && now.minute == 0) {
      TimeRange lunchRange = getCurrentTimeRange();

      showMealReminderNotification(
        userId,
        lunchRange,
        'Log Your Lunch',
        "Don't forget to log your lunch today!",
      );
    }

    // Dinner notification at 8:00 PM
    if (now.hour == 20 && now.minute == 0) {
      TimeRange dinnerRange = getCurrentTimeRange();

      showMealReminderNotification(
        userId,
        dinnerRange,
        'Log Your Dinner',
        "Don't forget to log your dinner today!",
      );
    }
  });
}
