import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/add_menu_category.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/screen/add_menu_item.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class VendorMenu extends StatefulWidget {
  VendorMenu({Key? key, required this.cafeId}) : super(key: key);

  final String cafeId; // This will hold the ID of the selected cafe

  @override
  _VendorMenuState createState() => _VendorMenuState();
}

class _VendorMenuState extends State<VendorMenu> {
  final VendorMenuController controller = Get.put(VendorMenuController());

  @override
  void initState() {
    super.initState();
    // Fetch the menu items for the specified cafe when the widget is initialized
    controller.fetchItemsForCafe(
        VendorController.instance.getCurrentUserId(), widget.cafeId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        backgroundColor: TColors.olive,
      ),
      backgroundColor: TColors.olive,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display all the menu items in a ListView
            Expanded(
              child: Obx(() {
                // Observe the cafes list and update the UI accordingly
                if (controller.items.isEmpty) {
                  return Center(child: Text('No item available.'));
                } else {
                  return ListView.builder(
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];

                      // Wrap the ListTile with Dismissible to enable swipe to delete
                      return Dismissible(
                        key: Key(item.id), // Unique key for each item
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

                        child: Container(
                          width: MediaQuery.of(context).size.width *
                              0.9, // Set a fixed width
                          height: 120, // Set a fixed height
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
                                    item.itemCalories.toString(),
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
                          AddMenuItemPage(cafeId: widget.cafeId),
                    ),
                  );
                  if (result == true) {
                    controller.fetchItemsForCafe(
                        VendorController.instance.getCurrentUserId(),
                        widget.cafeId);
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

            // Add Category button
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              margin: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMenuCategory(),
                    ),
                  );
                },
                child: const Text('Add Category'),
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
