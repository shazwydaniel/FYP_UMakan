import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';

class ViewAllReviewsPage extends StatefulWidget {
  final String vendorId;
  final String cafeId;
  final String cafeName;

  ViewAllReviewsPage({
    required this.vendorId,
    required this.cafeId,
    required this.cafeName,
  });

  @override
  _ViewAllReviewsPageState createState() => _ViewAllReviewsPageState();
}

class _ViewAllReviewsPageState extends State<ViewAllReviewsPage> {
  final ReviewController reviewController = Get.put(ReviewController());

  @override
  void initState() {
    super.initState();

    // Fetch reviews outside of the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      reviewController.fetchReviews(widget.vendorId, widget.cafeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        title: Text(
          'Reviews for ${widget.cafeName}',
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

            return Container(
              margin: EdgeInsets.only(bottom: 15),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: TColors.cream,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        review.anonymous == "No"
                            ? review.userName
                            : 'Anonymous User',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${review.rating} ★',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    review.feedback,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Submitted on ${DateFormat('dd-MM-yyyy').format(review.timestamp)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
