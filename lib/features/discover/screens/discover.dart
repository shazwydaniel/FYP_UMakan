import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_umakan/features/cafes/screens/all_reviews.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/discover/screens/discover_all_reviews.dart';
import 'package:fyp_umakan/features/discover/screens/discover_cafes.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

import 'package:carousel_slider/carousel_slider.dart';

class DiscoverPageScreen extends StatefulWidget {
  const DiscoverPageScreen({super.key});

  @override
  State<DiscoverPageScreen> createState() => _DiscoverPageScreenState();
}

class _DiscoverPageScreenState extends State<DiscoverPageScreen> {
  late DiscoverController _discoverController;
  late bool dark;
  final userController = UserController.instance;

  @override
  void initState() {
    super.initState();
    _discoverController = Get.put(DiscoverController(VendorRepository()));
    _discoverController.fetchAllCafesFromAllVendors();
    _discoverController.fetchUserReviews(userController.currentUserId);
  }

  Future<void> _updateReview(
      ReviewModel review, String feedback, double rating) async {
    try {
      final updatedReview = {
        'feedback': feedback,
        'rating': rating,
        'timestamp': DateTime.now(),
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
      _discoverController.fetchUserReviews(review.userId);

      Get.snackbar('Success', 'Review updated successfully');
    } catch (e) {
      print('Error updating review: $e');
      Get.snackbar('Error', 'Failed to update review');
    }
  }

  Future<void> _deleteReview(ReviewModel review) async {
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
      _discoverController.fetchUserReviews(review.userId);

      Get.snackbar('Success', 'Review deleted successfully');
    } catch (e) {
      print('Error deleting review: $e');
      Get.snackbar('Error', 'Failed to delete review');
    }
  }

  @override
  Widget build(BuildContext context) {
    dark = THelperFunctions.isDarkMode(context);

    // Predefined list of locations and corresponding images
    final List<Map<String, String>> predefinedLocations = [
      {'name': 'KK1', 'imagePath': TImages.KK1_Logo},
      {'name': 'KK2', 'imagePath': TImages.KK2_Logo},
      {'name': 'KK3', 'imagePath': TImages.KK3_Logo},
      {'name': 'KK4', 'imagePath': TImages.KK4_Logo},
      {'name': 'KK5', 'imagePath': TImages.KK5_Logo},
      {'name': 'KK6', 'imagePath': TImages.KK6_Logo},
      {'name': 'KK7', 'imagePath': TImages.KK7_Logo},
      {'name': 'KK8', 'imagePath': TImages.KK8_Logo},
      {'name': 'KK9', 'imagePath': TImages.KK9_Logo},
      {'name': 'KK10', 'imagePath': TImages.KK10_Logo},
      {'name': 'KK11', 'imagePath': TImages.KK11_Logo},
      {'name': 'KK12', 'imagePath': TImages.KK12_Logo},
      {'name': 'Others', 'imagePath': TImages.Others_Logo},
    ];

    return Scaffold(
      backgroundColor: TColors.mustard,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Title Section
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 90),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Discover Cafes',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Browse for your meals and add them to your journal',
                    style: TextStyle(
                      fontSize: 15,
                      color: dark ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            CarouselSlider(
              options: CarouselOptions(
                height: 250,
                enableInfiniteScroll: true,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 2),
                autoPlayAnimationDuration: Duration(milliseconds: 900),
              ),
              items: predefinedLocations.map((location) {
                return Builder(
                  builder: (BuildContext context) {
                    final String locationName = location['name']!;
                    final String imagePath = location['imagePath']!;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationCafesScreen(
                              location: locationName,
                              image: imagePath,
                              discoverController: _discoverController,
                            ),
                          ),
                        ).then((_) {
                          // Refresh data when returning to DiscoverPageScreen
                          _discoverController
                              .fetchUserReviews(userController.currentUserId);
                          _discoverController.fetchAllCafesFromAllVendors();
                          print('Refresh list going back to Discover Page');
                        });
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 3),
                          borderRadius: BorderRadius.circular(16.0),
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.1),
                              BlendMode.darken,
                            ),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            // Border Text
                            Text(
                              locationName,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 4.0 // Adjust the stroke width
                                  ..color = Colors.black, // Border color
                              ),
                            ),
                            // Inner Text
                            Text(
                              locationName,
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Colors.white, // Fill color
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ),

            SizedBox(height: 30),

            Padding(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 10, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.textDark,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Your Reviews',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            // User Reviews Section

            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 255, 231, 114),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      if (_discoverController.isLoadingReviews.value) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (_discoverController.userReviews.isEmpty) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'No reviews yet',
                              style: TextStyle(
                                fontSize: 16,
                                color: dark ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        );
                      }

                      // Display the first 5 reviews
                      final displayedReviews =
                          _discoverController.userReviews.take(5).toList();

                      return Column(
                        children: [
                          // List of the first 5 reviews
                          Column(
                            children: displayedReviews.map((review) {
                              return Card(
                                color: TColors.cream,
                                margin:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: TColors.cream,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 4.0,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      review.cafeName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start, // Align text to the start
                                      children: [
                                        Text(
                                          review.feedback,
                                          style: TextStyle(
                                              height:
                                                  1.5), // Optional line-height for better readability
                                        ),
                                        SizedBox(
                                            height:
                                                8), // Add space between feedback and rating
                                        Text(
                                          'Rating: ${review.rating} ★',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      _showUpdateDialog(
                                          context, review, _discoverController);
                                    },
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          SizedBox(height: 20),

                          // Button to view all reviews
                          Center(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AllUserReviews(
                                      userId: userController.currentUserId,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: TColors.textDark,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 5,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(
      BuildContext context, ReviewModel review, DiscoverController controller) {
    final _feedbackController = TextEditingController(text: review.feedback);
    double _rating = review.rating;
    String _anonymous = review.anonymous; // Set initial value from the review

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            height: 420, // Increased height for the delete button
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
                  // Title
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

                  // Star Rating
                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      _rating = rating;
                    },
                  ),
                  SizedBox(height: 20),

                  // Feedback Input Field
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

                  // Dropdown for anonymity
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
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(),
                          ),
                          value: _anonymous,
                          items: [
                            DropdownMenuItem(
                              value: 'Yes',
                              child: Text('Yes'),
                            ),
                            DropdownMenuItem(
                              value: 'No',
                              child: Text('No'),
                            ),
                          ],
                          onChanged: (String? newValue) {
                            _anonymous = newValue ?? 'No';
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 20),

                  // Buttons
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        // Delete Button
                        ElevatedButton(
                          onPressed: () async {
                            // Call the delete method
                            await controller.deleteReview(review);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Review deleted successfully!'),
                            ));
                            Navigator.of(context).pop();
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
                                  color: Colors
                                      .black, // Border color of the button
                                  width: 2.0)),
                        ),
                        SizedBox(width: 60),
                        // Update Button
                        ElevatedButton(
                          onPressed: () async {
                            // Call the update method
                            await controller.updateReview(
                              review,
                              _feedbackController.text.trim(),
                              _rating,
                              _anonymous,
                            );

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
