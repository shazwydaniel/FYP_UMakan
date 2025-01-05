import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/features/admin/model/admin_model.dart';
import 'package:get/get.dart';

class AdminRepository {
  static AdminRepository get instance => Get.find();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserCredential> registerAdmin(
      String email, String password, String adminName) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _db.collection('Admins').doc(userCredential.user!.uid).set({
        'Admin Name': adminName,
        'Admin Email': email,
        'Role': 'Admin',
      });

      return userCredential;
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }

  Future<Admin> fetchAdminDetails() async {
    try {
      final documentSnapshot = await _db
          .collection('Admins')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return Admin.fromSnapshot(documentSnapshot);
      } else {
        return Admin.empty();
      }
    } catch (e) {
      print('Error fetching admin details: $e');
      throw 'Failed to fetch admin details';
    }
  }

  Future<void> createAdmin(Admin admin) async {
    try {
      await _db.collection('Admins').doc(admin.id).set(admin.toJson());
    } catch (e) {
      print('Error creating admin: $e');
      throw 'Failed to create admin';
    }
  }

  Future<void> deleteAdmin(String adminId) async {
    try {
      await _db.collection('Admins').doc(adminId).delete();
    } catch (e) {
      print('Error deleting admin: $e');
      throw 'Failed to delete admin';
    }
  }

  Future<List<Admin>> getAllAdmins() async {
    try {
      final snapshot = await _db.collection('Admins').get();
      return snapshot.docs.map((doc) => Admin.fromSnapshot(doc)).toList();
    } catch (e) {
      print('Error fetching all admins: $e');
      throw 'Failed to fetch admins';
    }
  }
}
