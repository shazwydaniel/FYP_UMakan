import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';

class CafeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var cafes = <CafeDetails>[].obs;
  var isLoading = false.obs; // Add this line

  @override
  void onInit() {
    super.onInit();
    fetchCafes();
  }

  Future<void> fetchCafes() async {
    try {
      isLoading.value = true;
      var querySnapshot = await _firestore.collection('cafes').get();
      var fetchedCafes = querySnapshot.docs.map((doc) {
        var data = doc.data();
        return CafeDetails.fromMap(data, doc.id);
      }).toList();
      cafes.assignAll(fetchedCafes);
    } catch (e) {
      print("Failed to fetch cafes: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
