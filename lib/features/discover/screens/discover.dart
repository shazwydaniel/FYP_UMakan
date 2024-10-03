import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/cafes/screens/cafe.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';

import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class DiscoverPageScreen extends StatelessWidget {
  const DiscoverPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final JournalController journalController = Get.put(JournalController());
    final DiscoverController discoverController =
        Get.put(DiscoverController(VendorRepository()));

    discoverController
        .fetchAllCafesFromAllVendors(); // Fetch cafes from all vendors

    return Scaffold(
      backgroundColor: TColors.mustard,
      body: Stack(
        children: [
          // Title Section
          Container(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 100),
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
          // Cafes List Section
          Obx(() {
            if (discoverController.cafe.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 180), // Space for title
              itemCount: discoverController.cafe.length,
              itemBuilder: (context, index) {
                final cafe = discoverController.cafe[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(cafe.name),
                    subtitle: Text(cafe.location), // Adjust as needed
                    onTap: () {
                      // Navigate to CafePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CafePage(
                            cafe: cafe,
                            vendorId: cafe.vendorId,
                          ), // Adjust this according to CafePage
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }),
        ],
      ),
    );
  }
}
