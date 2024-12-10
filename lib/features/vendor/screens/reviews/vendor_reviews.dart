import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/foodjournal/controller/food_journal_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/reviews/view_reviews.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class ReviewsPage extends StatelessWidget {
  final ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final vendorController = VendorController.instance;
    final foodJournalController = FoodJournalController.instance;

    final String vendorId = vendorController.getCurrentUserId();
    vendorController.fetchCafesForVendor(vendorId);

    return Scaffold(
      backgroundColor: dark
          ? const Color.fromARGB(255, 107, 91, 2)
          : const Color.fromARGB(255, 107, 91, 2),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: const Color.fromARGB(255, 107, 91, 2),
              height: 230,
              child: Stack(
                children: [
                  Positioned(
                    top: 90,
                    left: 30,
                    child: Text(
                      'Reviews',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 150,
                    left: 30,
                    child: Text(
                      'Browse through reviews made by students ',
                      style: TextStyle(
                        fontSize: 15,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 175,
                    left: 30,
                    child: Text(
                      'about your cafes',
                      style: TextStyle(
                        fontSize: 15,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.mustard,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Summary',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Horizontal Scroll Section
            SizedBox(
              height: 150,
              child: FutureBuilder(
                future: Future.wait([
                  foodJournalController.getMostLoggedCafe(),
                  reviewController.getHighestRatedCafe(),
                  reviewController.getLowestRatedCafe(),
                ]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final List<String> cafes = snapshot.data as List<String>;

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 30),
                    children: [
                      _buildCard('Most Logged Cafe', cafes[0], TColors.cream),
                      _buildCard('Highest Rated Cafe', cafes[1], TColors.cream),
                      _buildCard('Lowest Rated Cafe', cafes[2], TColors.cream),
                    ],
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.only(left: 30, right: 20, bottom: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.mustard,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Cafes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Cafes List Section
            Obx(() {
              if (vendorController.cafes.isEmpty) {
                return Center(
                  child: Text(
                    'No cafes available to review.',
                    style: TextStyle(
                      fontSize: 16,
                      color: dark ? TColors.textLight : TColors.textDark,
                    ),
                  ),
                );
              } else {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    itemCount: vendorController.cafes.length,
                    itemBuilder: (context, index) {
                      final cafe = vendorController.cafes[index];
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.only(bottom: 16.0),
                        color: TColors.mustard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            cafe.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: TColors.textDark,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cafe.location,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: TColors.textDark,
                                ),
                              ),
                            ],
                          ),
                          trailing: Icon(
                            Icons.chevron_right,
                            color: TColors.textDark,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewReviewPage(
                                  vendorId: vendorId,
                                  cafeId: cafe.id,
                                  cafeName: cafe.name,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, String cafeName, Color color) {
    return Container(
      width: 200,
      margin: const EdgeInsets.all(8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18, color: Colors.black),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            cafeName.isNotEmpty ? cafeName : 'N/A',
            style: TextStyle(fontSize: 14, color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
