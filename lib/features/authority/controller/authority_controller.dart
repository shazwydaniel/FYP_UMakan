import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthorityController extends GetxController {
  static AuthorityController get instance => Get.find();

  final profileData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance.collection('Authority').doc(user.uid).get();
      if (doc.exists) {
        profileData.value = doc.data()!;
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }
}