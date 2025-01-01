import 'dart:async';
import 'package:fyp_umakan/utils/helpers/notification_helper.dart';

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
    final mealChecker = MealChecker();

    // Breakfast notification at 11:00 AM
    if (now.hour == 11 && now.minute == 0) {
      print('Breakfast notification scheduled');
      bool mealsLogged = await mealChecker.checkMealsForTimeRange(userId);
      if (!mealsLogged) {
        await showMealReminderNotification(
          'Log Your Breakfast',
          "Don't forget to log your breakfast today!",
        );
      }
    }

    // Lunch notification at 3:00 PM
    if (now.hour == 15 && now.minute == 0) {
      print('Lunch notification scheduled');
      bool mealsLogged = await mealChecker.checkMealsForTimeRange(userId);
      if (!mealsLogged) {
        await showMealReminderNotification(
          'Log Your Lunch',
          "Don't forget to log your lunch today!",
        );
      }
    }

    // Dinner notification at 8:00 PM
    if (now.hour == 0 && now.minute == 26) {
      print('Dinner notification scheduled');
      bool mealsLogged = await mealChecker.checkMealsForTimeRange(userId);
      if (!mealsLogged) {
        await showMealReminderNotification(
          'Log Your Dinner',
          "Don't forget to log your dinner today!",
        );
      }
    }
  });
}
