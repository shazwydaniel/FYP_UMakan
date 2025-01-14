import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
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
  final DiscoverController discoverController =
      Get.put(DiscoverController(VendorRepository()));

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
          color: Colors.black, // Sets the color of the back icon to black
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: TColors.cream, // Tag background color
                                borderRadius: BorderRadius.circular(
                                    20), // Rounded corners
                                border: Border.all(
                                    color: TColors.textDark,
                                    width: 1), // Border
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
                Row(
                  children: [
                    Text(
                      DateFormat('dd MMM yyyy, hh:mm a')
                          .format(review.timestamp),
                      style: TextStyle(
                        fontSize: 12,
                        color: TColors.textDark.withOpacity(0.8),
                      ),
                    ),
                    SizedBox(width: 190),
                    GestureDetector(
                      onTap: () {
                        _showDeleteDialog(context, review);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Divider Line
                Divider(
                  color: TColors.textDark.withOpacity(0.5),
                  thickness: 1,
                ),
                const SizedBox(height: 4), // Space between username and icon
              ],
            );
          },
        );
        ;
      }),
    );
  }

  void _showDeleteDialog(BuildContext context, ReviewModel review) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: TColors.cream, // Set background color
        title: Text(
          'Delete Review',
          style: TextStyle(
            color: Colors.black, // Title color
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this review?',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              await discoverController.deleteReview(review);
              reviewController.fetchReviews(vendorId, cafeId);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Review deleted successfully!'),
              ));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.black, width: 2.0)),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
