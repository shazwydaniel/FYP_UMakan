import 'dart:math';

class Advertisement {
  final String id;
  final String cafeName;
  final String location;
  final String detail;
  final DateTime? startDate;
  final DateTime? endDate;

  Advertisement({
    required this.id,
    required this.cafeName,
    required this.location,
    required this.detail,
    required this.startDate,
    required this.endDate,
  });

  // Convert Advertisement to JSON (dates as ISO strings).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafeName': cafeName,
      'location': location,
      'detail': detail,
      'startDate': startDate?.toIso8601String(), // Convert DateTime to string.
      'endDate': endDate?.toIso8601String(), // Handle nulls gracefully.
    };
  }

  // Create an Advertisement from a Map object.
  factory Advertisement.fromMap(Map<String, dynamic> data, String documentId) {
    return Advertisement(
      id: documentId,
      cafeName: data['cafeName'] ?? '',
      location: data['location'] ?? '',
      detail: data['detail'] ?? '',
      startDate: data['startDate'] != null
          ? DateTime.tryParse(data['startDate']) ?? DateTime.now()
          : null, // Use null if no valid date is found.
      endDate: data['endDate'] != null
          ? DateTime.tryParse(data['endDate']) ?? DateTime.now()
          : null,
    );
  }

  // Convert Advertisement to a Map (for database operations).
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cafeName': cafeName,
      'location': location,
      'detail': detail,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  // Create an Advertisement from a JSON object.
  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] ?? '', // Handle missing id gracefully.
      cafeName: json['cafeName'] ?? '',
      location: json['location'] ?? '',
      detail: json['detail'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
    );
  }

  // Return an empty Advertisement instance.
  static Advertisement empty() => Advertisement(
        id: '',
        cafeName: '',
        location: '',
        detail: '',
        startDate: null, // Use null to represent an empty date.
        endDate: null,
      );
}
