// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/cafes/screens/all_reviews.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/foodjournal/model/journal_model.dart';
import 'package:fyp_umakan/features/student_management/controllers/user_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/model/feedback/review_model.dart';

import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class CafePage extends StatelessWidget {
  final CafeDetails cafe;
  final String vendorId;

  CafePage({required this.cafe, required this.vendorId, Key? key})
      : super(key: key);

  final FoodJournalController controller = Get.put(FoodJournalController());
  final ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    final DiscoverController cafeController =
        Get.put(DiscoverController(VendorRepository()));

    // Fetch the menu items for this cafe using vendorId and cafeId
    cafeController.fetchMenuItems(vendorId, cafe.id);
    reviewController.fetchReviews(vendorId, cafe.id);

    return Scaffold(
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        backgroundColor: TColors.mustard,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      cafe.name,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showFeedbackDialog(context, vendorId, cafe);
                    },
                    icon: Icon(
                      Icons.feedback,
                      color: Colors.black,
                    ),
                  )
                ],
              ),
            ),
            // Cafe Image Section
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: cafe.image != null && cafe.image.isNotEmpty
                      ? Image.network(
                          cafe.image,
                          width: double.infinity,
                          height: 200, // Adjust the height
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[200],
                            height: 200,
                            child: Icon(
                              Icons.broken_image,
                              size: 80,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          width: double.infinity,
                          height: 200,
                          color: Colors.grey[200],
                          child: Icon(
                            Icons.photo,
                            size: 80,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ),
            SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.amber,
                  ),
                  const SizedBox(width: 10), // Space between the line and text

                  Text(
                    'Reviews',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(width: 165),
                  // Add View All Button
                ],
              ),
            ),

            // Horizontal Scroll of Reviews
            Obx(() {
              if (reviewController.isLoadingReviews.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (reviewController.review.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      'No reviews yet',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 110,
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: reviewController.review.length > 5
                          ? 6 // Show 5 reviews + 1 circular button
                          : reviewController.review.length +
                              1, // Reviews + circular button
                      itemBuilder: (context, index) {
                        if (index == reviewController.review.length ||
                            index == 5) {
                          // Circular Button
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => ViewAllReviewsPage(
                                  vendorId: vendorId,
                                  cafeId: cafe.id,
                                  cafeName: cafe.name,
                                ),
                              ));
                            },
                            child: Container(
                              width: 70,
                              height: 70,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              decoration: BoxDecoration(
                                color: TColors.cream,
                                shape: BoxShape.circle,
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
                                color: Colors.black,
                                size: 30,
                              ),
                            ),
                          );
                        }

                        // Review Card
                        final review = reviewController.review[index];
                        return Container(
                          width: 250,
                          margin: EdgeInsets.symmetric(horizontal: 10),
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
                                  Spacer(),
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
                              Expanded(
                                child: Text(
                                  review.feedback,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Submitted on ${DateFormat('dd-MM-yyyy').format(review.timestamp)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }),

            Padding(
              padding: const EdgeInsets.only(
                  left: 30, right: 30, bottom: 10, top: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.amber,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Menu Items',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),
            Obx(() {
              if (cafeController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (cafeController.menuItems.isEmpty) {
                return Center(child: Text('No menu items available'));
              }
              return Container(
                height: MediaQuery.of(context).size.height,
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: ListView.builder(
                  shrinkWrap: false,
                  itemCount: cafeController.menuItems.length,
                  itemBuilder: (context, index) {
                    final item = cafeController.menuItems[index];
                    return GestureDetector(
                      onTap: item.isAvailable == true
                          ? () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.transparent,
                                    contentPadding: EdgeInsets.zero,
                                    content: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: TColors.cream,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 10,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 20.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.black,
                                                  width: 2, // Border width
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: item.itemImage
                                                            .isNotEmpty &&
                                                        item.itemImage !=
                                                            "default_image_url"
                                                    ? Image.network(
                                                        item.itemImage,
                                                        width: 200,
                                                        height: 200,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Container(
                                                        width: 200,
                                                        height: 200,
                                                        color:
                                                            TColors.textLight,
                                                        child: Icon(
                                                          Icons
                                                              .fastfood, // Replace with any other icon if desired
                                                          size:
                                                              100, // Icon size
                                                          color: Colors
                                                              .black, // Icon color
                                                        ),
                                                      ),
                                              ),
                                            ),
                                          ),

                                          // Details Section
                                          Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  item.itemName,
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Cost: RM${item.itemPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: TColors.textDark,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  'Calories: ${item.itemCalories} cal',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color: TColors.textDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              if (item.isSpicy)
                                                Container(
                                                  width: 24, // Circle size
                                                  height: 24,
                                                  margin: EdgeInsets.only(
                                                      right:
                                                          6), // Spacing between circles
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255,
                                                        255,
                                                        134,
                                                        6), // Circle color for Spicy
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width:
                                                            2), // White border
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'S',
                                                    style: TextStyle(
                                                      color: Colors
                                                          .black, // Text color
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12, // Font size
                                                    ),
                                                  ),
                                                ),
                                              if (item.isVegetarian)
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  margin:
                                                      EdgeInsets.only(right: 6),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255,
                                                        70,
                                                        215,
                                                        75), // Circle color for Vegetarian
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 2),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'V',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              if (item.isLowSugar)
                                                Container(
                                                  width: 24,
                                                  height: 24,
                                                  margin:
                                                      EdgeInsets.only(right: 6),
                                                  decoration: BoxDecoration(
                                                    color: TColors
                                                        .blush, // Circle color for Low Sugar
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: Colors.black,
                                                        width: 2),
                                                  ),
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    'LS',
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          10, // Slightly smaller for "LS"
                                                    ),
                                                  ),
                                                ),
                                            ],
                                          ),
                                          SizedBox(height: 10),

                                          //  Button
                                          Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                      color: TColors.textDark,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () {
                                                    final journalItem =
                                                        JournalItem(
                                                            id: item.id,
                                                            name: item.itemName,
                                                            price:
                                                                item.itemPrice,
                                                            calories: item
                                                                .itemCalories,
                                                            cafe: cafe.name,
                                                            cafeId: cafe.id,
                                                            cafeLocation:
                                                                cafe.location,
                                                            imagePath:
                                                                item.itemImage,
                                                            vendorId: vendorId,
                                                            isLowSugar:
                                                                item.isLowSugar,
                                                            isSpicy:
                                                                item.isSpicy,
                                                            isVegetarian: item
                                                                .isVegetarian);

                                                    String userId =
                                                        FoodJournalController
                                                            .instance
                                                            .getCurrentUserId();

                                                    // Add the meal to the Food Journal
                                                    controller.addFoodToJournal(
                                                        userId, journalItem);

                                                    // Prepare expense data for the Money Journal
                                                    final expenseData = {
                                                      'itemName': item.itemName,
                                                      'price': item.itemPrice,
                                                      'date': DateTime.now()
                                                          .toIso8601String(),
                                                      'type': 'Food',
                                                    };

                                                    // Access UserController and add the expense
                                                    final userController =
                                                        UserController.instance;
                                                    userController.addExpense(
                                                        userId,
                                                        'Food',
                                                        expenseData);

                                                    Navigator.of(context)
                                                        .pop(); // Close the dialog
                                                  },
                                                  child: Text(
                                                    'Add',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        TColors.mustard,
                                                    foregroundColor:
                                                        Colors.black,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    side: BorderSide(
                                                      color: Colors
                                                          .black, // Border color
                                                      width: 2, // Border width
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          : null,
                      child: Card(
                        elevation: item.isAvailable == true ? 10 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        color: TColors.amber,
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Text Details Section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.itemName,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: TColors.textLight,
                                      ),
                                    ),
                                    Text(
                                      'Calories: ${item.itemCalories} cal',
                                      style:
                                          TextStyle(color: TColors.textLight),
                                    ),
                                    Text(
                                      'Cost: RM${item.itemPrice.toStringAsFixed(2)}',
                                      style:
                                          TextStyle(color: TColors.textLight),
                                    ),
                                    SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 9, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: item.isAvailable
                                            ? const Color.fromARGB(
                                                255, 52, 204, 128)
                                            : TColors.textGrey,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: TColors.textLight,
                                        ),
                                      ),
                                      child: Text(
                                        item.isAvailable
                                            ? 'Available'
                                            : 'Unavailable',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        if (item.isSpicy)
                                          Container(
                                            width: 24, // Circle size
                                            height: 24,
                                            margin: EdgeInsets.only(
                                                right:
                                                    6), // Spacing between circles
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255,
                                                  255,
                                                  134,
                                                  6), // Circle color for Spicy
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2), // White border
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'S',
                                              style: TextStyle(
                                                color:
                                                    Colors.black, // Text color
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12, // Font size
                                              ),
                                            ),
                                          ),
                                        if (item.isVegetarian)
                                          Container(
                                            width: 24,
                                            height: 24,
                                            margin: EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255,
                                                  70,
                                                  215,
                                                  75), // Circle color for Vegetarian
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'V',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        if (item.isLowSugar)
                                          Container(
                                            width: 24,
                                            height: 24,
                                            margin: EdgeInsets.only(right: 6),
                                            decoration: BoxDecoration(
                                              color: TColors
                                                  .blush, // Circle color for Low Sugar
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 2),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'LS',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize:
                                                    10, // Slightly smaller for "LS"
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              // Image Section on the Right
                              Container(
                                width: 90, // Adjust width
                                height: 90, // Adjust height
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                  color: Colors.grey[
                                      300], // Background color for the icon
                                ),
                                child: item.itemImage.isNotEmpty &&
                                        item.itemImage != "default_image_url"
                                    ? ClipOval(
                                        child: Image.network(
                                          item.itemImage,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Center(
                                        child: Icon(
                                          Icons.fastfood,
                                          size: 40,
                                          color: Colors.black,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

void showFeedbackDialog(
    BuildContext context, String vendorId, CafeDetails cafe) {
  final _feedbackController = TextEditingController();
  double _rating = 0.0;
  String _anonymous = 'No'; // Default value for anonymity
  final userController = UserController.instance;
  final ReviewController reviewController = Get.put(ReviewController());
  final vendorRepo = VendorRepository.instance;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.transparent,
        contentPadding: EdgeInsets.zero,
        content: SizedBox(
          height: 430,
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
                    'Give Review',
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
                        labelText: 'What do you think?',
                        labelStyle: TextStyle(color: TColors.textDark),
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .black), // Underline color when not focused
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color:
                                  Colors.black), // Underline color when focused
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
                        value: _anonymous, // Current selected value
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
                          _anonymous =
                              newValue ?? 'No'; // Update value on selection
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: TColors.textDark,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // Create feedback model

                          reviewController.addReview(
                            vendorId: vendorId,
                            cafeId: cafe.id,
                            userId: userController.currentUserId,
                            userName: userController.user.value.username,
                            feedback: _feedbackController.text.trim(),
                            rating: _rating,
                            timestamp: DateTime.now(),
                            cafeName: cafe.name,
                            anonymous: _anonymous,
                          );

                          // Re-fetch the reviews after submission
                          await reviewController.fetchReviews(
                              vendorId, cafe.id);

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Feedback submitted successfully!'),
                          ));
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Submit',
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
                            color: Colors.black, // Border color
                            width: 2, // Border width
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
