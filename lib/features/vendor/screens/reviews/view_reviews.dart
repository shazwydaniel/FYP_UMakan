import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

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
      appBar: AppBar(
        title: Text('Reviews for $cafeName'),
        backgroundColor: TColors.mustard,
      ),
      body: Obx(() {
        if (reviewController.isLoadingReviews.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (reviewController.review.isEmpty) {
          return Center(
            child: Text(
              'No reviews available.',
              style: TextStyle(fontSize: 16, color: TColors.textDark),
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
                // Feedback Description
                Text(
                  review.feedback,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: TColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),

                // Rating
                Row(
                  children: [
                    Text(
                      'Rating: ',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: TColors.textDark,
                      ),
                    ),
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${review.rating.toStringAsFixed(1)} / 5',
                      style: TextStyle(fontSize: 14, color: TColors.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Reviewer's Name
                Row(
                  children: [
                    Icon(Icons.person, color: TColors.textDark, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      review.userName,
                      style: TextStyle(fontSize: 14, color: TColors.textDark),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Divider Line
                Divider(
                  color: Colors.black54,
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
