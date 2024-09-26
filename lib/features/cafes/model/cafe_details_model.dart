// lib/features/cafes/model/cafe_model.dart

class CafeDetails {
  final String id;
  String name;
  String logo;
  String details;
  //final List<String> cafeReviews;

  CafeDetails(
      //this.cafeReviews,
      {
    required this.id,
    required this.name,
    required this.logo,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'cafeName': name,
      'cafeLogo': logo,
      'cafeDetails': details,
      //'cafeReviews': cafeReviews,
    };
  }

  // Static Function to Create an Empty User Model
  static CafeDetails empty() => CafeDetails(
        id: '',
        name: '',
        logo: '',
        details: '',
      );

  factory CafeDetails.fromMap(Map<String, dynamic> data, String documentId) {
    return CafeDetails(
      id: documentId,
      name: data['cafeName'] ?? '',
      logo: data['cafeLogo'] ?? '',
      details: data['cafeDetails'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      'Cafe Name': name,
      'Cafe Details': details,
      'Cafe Image': logo,
      // 'Cafe Reviews': cafeReviews,
    };
  }
}

class CafeItem {
  final String id;
  final String itemName;
  final double itemPrice;
  final int itemCalories;
  final String itemImage;
  final String itemLocation;

  CafeItem({
    required this.id,
    required this.itemName,
    required this.itemPrice,
    required this.itemCalories,
    required this.itemImage,
    required this.itemLocation,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'itemCost': itemPrice,
      'itemCalories': itemCalories,
      'itemImage': itemImage,
      'itemLocation': itemLocation,
    };
  }

  // Static Function to Create an Empty CafeItem Model
  static CafeItem empty() => CafeItem(
        id: '',
        itemName: '',
        itemPrice: 0,
        itemCalories: 0,
        itemImage: '',
        itemLocation: '',
      );

  factory CafeItem.fromMap(Map<String, dynamic> map, String documentId) {
    return CafeItem(
      id: documentId,
      itemName: map['itemName'] ?? 'Unknown Item',
      itemPrice: (map['itemCost'] as num?)?.toDouble() ??
          0.0, // Ensure 'itemCost' is present
      itemCalories: (map['itemCalories'] as num?)?.toInt() ?? 0,
      itemImage: map['itemImage'] ?? '', // Provide default if null
      itemLocation: map['itemLocation'] ?? '', // Provide default if null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Item Name': itemName,
      'Item Location': itemLocation,
      'Item Calories': itemCalories,
      'Item Price': itemPrice,
    };
  }
}
