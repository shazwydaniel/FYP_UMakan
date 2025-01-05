import 'package:cloud_firestore/cloud_firestore.dart';

class Admin {
  final String id;
  final String adminName;
  final String adminEmail;
  final String password;
  final String role;

  Admin({
    required this.id,
    required this.adminName,
    required this.adminEmail,
    required this.password,
    this.role = 'Admin',
  });

  static Admin empty() => Admin(
        id: '',
        adminName: '',
        adminEmail: '',
        password: '',
      );

  factory Admin.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return Admin(
      id: document.id,
      adminName: data['Admin Name'] ?? '',
      adminEmail: data['Admin Email'] ?? '',
      password: data['Password'] ?? '',
      role: data['Role'] ?? 'Admin',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Admin Name': adminName,
      'Admin Email': adminEmail,
      'Password': password,
      'Role': role,
    };
  }
}
