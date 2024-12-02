import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AuthorityController extends GetxController {
  static AuthorityController get instance => Get.find();

  // Example observable
  final profileData = {}.obs;

  Future<void> fetchProfile() async {
    // Fetch authority data from Firestore
    try {
      final doc = await FirebaseFirestore.instance
          .collection('Authority')
          .doc('authority001')
          .get();
      if (doc.exists) {
        profileData.value = doc.data()!;
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
}