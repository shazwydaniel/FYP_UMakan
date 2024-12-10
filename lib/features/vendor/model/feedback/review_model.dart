class ReviewModel {
  final String userId;
  final String userName;
  final String feedback;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.userId,
    required this.userName,
    required this.feedback,
    required this.rating,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'feedback': feedback,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      userId: map['userId'],
      userName: map['userName'],
      feedback: map['feedback'],
      rating: map['rating'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      userId: json['userId'],
      userName: json['userName'],
      feedback: json['feedback'],
      rating: json['rating'].toDouble(),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}
