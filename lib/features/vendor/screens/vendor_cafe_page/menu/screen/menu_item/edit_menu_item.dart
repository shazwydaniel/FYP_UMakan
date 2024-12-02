import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';

import 'package:get/get.dart';

class EditMenuItemPage extends StatelessWidget {
  final CafeItem menuItem;
  final String cafeId;

  EditMenuItemPage({required this.menuItem, required this.cafeId});

  final MenuController controller = Get.put(MenuController());

  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  final TextEditingController itemCaloriesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // Prepopulate the fields with the current menu item data
    itemNameController.text = menuItem.itemName;
    itemPriceController.text = menuItem.itemPrice.toString();
    itemCaloriesController.text = menuItem.itemCalories.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Menu Item'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
                controller: itemNameController,
                decoration: const InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Item Price Field
              TextFormField(
                controller: itemPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (RM)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              // Item Calories Field
              TextFormField(
                controller: itemCaloriesController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),

              // Save Changes Button
              /* ElevatedButton(
                onPressed: () async {
                  // Call the controller to update the menu item
                  await controller.updateMenuItem(
                    cafeId,
                    menuItem.id,
                    itemNameController.text.trim(),
                    double.tryParse(itemPriceController.text) ?? 0.0,
                    int.tryParse(itemCaloriesController.text) ?? 0,
                  );

                  // Close the page and return true to indicate success
                  Navigator.pop(context, true);
                },
                child: const Text('Save Changes'),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
