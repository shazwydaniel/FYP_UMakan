import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/utils/helpers/timer_range_helper.dart';

// Reference the initialized plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final FoodJournalRepository _foodJournalRepo = FoodJournalRepository.instance;

Future<void> showMealReminderNotification(
    String userId, TimeRange currentRange, String title, String body) async {
  print("showMealReminderNotification called with:");
  print("Title: $title");
  print("Body: $body");

  try {
    // Fetch meals for the current time range
    List<JournalItem> meals = await _foodJournalRepo.getMealsForDateRange(
      userId,
      currentRange.start,
      currentRange.end,
    );
    print("Fetched ${meals.length} meals for the current time range.");

    // If no meals are logged, show the notification
    if (meals.isEmpty) {
      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
        'meal_reminder_channel',
        'Meal Reminders',
        channelDescription: 'Notifications to remind users to log meals.',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title,
        body,
        notificationDetails,
        payload: 'discover',
      );

      print("Notification successfully displayed.");
    } else {
      print("No notification needed as meals are already logged.");
    }
  } catch (e) {
    print("Error showing notification: $e");
  }
}
