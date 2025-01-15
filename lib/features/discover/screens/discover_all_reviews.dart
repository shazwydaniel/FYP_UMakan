import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class AllUserReviews extends StatefulWidget {
  final String userId;

  AllUserReviews({required this.userId});

  @override
  _AllUserReviewsState createState() => _AllUserReviewsState();
}

class _AllUserReviewsState extends State<AllUserReviews> {
  late DiscoverController _discoverController;
  late bool dark;
  final userController = UserController.instance;

  @override
  void initState() {
    super.initState();
    _discoverController = Get.put(DiscoverController(VendorRepository()));
    _discoverController.fetchAllCafesFromAllVendors();
    _discoverController.fetchUserReviews(userController.currentUserId);

    // Fetch all reviews when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _discoverController.fetchUserReviews(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        title: Text(
          'All Reviews',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: TColors.mustard,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Obx(() {
        if (_discoverController.isLoadingReviews.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (_discoverController.userReviews.isEmpty) {
          return Center(
            child: Text(
              'No reviews available.',
              style: TextStyle(fontSize: 16, color: TColors.textDark),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: _discoverController.userReviews.length,
          itemBuilder: (context, index) {
            final review = _discoverController.userReviews[index];

            return GestureDetector(
              onTap: () {
                // Open the update/delete dialog on tap
                _showUpdateDialog(context, review, _discoverController);
              },
              child: Container(
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
                          review.cafeName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
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
                    SizedBox(height: 15),
                    Text(
                      review.anonymous == "No"
                          ? 'Made by ${review.userName}'
                          : 'Anonymous User',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Submitted on ${DateFormat('dd-MM-yyyy').format(review.timestamp)}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
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

  // Dialog for Updating or Deleting a Review
  void _showUpdateDialog(
      BuildContext context, review, DiscoverController controller) {
    final _feedbackController = TextEditingController(text: review.feedback);
    double _rating = review.rating;
    String _anonymous = review.anonymous;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 420,
            width: 300,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: TColors.cream,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Update Review',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      height: 100,
                      child: TextFormField(
                        controller: _feedbackController,
                        decoration: InputDecoration(
                          labelText: 'Update your feedback',
                          labelStyle: TextStyle(color: TColors.textDark),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 20, horizontal: 12),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        maxLines: 5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anonymity',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          value: _anonymous,
                          items: [
                            DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                            DropdownMenuItem(value: 'No', child: Text('No')),
                          ],
                          onChanged: (String? newValue) {
                            _anonymous = newValue ?? 'No';
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        // Delete Button
                        ElevatedButton(
                          onPressed: () async {
                            await controller.deleteReview(review);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Review deleted successfully!'),
                            ));
                            Navigator.of(context).pop();
                            _discoverController
                                .fetchUserReviews(userController.currentUserId);
                          },
                          child: Text(
                            'Delete',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        SizedBox(width: 60),
                        // Update Button
                        ElevatedButton(
                          onPressed: () async {
                            await controller.updateReview(
                              review,
                              _feedbackController.text.trim(),
                              _rating,
                              _anonymous,
                            );
                            _discoverController
                                .fetchUserReviews(userController.currentUserId);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Review updated successfully!'),
                            ));
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Update',
                            style: TextStyle(fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColors.mustard,
                            foregroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
