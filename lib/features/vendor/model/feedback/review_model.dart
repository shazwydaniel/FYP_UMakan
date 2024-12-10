class ReviewModel {
  final String userId;
  final String userName;
  final String feedback;
  final double rating;
  final DateTime timestamp;
  final String cafeId;
  final String cafeName;
  final String anonymous;

  ReviewModel({
    required this.userId,
    required this.userName,
    required this.feedback,
    required this.rating,
    required this.timestamp,
    required this.cafeId,
    required this.cafeName,
    required this.anonymous,
  });

  Map<String, dynamic> toMap() {
    return {
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
      userId: map['userId'],
      userName: map['userName'],
      feedback: map['feedback'],
      rating: map['rating'],
      timestamp: DateTime.parse(map['timestamp']),
      cafeId: map['cafeId'],
      cafeName: map['cafeName'],
      anonymous: map['anonymous'],
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'],
      userName: json['userName'],
      feedback: json['feedback'],
      rating: json['rating'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
      cafeId: json['cafeId'],
      cafeName: json['cafeName'],
      anonymous: json['anonymous'],
    );
  }
}
