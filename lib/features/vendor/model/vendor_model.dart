import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  final String id;
  final String vendorName;
  final String vendorEmail;
  final String contactInfo;
  final String role;
  final String password; // Add this field to match your controller

  Vendor({
    required this.id,
    required this.vendorName,
    required this.vendorEmail,
    required this.contactInfo,
    required this.role,
    required this.password, // Initialize it here
  });

  // Static Function to Create an Empty User Model
  static Vendor empty() => Vendor(
        id: '',
        vendorName: '',
        vendorEmail: '',
        contactInfo: '',
        password: '',
        role: '',
      );

  // Create a UserModel from Firebase Document Snapshot
  factory Vendor.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    if (document.data() != null) {
      final data = document.data()!;
      return Vendor(
          id: document.id,
          vendorName: data['Vendor Name'] ?? '',
          vendorEmail: data['Vendor Email'] ?? '',
          contactInfo: data['Contact Info'] ?? '',
          password: data['Password'] ?? '',
          role: data['Role'] ?? '');
    } else {
      return Vendor.empty();
    }
  }

  factory Vendor.fromMap(Map<String, dynamic> map, String id) {
    return Vendor(
      id: map['Id'],
      vendorName: map['Vendor Name'],
      contactInfo: map['Contact Info'],
      vendorEmail: map['Vendor Email'],
      role: map['Role'],
      password: map['Password'], // Extract it from the map
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Id': id,
      'Vendor Name': vendorName,
      'Contact Info': contactInfo,
      'Vendor Email': vendorEmail,
      'Role': role,
      'Password': password, // Include it in the JSON
    };
  }
}
