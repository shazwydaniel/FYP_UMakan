import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final VendorRepository _vendorRepository = VendorRepository();
  final RxList<ReviewModel> review = RxList<ReviewModel>();
  final RxBool isLoadingReviews = false.obs;
  final foodJRepository = FoodJournalRepository.instance;

  Future<void> fetchReviews(String vendorId, String cafeId) async {
    try {
      isLoadingReviews.value = true;
      final fetchedReviews =
          await _vendorRepository.fetchReviews(vendorId, cafeId);
      review.assignAll(fetchedReviews);
    } catch (e) {
      print('Error fetching reviews: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<String> getHighestRatedCafe(String vendorId) async {
    String mostFiveStars =
        await foodJRepository.getCafeWithMostFiveStars(vendorId);
    print("Most 5-Star Reviews: $mostFiveStars");
    return mostFiveStars;
  }

  Future<String> getLowestRatedCafe(String vendorId) async {
    String mostOneStars =
        await foodJRepository.getCafeWithMostOneStars(vendorId);
    print("Most 1-Star Reviews: $mostOneStars");
    return mostOneStars;
  }
}
