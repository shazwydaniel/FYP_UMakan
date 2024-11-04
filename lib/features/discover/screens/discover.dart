import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/homepage/journal_controller.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
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

    final DiscoverController discoverController =
        Get.put(DiscoverController(VendorRepository()));

    discoverController
        .fetchAllCafesFromAllVendors(); // Fetch cafes from all vendors

    // Predefined list of locations
    final List<String> predefinedLocations = [
      'KK1',
      'KK2',
      'KK3',
      'KK4',
      'KK5',
      'KK6',
      'KK7',
      'KK8',
      'KK9',
      'KK10',
      'KK11',
      'KK12',
      'Others'
    ];

    return Scaffold(
      backgroundColor: TColors.mustard,
      body: Column(
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

          SizedBox(height: 20),

          // Expanded widget to make GridView take remaining space
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 16, bottom: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Display 2 rectangles per row
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 2, // Rectangle shape
              ),
              itemCount: predefinedLocations.length,
              itemBuilder: (context, index) {
                final location = predefinedLocations[index];

                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationCafesScreen(
                          location: location,
                          discoverController: discoverController,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: dark ? TColors.cobalt : TColors.amber,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Center(
                      child: Text(
                        location,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Screen to display cafes for a selected location
class LocationCafesScreen extends StatelessWidget {
  final String location;
  final DiscoverController discoverController;

  const LocationCafesScreen({
    Key? key,
    required this.location,
    required this.discoverController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Filter cafes by location
    final cafesInLocation = discoverController.cafe
        .where((cafe) => cafe.location == location)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Available cafes in $location '),
        backgroundColor: TColors.mustard,
      ),
      body: cafesInLocation.isEmpty
          ? Center(child: Text('No cafes available in $location'))
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: cafesInLocation.length,
              itemBuilder: (context, index) {
                final cafe = cafesInLocation[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(cafe.name),
                    subtitle: Text(cafe.location),
                    onTap: () {
                      // Navigate to CafePage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CafePage(
                            cafe: cafe,
                            vendorId: cafe.vendorId,
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
}
