import 'package:flutter/material.dart';

import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/vendor_add_adverts.dart';
import 'package:get/get.dart';

class VendorAdsPage extends StatelessWidget {
  VendorAdsPage({super.key});

  final AdvertController advertController = Get.put(AdvertController());

  @override
  Widget build(BuildContext context) {
    // Fetch advertisements when the page loads
    advertController.fetchVendorAds();

    return Scaffold(
      appBar: AppBar(title: Text('Available Ads')),
      body: Obx(
        () {
          if (advertController.allAdvertisements.isEmpty) {
            // Show a message if no ads are available
            return Center(
              child: Text(
                'No advertisements available.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Display the list of advertisements
          return ListView.builder(
            itemCount: advertController.allAdvertisements.length,
            itemBuilder: (context, index) {
              final ad = advertController.allAdvertisements[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize:
                        Size(double.infinity, 60), // Full-width buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VendorAdverts(cafeId: ),
                      ),
                    );*/
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ad.cafeName,
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ad.detail,
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "Start Date: ${ad.startDate}",
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        "End Date: ${ad.endDate}",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
