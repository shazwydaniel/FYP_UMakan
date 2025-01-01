class JournalItem {
  String id;
  final String name;
  final double price;
  final int calories;
  String imagePath;
  final String cafe;
  DateTime timestamp;
  final String vendorId;
  final String cafeId;
  final String cafeLocation;
  bool isSpicy;
  bool isVegetarian;
  bool isLowSugar;

  JournalItem(
      {this.isSpicy = false,
      this.isVegetarian = false,
      this.isLowSugar = false,
      required this.id,
      required this.name,
      required this.price,
      required this.calories,
      required this.cafe,
      required this.imagePath,
      DateTime? timestamp,
      required this.vendorId,
      required this.cafeId,
      required this.cafeLocation})
      : timestamp = timestamp ?? DateTime.now();

  // Override toString to print a more readable output
  @override
  String toString() {
    return 'JournalItem(foodName: $name)';
  }

  // Convert a JournalItem to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'calories': calories,
      'imagePath': imagePath,
      'cafe': cafe,
      'timestamp': timestamp.toIso8601String(),
      'vendorId': vendorId,
      'cafeId': cafeId,
      'cafeLocation': cafeLocation,
      'isSpicy': isSpicy,
      'isVegetarian': isVegetarian,
      'isLowSugar': isLowSugar,
    };
  }

  factory JournalItem.fromJson(Map<String, dynamic> json) {
    return JournalItem(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      cafe: json['cafe'] ?? '',
      price: (json['price'] is num)
          ? (json['price'] as num).toDouble() // Ensure it’s a double
          : (json['price'] is String)
              ? double.tryParse(json['price']) ?? 0.0
              : 0.0,
      calories: (json['calories'] is num)
          ? (json['calories'] as num).toInt() // Ensure it’s an int
          : (json['calories'] is String)
              ? int.tryParse(json['calories']) ?? 0
              : 0,
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      imagePath: json['imagePath'] ?? '',
      vendorId: json['vendorId'] ?? '',
      cafeId: json['cafeId'] ?? '',
      cafeLocation: json['cafeLocation'] ?? '',
      isSpicy: json['isSpicy'] ?? false,
      isVegetarian: json['isVegetarian'] ?? false,
      isLowSugar: json['isLowSugar'] ?? false,
    );
  }

  factory JournalItem.fromMap(Map<String, dynamic> data, String documentId) {
    return JournalItem(
      id: documentId,
      name: data['name'] ?? '',
      cafe: data['cafe'] ?? '',
      price: (data['price'] is num)
          ? (data['price'] as num).toDouble() // Ensure it’s a double
          : (data['price'] is String)
              ? double.tryParse(data['price']) ?? 0.0
              : 0.0,
      calories: (data['calories'] is num)
          ? (data['calories'] as num).toInt() // Ensure it’s an int
          : (data['calories'] is String)
              ? int.tryParse(data['calories']) ?? 0
              : 0,
      timestamp: data['timestamp'] != null
          ? DateTime.tryParse(data['timestamp']) ?? DateTime.now()
          : DateTime.now(),
      imagePath: data['imagePath'] ?? '',
      vendorId: data['vendorId'] ?? '',
      cafeId: data['cafeId'] ?? '',
      cafeLocation: data['cafeLocation'] ?? '',
      isSpicy: data['isSpicy'] ?? false,
      isVegetarian: data['isVegetarian'] ?? false,
      isLowSugar: data['isLowSugar'] ?? false,
    );
  }

  // Convert JournalItem to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cafe': cafe,
      'price': price,
      'imagePath': imagePath,
      'calories': calories,
      'timestamp': timestamp.toIso8601String(),
      'vendorId': vendorId,
      'cafeId': cafeId,
      'cafeLocation': cafeLocation,
      'isSpicy': isSpicy,
      'isVegetarian': isVegetarian,
      'isLowSugar': isLowSugar,
    };
  }

  // Static Function to Create an Empty JournalItem
  static JournalItem empty() => JournalItem(
        id: '',
        name: '',
        cafe: '',
        price: 0,
        calories: 0,
        imagePath: '',
        vendorId: '',
        cafeId: '',
        cafeLocation: '',
        isSpicy: false,
        isVegetarian: false,
        isLowSugar: false,
      );
}
