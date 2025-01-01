import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Reference the initialized plugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> showMealReminderNotification(String title, String body) async {
  print("showMealReminderNotification called with:");
  print("Title: $title");
  print("Body: $body");

  try {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'meal_reminder_channel', // Channel ID
      'Meal Reminders', // Channel name
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
  } catch (e) {
    print("Error showing notification: $e");
  }
}
