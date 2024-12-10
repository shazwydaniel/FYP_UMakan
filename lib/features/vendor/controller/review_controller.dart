import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  Future<void> submitFeedback({
    required String vendorId,
    required String cafeId,
    required ReviewModel feedback,
  }) async {
    try {
      final feedbackCollection = FirebaseFirestore.instance
          .collection('Vendors')
          .doc(vendorId)
          .collection('Cafe')
          .doc(cafeId)
          .collection('Feedback');

      await feedbackCollection.add(feedback.toMap());
    } catch (e) {
      print('Error submitting feedback: $e');
      rethrow;
    }
  }

  Stream<List<ReviewModel>> getFeedback({
    required String vendorId,
    required String cafeId,
  }) {
    final feedbackCollection = FirebaseFirestore.instance
        .collection('Vendors')
        .doc(vendorId)
        .collection('Cafe')
        .doc(cafeId)
        .collection('Feedback');

    return feedbackCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => ReviewModel.fromMap(doc.data()))
          .toList();
    });
  }
}
