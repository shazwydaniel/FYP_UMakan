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
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        title: Text(
          'Reviews for $cafeName',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: TColors.mustard,
        iconTheme: IconThemeData(
          color: Colors.black, // Sets the color of the back icon to white
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
                // Stars and Reviewer Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: List.generate(
                        review.rating.toInt(),
                        (index) =>
                            Icon(Icons.star, color: Colors.black, size: 16),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: TColors.cream, // Tag background color
                            borderRadius:
                                BorderRadius.circular(20), // Rounded corners
                            border: Border.all(
                                color: TColors.textDark, width: 1), // Border
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person,
                                  color: TColors.textDark,
                                  size: 16), // Icon inside tag
                              const SizedBox(width: 4),
                              Text(
                                review.anonymous == 'Yes'
                                    ? 'Anonymous'
                                    : review.userName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: TColors.textDark, // Text color
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
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
                    color: TColors.textDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Timestamp
                Text(
                  DateFormat('dd MMM yyyy, hh:mm a').format(review.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: TColors.textDark.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 10),

                // Divider Line
                Divider(
                  color: TColors.textDark.withOpacity(0.5),
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
