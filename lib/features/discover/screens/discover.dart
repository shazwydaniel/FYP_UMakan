import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/discover/controller/discover_controller.dart';
import 'package:fyp_umakan/features/discover/screens/discover_cafes.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';

class DiscoverPageScreen extends StatelessWidget {
  const DiscoverPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final DiscoverController discoverController =
        Get.put(DiscoverController(VendorRepository()));

    discoverController.fetchAllCafesFromAllVendors();

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
      body: Column(
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

          // Expanded widget to make GridView take remaining space
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.only(
                  left: 40, right: 40, top: 16, bottom: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: predefinedLocations.length,
              itemBuilder: (context, index) {
                final location = predefinedLocations[index]['name']!;
                final imagePath = predefinedLocations[index]['imagePath']!;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LocationCafesScreen(
                          location: location,
                          discoverController: discoverController,
                          image: imagePath,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: dark ? TColors.cobalt : TColors.amber,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 10.0,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        // Background Image
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.asset(
                              imagePath,
                              fit: BoxFit.cover,
                              color: Colors.black.withOpacity(0.3),
                              colorBlendMode: BlendMode.darken,
                            ),
                          ),
                        ),

                        // Overlay Text
                        Center(
                          child: Text(
                            location,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
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
