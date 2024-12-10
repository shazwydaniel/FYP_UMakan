// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
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

class CafePage extends StatelessWidget {
  final CafeDetails cafe;
  final String vendorId;

  CafePage({required this.cafe, required this.vendorId, Key? key})
      : super(key: key);

  final FoodJournalController controller = Get.put(FoodJournalController());

  @override
  Widget build(BuildContext context) {
    final DiscoverController cafeController =
        Get.put(DiscoverController(VendorRepository()));

    // Fetch the menu items for this cafe using vendorId and cafeId
    cafeController.fetchMenuItems(vendorId, cafe.id);

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
                      overflow: TextOverflow
                          .ellipsis, // Ensure long names don't overflow
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
                    return Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      color: TColors.amber,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            item.itemName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: TColors.textLight),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Calories: ${item.itemCalories} cal',
                                  style: TextStyle(color: TColors.textLight)),
                              Text(
                                  'Cost: RM${item.itemPrice.toStringAsFixed(2)}',
                                  style: TextStyle(color: TColors.textLight)),
                            ],
                          ),
                          trailing: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 2,
                              ),
                              image: DecorationImage(
                                image: item.itemImage.isNotEmpty
                                    ? NetworkImage(
                                        item.itemImage) // Load image from a URL
                                    : AssetImage(
                                            'assets/images/default_food.png')
                                        as ImageProvider,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          onTap: () {
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
                                      color: TColors.amber,
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
                                          padding:
                                              const EdgeInsets.only(top: 20.0),
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
                                                  BorderRadius.circular(
                                                      10), // Inner radius
                                              child: item.itemImage.isNotEmpty
                                                  ? Image.network(
                                                      item.itemImage,
                                                      width: 200,
                                                      height: 200,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container(
                                                      width: 200,
                                                      height: 200,
                                                      color: Colors.grey[200],
                                                      child: Icon(
                                                        Icons.fastfood,
                                                        size: 100,
                                                        color: Colors.black54,
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
                                                  color: TColors.textLight,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                'Calories: ${item.itemCalories} cal',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: TColors.textLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Add Button
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(); // Close the dialog
                                                },
                                                child: Text(
                                                  'Cancel',
                                                  style: TextStyle(
                                                    color: TColors.textLight,
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
                                                          price: item.itemPrice,
                                                          calories:
                                                              item.itemCalories,
                                                          cafe: cafe.name,
                                                          imagePath:
                                                              item.itemImage,
                                                          vendorId: vendorId);

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
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      TColors.mustard,
                                                  foregroundColor: Colors.black,
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 24,
                                                    vertical: 12,
                                                  ),
                                                  shape: RoundedRectangleBorder(
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
                          },
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
        content: Container(
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
              SizedBox(height: 40),

              // Feedback Input Field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                          color:
                              Colors.black), // Underline color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.black), // Underline color when focused
                    ),
                  ),
                  maxLines: 5,
                ),
              ),
              SizedBox(height: 40),

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
                        final feedback = ReviewModel(
                          userId: userController
                              .currentUserId, // Replace with logged-in user's ID
                          userName: userController.user.value
                              .username, // Replace with logged-in user's name
                          feedback: _feedbackController.text.trim(),
                          rating: _rating,
                          timestamp: DateTime.now(),
                          cafeId: cafe.id,
                          cafeName: cafe.name,
                        );

                        vendorRepo.submitFeedback(
                          vendorId: vendorId,
                          cafeId: cafe.id,
                          feedback: feedback,
                        );

                        print(vendorId);

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
      );
    },
  );
}
