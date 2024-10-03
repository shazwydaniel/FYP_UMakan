class JournalItem {
  final String id;
  final String name;
  final double price;
  final int calories;
  String imagePath;
  final String cafe;

  JournalItem(this.imagePath,
      {required this.id,
      required this.name,
      required this.price,
      required this.calories,
      required this.cafe});

  // Convert a JournalItem to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'calories': calories,
      'imagePath': imagePath,
      'cafe': cafe,
    };
  }

  // Create a JournalItem from a JSON object
  factory JournalItem.fromJson(Map<String, dynamic> json) {
    return JournalItem(
      json['imagePath'] ?? '',
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cafe: json['cafe'] ?? '',
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : json['price'] ?? 0.0,
      calories: (json['calories'] is String)
          ? int.tryParse(json['calories']) ?? 0
          : json['calories'] ?? 0,
    );
  }

  // Create a JournalItem from a Map object
  factory JournalItem.fromMap(Map<String, dynamic> data, String documentId) {
    return JournalItem(
      data['imagePath'] ?? '',
      id: documentId,
      name: data['name'] ?? '',
      cafe: data['cafe'] ?? '',
      price: (data['price'] is String)
          ? double.tryParse(data['price']) ?? 0.0
          : data['price'] ?? 0.0,
      calories: (data['calories'] is String)
          ? int.tryParse(data['calories']) ?? 0
          : data['calories'] ?? 0,
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
    };
  }

  // Static Function to Create an Empty JournalItem
  static JournalItem empty() => JournalItem(
        '',
        id: '',
        name: '',
        cafe: '',
        price: 0,
        calories: 0,
      );
}
