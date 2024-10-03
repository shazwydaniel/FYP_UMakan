import 'package:cloud_firestore/cloud_firestore.dart';

class CafeDetails {
  final String id;
  String name;
  String logo;
  String location;
  final String vendorId;
  //final List<String> cafeReviews;

  CafeDetails(
      //this.cafeReviews,
      {
    required this.id,
    required this.name,
    required this.logo,
    required this.location,
    required this.vendorId,
  });

  Map<String, dynamic> toMap() {
    return {
      'cafeName': name,
      'cafeLogo': logo,
      'cafeLocation': location,
      'vendorId': vendorId,
      //'cafeReviews': cafeReviews,
    };
  }

  // Static Function to Create an Empty User Model
  static CafeDetails empty() => CafeDetails(
        id: '',
        name: '',
        logo: '',
        location: '',
        vendorId: '',
      );

  factory CafeDetails.fromMap(
      Map<String, dynamic> data, String documentId, String vendorID) {
    return CafeDetails(
      id: documentId,
      name: data['cafeName'] ?? '',
      logo: data['cafeLogo'] ?? '',
      location: data['cafeLocation'] ?? '',
      vendorId: vendorID,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      'Cafe Name': name,
      'Cafe Details': location,
      'Cafe Image': logo,
      'Vendor ID': vendorId,
      // 'Cafe Reviews': cafeReviews,
    };
  }

  // Create a UserModel from Firebase Document Snapshot
  factory CafeDetails.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return CafeDetails(
        id: document.id,
        name: data['cafeName'] ?? '',
        logo: data['logoName'] ?? '',
        vendorId: data['vendorId'] ?? '',
        location: data['cafeLocation'] ?? '',
      );
    } else {
      return CafeDetails.empty();
    }
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
