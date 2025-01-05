import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  String entryId;
  final String userId;
  final String userName;
  final String feedback;
  final double rating;
  final DateTime timestamp;
  final String cafeId;
  final String cafeName;
  final String anonymous;
  String vendorId;

  ReviewModel({
    required this.entryId,
    required this.userId,
    required this.userName,
    required this.feedback,
    required this.rating,
    required this.timestamp,
    required this.cafeId,
    required this.cafeName,
    required this.anonymous,
    required this.vendorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'entry_ID': entryId,
      'userId': userId,
      'userName': userName,
      'feedback': feedback,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
      'cafeId': cafeId,
      'cafeName': cafeName,
      'anonymous': anonymous,
      'vendorId': vendorId
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'entry_ID': entryId,
      'userId': userId,
      'userName': userName,
      'feedback': feedback,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
      'cafeId': cafeId,
      'cafeName': cafeName,
      'anonymous': anonymous,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      entryId: map['entry_ID'] ?? '', // Default to an empty string if null
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? 'Anonymous', // Default to 'Anonymous'
      feedback: map['feedback'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      timestamp: map['timestamp'] != null
          ? (map['timestamp'] is String
              ? DateTime.parse(map['timestamp'])
              : (map['timestamp'] as Timestamp).toDate())
          : DateTime.now(), // Default to the current time if null
      cafeId: map['cafeId'] ?? '',
      cafeName: map['cafeName'] ?? '',
      anonymous: map['anonymous'] ?? 'No', // Default to 'No'
      vendorId: map['vendorId'] ?? '',
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      entryId: json['entry_ID'] ?? '', // Default to empty string
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Anonymous',
      feedback: json['feedback'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      cafeId: json['cafeId'] ?? '',
      cafeName: json['cafeName'] ?? '',
      anonymous: json['anonymous'] ?? 'No',
      vendorId: json['vendorId'] ?? '',
    );
  }
}
