import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/cafe_details/add_cafe.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/vendor_menu.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:overlay_support/overlay_support.dart';

class VendorsHome extends StatelessWidget {
  const VendorsHome({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(VendorController());
    final String vendorId = controller.getCurrentUserId();
    controller.fetchCafesForVendor(vendorId);

    return Scaffold(
      backgroundColor: dark ? TColors.cream : TColors.cream,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          ClipPath(
            clipper: TCustomCurvedEdges(),
            child: Container(
              color: TColors.forest,
              height: 230,
              child: Stack(
                children: [
                  Positioned(
                    top: 90,
                    left: 20,
                    child: Text(
                      'Welcome,',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 140,
                    left: 20,
                    child: Obx(() {
                      return Text(
                        controller.vendor.value.vendorName.isNotEmpty
                            ? "${controller.vendor.value.vendorName}!"
                            : "Loading...",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Your Cafes Section
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
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
                  'Your cafes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.black : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          // Cafes List Section
          Flexible(
            child: Obx(() {
              if (controller.cafes.isEmpty) {
                return Center(
                  child: Text(
                    'No cafes available. Add a cafe to get started!',
                    style: TextStyle(
                      fontSize: 16,
                      color: dark ? TColors.textLight : TColors.textDark,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  itemCount: controller.cafes.length,
                  itemBuilder: (context, index) {
                    final cafe = controller.cafes[index];
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
                            const SizedBox(height: 8),
                            Text(
                              '${cafe.openingTime} - ${cafe.closingTime}',
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
                        isThreeLine: true,
                        onTap: () {
                          final selectedCafe = controller.cafes[index];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  VendorMenu(cafe: selectedCafe.obs),
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

          // Add Cafe Button
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddCafe()),
                  );
                  if (result == true) {
                    controller.fetchCafesForVendor(vendorId);
                  }
                },
                child: const Text('Add Cafe'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.forest,
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.black, width: 2.0),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
