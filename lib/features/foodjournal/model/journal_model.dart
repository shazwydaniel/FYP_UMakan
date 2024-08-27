class JournalItem {
  final String name;
  final double price;
  final int calories;
  final String imagePath;
  final String cafe;

  JournalItem(
      {required this.name,
      required this.price,
      required this.calories,
      required this.imagePath,
      required this.cafe});

  // Convert a JournalItem to a JSON object
  Map<String, dynamic> toJson() {
    return {
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
      name: json['name'],
      cafe: json['cafe'],
      price: json['price'],
      imagePath: json['imagePath'],
      calories: json['calories'],
    );
  }
}
