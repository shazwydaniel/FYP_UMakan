import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';

class AdminReviewsPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;

  AdminReviewsPage({required this.vendorId, required this.cafeId});

  final ReviewController _reviewController = Get.put(ReviewController());
  final DiscoverController _discController =
      Get.put(DiscoverController(Get.put(VendorRepository())));

  @override
  Widget build(BuildContext context) {
    _reviewController.fetchReviews(vendorId, cafeId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
        backgroundColor: Colors.green,
      ),
      body: Obx(
        () {
          if (_reviewController.review.isEmpty) {
            return const Center(child: Text('No reviews available.'));
          }

          return ListView.builder(
            itemCount: _reviewController.review.length,
            itemBuilder: (context, index) {
              final review = _reviewController.review[index];

              return Card(
                child: ListTile(
                  title: Text('Rating: ${review.rating}'),
                  subtitle: Text(review.feedback),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _discController.deleteReview(review);
                    },
                  ),
                  onTap: () => _showUpdateReviewDialog(
                      context, review, vendorId, cafeId),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showUpdateReviewDialog(BuildContext context, ReviewModel review,
      String vendorId, String cafeId) {
    final feedbackController = TextEditingController(text: review.feedback);
    final ratingController =
        TextEditingController(text: review.rating.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: feedbackController,
                decoration: const InputDecoration(labelText: 'Feedback'),
              ),
              TextFormField(
                controller: ratingController,
                decoration: const InputDecoration(labelText: 'Rating'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                final updatedFeedback = feedbackController.text.trim();
                final updatedRating =
                    double.tryParse(ratingController.text.trim()) ??
                        review.rating;
                await _discController.updateReview(
                  review,
                  updatedFeedback,
                  updatedRating,
                  review.anonymous,
                );
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
