class TimeRange {
  final DateTime start;
  final DateTime end;

  TimeRange(this.start, this.end);
}

TimeRange getCurrentTimeRange() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  if (now.isBefore(today.add(Duration(hours: 12)))) {
    return TimeRange(today.add(Duration(hours: 6)),
        today.add(Duration(hours: 12))); // Breakfast
  } else if (now.isBefore(today.add(Duration(hours: 16)))) {
    return TimeRange(today.add(Duration(hours: 12)),
        today.add(Duration(hours: 16))); // Lunch
  } else if (now.isBefore(today.add(Duration(hours: 1)))) {
    return TimeRange(
        today.add(Duration(hours: 0)), today.add(Duration(hours: 1))); // Dinner
  } else {
    return TimeRange(today.add(Duration(hours: 21)),
        today.add(Duration(days: 1))); // No notifications
  }
}
