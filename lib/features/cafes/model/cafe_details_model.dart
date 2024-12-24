import 'package:cloud_firestore/cloud_firestore.dart';

class CafeDetails {
  final String id;
  String name;
  String image;
  String location;
  final String vendorId;
  String openingTime;
  String closingTime;

  CafeDetails({
    required this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.vendorId,
    this.openingTime = '',
    this.closingTime = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'cafeName': name,
      'cafeImage': image,
      'cafeLocation': location,
      'vendorId': vendorId,
      'openingTime': openingTime,
      'closingTime': closingTime,
    };
  }

  // Static Function to Create an Empty User Model
  static CafeDetails empty() => CafeDetails(
        id: '',
        name: '',
        image: '',
        location: '',
        vendorId: '',
        openingTime: '',
        closingTime: '',
      );

  factory CafeDetails.fromMap(
      Map<String, dynamic> data, String documentId, String vendorID) {
    return CafeDetails(
      id: documentId,
      name: data['cafeName'] ?? '',
      image: data['cafeImage'] ?? '',
      location: data['cafeLocation'] ?? '',
      vendorId: vendorID,
      openingTime: data['openingTime'] ?? '',
      closingTime: data['closingTime'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "Id": id,
      'Cafe Name': name,
      'Cafe Details': location,
      'Cafe Image': image,
      'Vendor ID': vendorId,
      'Opening Time': openingTime,
      'Closing Time': closingTime,
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
        image: data['cafeImage'] ?? '',
        vendorId: data['vendorId'] ?? '',
        location: data['cafeLocation'] ?? '',
        openingTime: data['openingTime'] ?? '',
        closingTime: data['closingTime'] ?? '',
      );
    } else {
      return CafeDetails.empty();
    }
  }
}

class CafeItem {
  final String id;
  String itemName;
  double itemPrice;
  int itemCalories;
  String itemImage;
  String itemLocation;
  String itemCafe;
  String vendorId;
  String cafeId;

  CafeItem({
    required this.id,
    required this.itemName,
    required this.itemPrice,
    required this.itemCalories,
    required this.itemImage,
    required this.itemLocation,
    required this.itemCafe,
    required this.vendorId,
    required this.cafeId,
  });

  // Override toString to print a more readable output
  @override
  String toString() {
    return 'Cafe Item(Name: $itemName,cost: $itemPrice, Cafe: $itemCafe)';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'itemCost': itemPrice,
      'itemCalories': itemCalories,
      'itemImage': itemImage,
      'itemLocation': itemLocation,
      'itemCafe': itemCafe,
      'vendorId': vendorId,
      'cafeId': cafeId,
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
      itemCafe: '',
      vendorId: '',
      cafeId: '');

  factory CafeItem.fromMap(Map<String, dynamic> map, String documentId) {
    return CafeItem(
      id: documentId,
      itemName: map['itemName'] ?? 'Unknown Item',
      // Safely parse itemCost from String to double
      itemPrice: double.tryParse(map['itemCost']?.toString() ?? '0.0') ?? 0.0,
      // Safely parse itemCalories from String to int
      itemCalories: int.tryParse(map['itemCalories']?.toString() ?? '0') ?? 0,
      itemImage: map['itemImage'] ?? '',
      itemLocation: map['itemLocation'] ?? '',
      itemCafe: map['itemCafe'] ?? '',
      vendorId: map['vendorId'] ?? '',
      cafeId: map['cafeId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'itemName': itemName,
      'itemLocation': itemLocation,
      'itemCalories': itemCalories,
      'itemPrice': itemPrice,
      'itemCafe': itemCafe,
      'itemImage': itemImage,
      'vendorId': vendorId,
      'cafeId': cafeId,
    };
  }
}
