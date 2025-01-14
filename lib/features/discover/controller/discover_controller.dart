import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:fyp_umakan/features/vendor/model/vendor_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class DiscoverController extends GetxController {
  static DiscoverController get instance => Get.find();

  final VendorRepository vendorRepository;
  var cafe = <CafeDetails>[].obs;
  var menuItems = <CafeItem>[].obs;
  var isLoading = true.obs;
  final ReviewController reviewController = Get.put(ReviewController());

  final RxList<ReviewModel> userReviews = RxList<ReviewModel>();
  var reviews = <ReviewModel>[].obs;
  final RxBool isLoadingReviews = false.obs;

  DiscoverController(this.vendorRepository);
  late String userId;

  get isLoadingCafes => null;

  @override
  void onInit() {
    super.onInit();

    userId = getCurrentUserId();
    fetchUserReviews(userId);
    print("Current user id in Discover Controller: ${userId}");
  }

  String getCurrentUserId() {
    // Get the current user from FirebaseAuth
    User? user = FirebaseAuth.instance.currentUser;

    // Check if the user is logged in
    if (user != null) {
      // Return the user ID (UID)
      return user.uid;
    } else {
      // Handle the case when there is no user logged in
      throw Exception('No user is currently signed in');
    }
  }

  void fetchAndPrintVendorNames() async {
    final vendorRepository = VendorRepository();
    final vendors = await vendorRepository.getAllVendors();

    for (var vendor in vendors) {
      print("Vendor Name: ${vendor.vendorName}"); // Print the vendor names
    }
  }

  void fetchAllCafesFromAllVendors() async {
    final allCafes = await vendorRepository.getAllCafesFromAllVendors();
    print(
        "Total cafes fetched from all vendors: ${allCafes.length}"); // Debug log
    cafe.assignAll(allCafes); // Update observable list with all cafes
  }

  void fetchAllCafes() async {
    final allCafes = await vendorRepository.getAllCafes();
    print("Fetched cafes: $allCafes");
    cafe.assignAll(allCafes);
  }

  Future<void> fetchMenuItems(String vendorId, String cafeId) async {
    try {
      isLoading.value = true;
      menuItems.clear();

      // Call the getItemsForCafe method from VendorRepository
      List<CafeItem> items =
          await vendorRepository.getItemsForCafe(vendorId, cafeId);

      menuItems.addAll(items);
    } catch (e) {
      print("Error fetching menu items: $e");
      Get.snackbar('Error', 'Failed to load menu items');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUserReviews(String userId) async {
    try {
      print("Fetching reviews for user: $userId");
      isLoadingReviews.value = true;

      // Fetch reviews via ReviewController
      final fetchedReviews = await reviewController.fetchUserFeedback(userId);

      // Assign reviews to userReviews
      userReviews.assignAll(fetchedReviews);

      // Log reviews fetched from ReviewController
      print("Fetched reviews: ${reviewController.review}");

      // Log the updated userReviews
      print("Updated userReviews: ${userReviews.length} items");
    } catch (e) {
      print('Error fetching user reviews: $e');
    } finally {
      isLoadingReviews.value = false;
    }
  }

  Future<void> updateReview(ReviewModel review, String feedback, double rating,
      String anonymous) async {
    try {
      final updatedReview = {
        'feedback': feedback,
        'rating': rating,
        'timestamp': DateTime.now(),
        'anonymous': anonymous,
      };

      // Update in UserReviews collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(review.userId)
          .collection('UserReviews')
          .doc(review.entryId)
          .update(updatedReview);

      // Update in Vendors collection
      await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(review.vendorId)
          .collection('Cafe')
          .doc(review.cafeId)
          .collection('Reviews')
          .doc(review.entryId)
          .update(updatedReview);

      // Refresh reviews after update
      fetchUserReviews(review.userId);
    } catch (e) {
      print('Error updating review: $e');
    }
  }

  Future<void> deleteReview(ReviewModel review) async {
    try {
      // Delete from UserReviews collection
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(review.userId)
          .collection('UserReviews')
          .doc(review.entryId)
          .delete();

      // Delete from Vendors collection
      await FirebaseFirestore.instance
          .collection('Vendors')
          .doc(review.vendorId)
          .collection('Cafe')
          .doc(review.cafeId)
          .collection('Reviews')
          .doc(review.entryId)
          .delete();

      // Refresh reviews after deletion
      fetchUserReviews(review.userId);
    } catch (e) {
      print('Error deleting review: $e');
    }
  }
}
