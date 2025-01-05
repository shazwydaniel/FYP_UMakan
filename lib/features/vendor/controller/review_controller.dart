import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/data/repositories/food_journal/food_journal_repository.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
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

  @override
  void onInit() {
    super.onInit();
    // Optional: You can initialize something here if needed
  }

  Future<void> addReview({
    required String vendorId,
    required String cafeId,
    required String userId,
    required String userName,
    required String feedback,
    required double rating,
    required DateTime timestamp,
    required String cafeName,
    required String anonymous,
  }) async {
    try {
      // Create the ReviewModel
      Map<String, dynamic> reviewData = {
        'userId': userId,
        'userName': userName,
        'feedback': feedback,
        'rating': rating,
        'timestamp': timestamp,
        'cafeId': cafeId,
        'cafeName': cafeName,
        'anonymous': anonymous,
        'vendorId': vendorId,
      };

      // Submit feedback to Firebase
      await _vendorRepository.submitFeedback(
        vendorId: vendorId,
        cafeId: cafeId,
        feedback: reviewData,
      );

      // Log the confirmation
      print('Review added successfully');
    } catch (e) {
      // Handle errors
      print('Error adding review: $e');
    }
  }

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

  Future<List<ReviewModel>> fetchUserFeedback(String userId) async {
    try {
      print("Fetching user feedback for userId: $userId");

      final snapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .collection('UserReviews')
          .orderBy('timestamp', descending: true)
          .get();

      print("Snapshot length: ${snapshot.docs.length}");
      print("Snapshot data: ${snapshot.docs.map((e) => e.data())}");

      // Map Firestore data to a list of ReviewModel
      final reviews = snapshot.docs.map((doc) {
        final data = doc.data();
        return ReviewModel(
          entryId: data['entry_ID'] ?? '',
          userId: data['userId'] ?? '',
          userName: data['userName'] ?? 'Anonymous',
          feedback: data['feedback'] ?? '',
          rating: (data['rating'] ?? 0).toDouble(),
          timestamp:
              (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          cafeId: data['cafeId'] ?? '',
          cafeName: data['cafeName'] ?? '',
          anonymous: data['anonymous'] ?? 'No',
          vendorId: data['vendorId'] ?? '',
        );
      }).toList();

      print("Fetched and mapped ${reviews.length} reviews");
      return reviews; // Return the fetched list of reviews
    } catch (e) {
      print('Error fetching user feedback: $e');
      return []; // Return an empty list in case of an error
    }
  }
}
