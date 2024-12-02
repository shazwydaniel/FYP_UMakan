import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/vendor_add_adverts.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/cafe_details/edit_cafe.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/menu_item/add_menu_item.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/menu_item/edit_menu_item.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class VendorMenu extends StatefulWidget {
  final CafeDetails cafe; // Accept the entire CafeDetails object

  VendorMenu({Key? key, required this.cafe}) : super(key: key);

  @override
  _VendorMenuState createState() => _VendorMenuState();
}

class _VendorMenuState extends State<VendorMenu> {
  final VendorMenuController controller = Get.put(VendorMenuController());

  @override
  void initState() {
    super.initState();

    controller.fetchItemsForCafe(
        VendorController.instance.getCurrentUserId(), widget.cafe.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(" Your Menu"), // Display the cafe name
        backgroundColor: TColors.olive,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCafeDetailsPage(
                    cafe: widget.cafe, // Pass the selected cafe
                    onSave: () {
                      // Fetch updated data from VendorsHome after editing
                      setState(() {
                        VendorController.instance.fetchCafesForVendor(
                          VendorController.instance.currentUserId,
                        );
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: TColors.olive,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display all the menu items in a ListView
            Expanded(
              child: Obx(() {
                if (controller.items.isEmpty) {
                  return const Center(child: Text('No items available.'));
                } else {
                  return ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditMenuItemPage(
                                menuItem: item,
                                cafeId: widget.cafe.id,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              // Refresh the list after editing
                              controller.fetchItemsForCafe(
                                  VendorController.instance.getCurrentUserId(),
                                  widget.cafe.id);
                            }
                          });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.9,
                          height: 120,
                          child: Card(
                            margin: const EdgeInsets.only(bottom: 16.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.itemName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '\RM${item.itemPrice.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${item.itemCalories} kcal',
                                    style: const TextStyle(
                                      fontSize: 12,
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
                }
              }),
            ),

            // Add Menu Item button
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddMenuItemPage(cafeId: widget.cafe.id),
                    ),
                  );
                  if (result == true) {
                    controller.fetchItemsForCafe(
                        VendorController.instance.getCurrentUserId(),
                        widget.cafe.id);
                  }
                },
                child: const Text('Add Menu Item'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  minimumSize: const Size(double.infinity, 50),
                  foregroundColor: TColors.olive,
                  backgroundColor: TColors.textLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            // Add Advertisement button
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          VendorAdverts(cafeId: widget.cafe.id),
                    ),
                  );
                },
                child: const Text('Add Advertisement'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  minimumSize: const Size(double.infinity, 50),
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
