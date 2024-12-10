import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ViewReviewPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;
  final String cafeName;

  ViewReviewPage({
    required this.vendorId,
    required this.cafeId,
    required this.cafeName,
  });

  final ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    reviewController.fetchReviews(vendorId, cafeId);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 107, 91, 2),
      appBar: AppBar(
        title: Text(
          'Reviews for $cafeName',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 107, 91, 2),
        iconTheme: IconThemeData(
          color: Colors.white, // Sets the color of the back icon to white
        ),
      ),
      body: Obx(() {
        if (reviewController.isLoadingReviews.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (reviewController.review.isEmpty) {
          return Center(
            child: Text(
              'No reviews available.',
              style: TextStyle(fontSize: 16, color: TColors.textLight),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: reviewController.review.length,
          itemBuilder: (context, index) {
            final review = reviewController.review[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stars and Reviewer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        review.rating.toInt(),
                        (index) =>
                            Icon(Icons.star, color: Colors.amber, size: 16),
                      ),
                    ),
                    if (review.anonymous !=
                        'Yes') // Show username only if not anonymous
                      Row(
                        children: [
                          Icon(Icons.person,
                              color: TColors.textLight, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Anonymous",
                            style: TextStyle(
                                fontSize: 14, color: TColors.textLight),
                          ),
                        ],
                      ),
                    if (review.anonymous !=
                        'No') // Show username only if not anonymous
                      Row(
                        children: [
                          Icon(Icons.person,
                              color: TColors.textLight, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            review.userName,
                            style: TextStyle(
                                fontSize: 14, color: TColors.textLight),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  review.feedback,
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.textLight,
                  ),
                ),
                const SizedBox(height: 8),

                // Timestamp
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(review.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: TColors.textLight.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 10),

                // Divider Line
                Divider(
                  color: TColors.textLight.withOpacity(0.5),
                  thickness: 1,
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
