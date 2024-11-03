import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:get/get.dart';

class AddMenuItemPage extends StatelessWidget {
  final VendorMenuController controller = Get.put(VendorMenuController());
  String vendorId = VendorController.instance.getCurrentUserId();
  final String cafeId;

  // Update the constructor
  AddMenuItemPage({Key? key, required this.cafeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Menu Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.menuFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Field for Item Name
              TextFormField(
                controller: controller.itemName,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Text Field for Item Cost
              TextFormField(
                controller: controller.itemCost,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Cost',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item cost';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Text Field for Item Calories
              TextFormField(
                controller: controller.itemCalories,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Calories',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item calories';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),

              // Add Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.menuFormKey.currentState?.validate() ??
                        false) {
                      // Call the addItem method to add the item to the database
                      controller.addItem(
                          vendorId, cafeId); // Pass actual IDs here

                      // Close the page after adding the item
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
