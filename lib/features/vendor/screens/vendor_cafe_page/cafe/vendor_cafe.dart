import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/cafe_details/add_cafe.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/vendor_menu.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class VendorCafePage extends StatelessWidget {
  final VendorController vendorController = Get.put(VendorController());

  @override
  Widget build(BuildContext context) {
    // Fetch the cafes when the page is initialized
    String vendorId = vendorController.getCurrentUserId();
    vendorController.fetchCafesForVendor(vendorId);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cafes'),
        backgroundColor: TColors.olive,
      ),
      backgroundColor: TColors.olive,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                // Observe the cafes list and update the UI accordingly
                if (vendorController.cafes.isEmpty) {
                  return Center(child: Text('No cafes available.'));
                } else {
                  return ListView.builder(
                    itemCount: vendorController.cafes.length,
                    itemBuilder: (context, index) {
                      final cafe = vendorController.cafes[index];

                      // Wrap the ListTile with Dismissible to enable swipe to delete
                      return Dismissible(
                        key: Key(cafe.id), // Unique key for each item
                        direction: DismissDirection
                            .endToStart, // Allow swipe from right to left
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (direction) async {
                          try {
                            await vendorController.deleteCafe(
                                vendorId, cafe.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${cafe.name} deleted')),
                            );
                          } catch (e) {
                            // If deletion fails, insert the item back
                            vendorController.cafes.insert(index, cafe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Error deleting ${cafe.name}: $e'),
                              ),
                            );
                          }
                        },
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 16.0),
                          child: ListTile(
                            title: Text(
                              cafe.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              cafe.location,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            onTap: () {
                              // Navigate to the detailed cafe page with cafe.id
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorMenu(
                                      cafe: cafe), // Pass cafeId here
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }
              }),
            ),
            // Add space between the ListView and button
            Container(
              margin: EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () async {
                  // Navigate to AddCafe and wait for the result
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddCafe(),
                    ),
                  );

                  // If result is true (a cafe was added), refresh the list
                  if (result == true) {
                    vendorController.fetchCafesForVendor(vendorId);
                  }
                },
                child: Text('Add Cafe'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  minimumSize: Size(double.infinity, 50),
                  foregroundColor: TColors.olive,
                  backgroundColor: TColors.textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
