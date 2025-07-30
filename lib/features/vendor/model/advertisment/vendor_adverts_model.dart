import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class Advertisement {
  final String id;
  final String cafeName;
  final String cafeId;
  String location;
  String detail;
  DateTime? startDate;
  DateTime? endDate;
  String status;

  Advertisement({
    required this.id,
    required this.cafeName,
    required this.location,
    required this.detail,
    required this.startDate,
    required this.endDate,
    required this.cafeId,
    required this.status,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cafeName': cafeName,
      'cafeId': cafeId,
      'location': location,
      'detail': detail,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
    };
  }

  factory Advertisement.fromMap(Map<String, dynamic> data, String documentId) {
    return Advertisement(
      id: documentId,
      cafeName: data['cafeName'] ?? '',
      cafeId: data['cafeId'] ?? '',
      location: data['location'] ?? '',
      detail: data['detail'] ?? '',
      startDate: data['startDate'] != null
          ? DateTime.tryParse(data['startDate']) ?? DateTime.now()
          : null, // Use null if no valid date is found.
      endDate: data['endDate'] != null
          ? DateTime.tryParse(data['endDate']) ?? DateTime.now()
          : null,
      status: data['status'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cafeName': cafeName,
      'cafeId': cafeId,
      'location': location,
      'detail': detail,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'status': status,
    };
  }

  factory Advertisement.fromJson(Map<String, dynamic> json) {
    return Advertisement(
      id: json['id'] ?? '', // Handle missing id gracefully.
      cafeName: json['cafeName'] ?? '',
      cafeId: json['cafeId'] ?? '',
      location: json['location'] ?? '',
      detail: json['detail'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'])
          : null,
      endDate:
          json['endDate'] != null ? DateTime.tryParse(json['endDate']) : null,
      status: json['status'] ?? '',
    );
  }

  factory Advertisement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Advertisement(
      id: doc.id,
      detail: data['detail'] ?? '',
      startDate:
          data['startDate'] != null ? DateTime.parse(data['startDate']) : null,
      endDate: data['endDate'] != null ? DateTime.parse(data['endDate']) : null,
      cafeName: data['cafeName'] ?? '',
      location: data['location'] ?? '',
      cafeId: data['cafeId'] ?? '',
      status: data['status'] ?? '',
    );
  }

  // Return an empty Advertisement instance.
  static Advertisement empty() => Advertisement(
        id: '',
        cafeName: '',
        cafeId: '',
        location: '',
        detail: '',
        startDate: null,
        endDate: null,
        status: '',
      );
}
