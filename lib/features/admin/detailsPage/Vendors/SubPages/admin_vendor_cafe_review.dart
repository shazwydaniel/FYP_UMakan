import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

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
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
        title: const Text('Reviews'),
      ),
      body: Obx(
        () {
          if (_reviewController.review.isEmpty) {
            return const Center(
              child: Text('No reviews available.',
                  style: TextStyle(fontSize: 16, color: Colors.black54)),
            );
          }

          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: ListView.builder(
              itemCount: _reviewController.review.length,
              itemBuilder: (context, index) {
                final review = _reviewController.review[index];
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.feedback,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: List.generate(
                                        review.rating.toInt(),
                                        (index) => const Icon(Icons.star,
                                            color: Colors.black, size: 16),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      DateFormat('dd MMM yyyy, hh:mm a')
                                          .format(review.timestamp),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'User: ${review.userId}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuButton<String>(
                                color: TColors.cream,
                                onSelected: (value) {
                                  if (value == 'Delete') {
                                    _discController.deleteReview(review);
                                  } else if (value == 'Edit') {
                                    _showUpdateReviewDialog(
                                        context, review, vendorId, cafeId);
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'Edit',
                                    child: Row(
                                      children: [
                                        Text('Edit'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem(
                                    value: 'Delete',
                                    child: Text('Delete'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      /* bottomNavigationBar: BottomAppBar(
        color: Colors.green,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Iconsax.add_circle,
                    color: Colors.white, size: 40),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),*/
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
          backgroundColor: TColors.cream,
          title: const Text('Update Review'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: feedbackController,
                  decoration: const InputDecoration(
                    labelText: 'Feedback',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: ratingController,
                  decoration: const InputDecoration(
                    labelText: 'Rating',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
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
                _reviewController.fetchReviews(vendorId, cafeId);
                Navigator.pop(context);
              },
              child:
                  const Text('Update', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
