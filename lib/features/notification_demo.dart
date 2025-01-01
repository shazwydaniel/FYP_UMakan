import 'dart:async';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:flutter/material.dart';
import 'package:overlay_support/overlay_support.dart';

class MealReminderDropDown extends StatefulWidget {
  @override
  _MealReminderDropDownState createState() => _MealReminderDropDownState();
}

class _MealReminderDropDownState extends State<MealReminderDropDown> {
  late Timer breakfastTimer, lunchTimer, dinnerTimer, othersTimer;

  @override
  void initState() {
    super.initState();

    // Trigger test notifications immediately for breakfast, lunch, etc.
    showDropDownNotification(
        "Test Breakfast", "This is a breakfast notification.");
    Future.delayed(Duration(seconds: 3), () {
      showDropDownNotification("Test Lunch", "This is a lunch notification.");
    });
    Future.delayed(Duration(seconds: 6), () {
      showDropDownNotification("Test Dinner", "This is a dinner notification.");
    });
    Future.delayed(Duration(seconds: 9), () {
      showDropDownNotification(
          "Test Others", "This is an 'others' notification.");
    });
  }

  void scheduleBreakfastNotification() {
    breakfastTimer = Timer(Duration(seconds: 3), () {
      showDropDownNotification("Test Breakfast", "Log your breakfast now!");
      scheduleBreakfastNotification(); // Reschedule
    });
  }

  void scheduleLunchNotification() {
    lunchTimer = Timer(Duration(seconds: 6), () {
      showDropDownNotification("Test Lunch", "Log your lunch now!");
      scheduleLunchNotification(); // Reschedule
    });
  }

  void scheduleDinnerNotification() {
    dinnerTimer = Timer(Duration(seconds: 9), () {
      showDropDownNotification("Test Dinner", "Log your dinner now!");
      scheduleDinnerNotification(); // Reschedule
    });
  }

  void scheduleOthersNotification() {
    othersTimer = Timer(Duration(seconds: 12), () {
      showDropDownNotification("Test Others", "Log your other meals now!");
      scheduleOthersNotification(); // Reschedule
    });
  }

  void showDropDownNotification(String title, String message) {
    print("Notification Triggered: $title - $message");
    showSimpleNotification(
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(message),
      background: Colors.amber,
      foreground: Colors.black,
      trailing: Icon(Icons.notifications),
      duration: Duration(seconds: 3),
      slideDismiss: true, // Allow swipe to dismiss
    );
  }

  @override
  void dispose() {
    breakfastTimer.cancel();
    lunchTimer.cancel();
    dinnerTimer.cancel();
    othersTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Notifications"),
      ),
      body: const Center(
        child: Text("Drop-down notifications will appear at meal times."),
      ),
    );
  }
}
