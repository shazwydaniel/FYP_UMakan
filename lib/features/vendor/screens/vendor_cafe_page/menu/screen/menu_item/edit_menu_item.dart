import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';

import 'package:get/get.dart';

class EditMenuItemPage extends StatelessWidget {
  final CafeItem menuItem;
  final String cafeId;

  EditMenuItemPage({required this.menuItem, required this.cafeId}) {
    final controller = Get.put(VendorMenuController());
    controller.cafeItem.value = menuItem;
    controller.itemNameUpdate.text = menuItem.itemName;
    controller.itemCostUpdate.text = menuItem.itemPrice.toString();
    controller.itemCaloriesUpdate.text = menuItem.itemCalories.toString();
  }

  VendorMenuController controller = Get.put(VendorMenuController());
  VendorController vendorController = VendorController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu Item'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.menuUpdateKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Menu Item',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Item Name Field
              TextFormField(
                controller: controller.itemNameUpdate,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Item Price Field
              TextFormField(
                controller: controller.itemCostUpdate,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Item Calories Field
              TextFormField(
                controller: controller.itemCaloriesUpdate,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.menuUpdateKey.currentState?.validate() ??
                        false) {
                      await controller.updateCafeDetails(
                        vendorController.getCurrentUserId(),
                        cafeId,
                        menuItem.id,
                      );

                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: const Text('Update Menu Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
