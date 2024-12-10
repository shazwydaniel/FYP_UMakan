import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class CafeReviewPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;
  final String cafeName;

  CafeReviewPage({
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
        backgroundColor: TColors.amber,
      ),
      body: Obx(() {
        if (reviewController.isLoadingReviews.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (reviewController.reviews.isEmpty) {
          return Center(child: Text('No reviews available.'));
        }

        return ListView.builder(
          itemCount: reviewController.reviews.length,
          itemBuilder: (context, index) {
            final review = reviewController.reviews[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              color: TColors.amber,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.feedback,
                      style: TextStyle(
                        color: TColors.textLight,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'Rating: ',
                          style:
                              TextStyle(color: TColors.textLight, fontSize: 14),
                        ),
                        Icon(Icons.star, color: Colors.amber),
                        Text(
                          '${review.rating.toStringAsFixed(1)} / 5',
                          style:
                              TextStyle(color: TColors.textLight, fontSize: 14),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person, color: Colors.white, size: 12),
                        SizedBox(width: 8),
                        Text(
                          review.userName,
                          style: TextStyle(
                            color: TColors.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
