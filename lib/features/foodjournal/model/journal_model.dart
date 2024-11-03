class JournalItem {
  String? id; // Made id nullable
  final String name;
  final double price;
  final int calories;
  String imagePath;
  final String cafe;
  DateTime timestamp; // Mutable by removing 'final'

  JournalItem(
    this.imagePath, {
    this.id, // id is now optional
    required this.name,
    required this.price,
    required this.calories,
    required this.cafe,
    DateTime? timestamp, // Optional in constructor
  }) : timestamp =
            timestamp ?? DateTime.now(); // Initialize with current time if null

  // Convert a JournalItem to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id, // Handle nullable id
      'name': name,
      'price': price,
      'calories': calories,
      'imagePath': imagePath,
      'cafe': cafe,
      'timestamp': timestamp.toIso8601String(), // Store as ISO string
    };
  }

  // Create a JournalItem from a JSON object
  factory JournalItem.fromJson(Map<String, dynamic> json) {
    return JournalItem(
      json['imagePath'] ?? '',
      id: json['id'], // id can be null here
      name: json['name'] ?? '',
      cafe: json['cafe'] ?? '',
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : json['price'] ?? 0.0,
      calories: (json['calories'] is String)
          ? int.tryParse(json['calories']) ?? 0
          : json['calories'] ?? 0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  // Create a JournalItem from a Map object
  factory JournalItem.fromMap(Map<String, dynamic> data, String documentId) {
    return JournalItem(
      data['imagePath'] ?? '',
      id: documentId, // Still allow documentId to assign id if needed
      name: data['name'] ?? '',
      cafe: data['cafe'] ?? '',
      price: (data['price'] is String)
          ? double.tryParse(data['price']) ?? 0.0
          : data['price'] ?? 0.0,
      calories: (data['calories'] is String)
          ? int.tryParse(data['calories']) ?? 0
          : data['calories'] ?? 0,
      timestamp: data['timestamp'] != null
          ? DateTime.tryParse(data['timestamp']) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  // Convert JournalItem to Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'cafe': cafe,
      'price': price,
      'imagePath': imagePath,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(), // Store as ISO string
    };
  }

  // Static Function to Create an Empty JournalItem
  static JournalItem empty() => JournalItem(
        '',
        id: null, // id is optional, so default to null
        name: '',
        cafe: '',
        price: 0,
        calories: 0,
      );
}
