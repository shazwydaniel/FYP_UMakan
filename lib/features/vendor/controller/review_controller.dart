import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<String> getHighestRatedCafe() async {
    final Map<String, List<double>> cafeRatings = {};

    for (var item in review) {
      if (item.cafeName != null) {
        cafeRatings[item.cafeName] ??= [];
        cafeRatings[item.cafeName]!.add(item.rating);
      }
    }

    String highestRatedCafe = '';
    double highestAverageRating = 0.0;

    cafeRatings.forEach((cafe, ratings) {
      double averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
      if (averageRating > highestAverageRating) {
        highestRatedCafe = cafe;
        highestAverageRating = averageRating;
      }
    });

    return highestRatedCafe;
  }

  Future<String> getLowestRatedCafe() async {
    final Map<String, List<double>> cafeRatings = {};

    for (var item in review) {
      if (item.cafeName != null) {
        cafeRatings[item.cafeName] ??= [];
        cafeRatings[item.cafeName]!.add(item.rating);
      }
    }

    String lowestRatedCafe = '';
    double lowestAverageRating = double.infinity;

    cafeRatings.forEach((cafe, ratings) {
      double averageRating = ratings.reduce((a, b) => a + b) / ratings.length;
      if (averageRating < lowestAverageRating) {
        lowestRatedCafe = cafe;
        lowestAverageRating = averageRating;
      }
    });

    return lowestRatedCafe;
  }
}
