import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/features/admin/admin_repository.dart';
import 'package:fyp_umakan/features/admin/model/admin_model.dart';
import 'package:get/get.dart';

class AdminController extends GetxController {
  static AdminController get instance => Get.find();

  final AdminRepository adminRepository = Get.put(AdminRepository());

  Rx<Admin> admin = Admin.empty().obs;
  final admins = <Admin>[].obs;

  // Admin Details
  final adminName = TextEditingController();
  final adminEmail = TextEditingController();
  final adminPassword = TextEditingController();

  // Form key for validation
  GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchAdminRecord();
    print(
        "AdminController initialized for admin ID: ${FirebaseAuth.instance.currentUser?.uid}");
  }

  // Fetch admin record
  Future<void> fetchAdminRecord() async {
    try {
      final user = await adminRepository.fetchAdminDetails();
      if (user.id != null && user.id.isNotEmpty) {
        admin(user); // Assign fetched admin
      } else {
        throw Exception("Admin ID is null or empty");
      }
    } catch (e) {
      print("Error fetching admin: $e");
      admin(Admin.empty());
    }
  }

  Future<void> registerAdmin() async {
    try {
      if (!adminFormKey.currentState!.validate()) {
        Get.snackbar('Error', 'Please fill all fields correctly');
        return;
      }

      final userCredential = await AdminRepository.instance.registerAdmin(
        adminEmail.text.trim(),
        adminPassword.text.trim(),
        adminName.text.trim(),
      );

      final newAdmin = Admin(
        id: userCredential.user!.uid,
        adminName: adminName.text.trim(),
        adminEmail: adminEmail.text.trim(),
        password: adminPassword.text.trim(),
      );

      await adminRepository.createAdmin(newAdmin);

      Get.snackbar('Success', 'Admin registered successfully!');
    } catch (e) {
      print('Error registering admin: $e');
      Get.snackbar('Error', 'Failed to register admin');
    }
  }
}
