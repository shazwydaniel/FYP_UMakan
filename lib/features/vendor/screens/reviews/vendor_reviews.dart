import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/features/vendor/controller/review_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/reviews/cafe_reviews.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class ReviewsPage extends StatelessWidget {
  final ReviewController reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final vendorController = VendorController.instance;

    final String vendorId = vendorController.getCurrentUserId();
    vendorController.fetchCafesForVendor(vendorId);

    return Scaffold(
      backgroundColor: dark ? TColors.blush : TColors.tangerine,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: TColors.tangerine,
            height: 230,
            child: Stack(
              children: [
                Positioned(
                  top: 90,
                  left: 20,
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
                  left: 20,
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
                  left: 20,
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

          // Cafes List Section
          Flexible(
            child: Obx(() {
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
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: vendorController.cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = vendorController.cafes[index];
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.only(bottom: 16.0),
                      color: TColors.cream,
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
                        isThreeLine: true, // Enables a three-line layout
                        onTap: () {
                          // Navigate to a detailed review page for this cafe
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CafeReviewPage(
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
                );
              }
            }),
          ),
        ],
      ),
    );
  }
}
