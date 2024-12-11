import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/vendor_edit_adverts.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class VendorAdsPage extends StatelessWidget {
  VendorAdsPage({super.key});

  final AdvertController advertController = Get.put(AdvertController());
  final DateFormat dateFormat = DateFormat('dd MMM yyyy'); // Date formatter

  @override
  Widget build(BuildContext context) {
    // Fetch advertisements when the page loads
    advertController.fetchVendorAds();

    return Scaffold(
      backgroundColor: TColors.amber,
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
                  'Your',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: TColors.textLight,
                  ),
                ),
                Text(
                  'Advertisements',
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
                return Center(
                  child: Text(
                    'No advertisements available.',
                    style: TextStyle(fontSize: 16, color: TColors.textLight),
                  ),
                );
              }
              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                itemCount: advertController.allAdvertisements.length,
                itemBuilder: (context, index) {
                  final ad = advertController.allAdvertisements[index];
                  final DateTime today = DateTime.now();
                  final bool isToday = ad.startDate != null &&
                      ad.endDate != null &&
                      today.isAfter(ad.startDate!) &&
                      today.isBefore(ad.endDate!.add(Duration(days: 1)));
                  final bool isCompleted = ad.endDate != null &&
                      today.isAfter(ad.endDate!.add(Duration(days: 1)));

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First Row: Details, Edit Icon, and Tag
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              ad.detail,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.clip,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isToday
                                      ? const Color.fromARGB(255, 52, 204, 128)
                                      : isCompleted
                                          ? Colors.red
                                          : Colors.red,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: TColors.textDark,
                                  ),
                                ),
                                child: Text(
                                  isToday ? 'Active' : 'Ended',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: TColors.textDark,
                                  ),
                                ),
                              ),

                              // Edit Icon
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditAdPage(ad: ad),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Second Row: Location
                      Text(
                        ad.cafeName,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),

                      // Third Row: Date Range
                      Text(
                        "From ${ad.startDate != null ? dateFormat.format(ad.startDate!) : 'N/A'} until ${ad.endDate != null ? dateFormat.format(ad.endDate!) : "N/A"}",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),

                      // Divider Line
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                    ],
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
