import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/vendor_edit_adverts.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorAdsPage extends StatelessWidget {
  VendorAdsPage({super.key});

  final AdvertController advertController = Get.put(AdvertController());
  final DateFormat dateFormat = DateFormat('yyyy-MM-dd'); // Date formatter

  @override
  Widget build(BuildContext context) {
    // Fetch advertisements when the page loads
    advertController.fetchVendorAds();

    return Scaffold(
      backgroundColor: TColors.cobalt,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Section
          Container(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 90),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Available',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: TColors.textLight,
                  ),
                ),
                Text(
                  'Ads',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: TColors.textLight,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Browse your active advertisements and their details.',
                  style: TextStyle(
                    fontSize: 15,
                    color: TColors.textLight,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // Advertisements List Section
          Expanded(
            child: Obx(() {
              if (advertController.allAdvertisements.isEmpty) {
                // Show a message if no ads are available
                return Center(
                  child: Text(
                    'No advertisements available.',
                    style: TextStyle(fontSize: 16, color: TColors.textLight),
                  ),
                );
              }

              // Display the list of advertisements
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                itemCount: advertController.allAdvertisements.length,
                itemBuilder: (context, index) {
                  final ad = advertController.allAdvertisements[index];

                  // Determine the card color based on today's date
                  final DateTime today = DateTime.now();
                  final bool isToday = ad.startDate != null &&
                      ad.endDate != null &&
                      today.isAfter(ad.startDate!) &&
                      today.isBefore(ad.endDate!.add(Duration(days: 1)));

                  return GestureDetector(
                    onTap: () {
                      debugPrint('Ad selected: ${ad.toJson()}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditAdPage(ad: ad),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isToday
                              ? TColors.cream // Default color for active ads
                              : Colors.grey, // Red for inactive ads
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 5,
                              offset: Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ad.detail,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                ad.cafeName,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "Start Date: ${ad.startDate != null ? dateFormat.format(ad.startDate!) : 'N/A'}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "End Date: ${ad.endDate != null ? dateFormat.format(ad.endDate!) : "N/A"}",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
