// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';

class AdminItemsPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;

  AdminItemsPage({required this.vendorId, required this.cafeId});

  final VendorMenuController _menuController = Get.put(VendorMenuController());

  @override
  Widget build(BuildContext context) {
    _menuController.fetchItemsForCafe(vendorId, cafeId);

    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Title
            Text(
              'Items',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 16),

            // Item List with Frosted Glass Effect
            Expanded(
              child: Obx(() {
                if (_menuController.items.isEmpty) {
                  return const Center(child: Text('No items available.'));
                }

                return ListView.builder(
                  itemCount: _menuController.items.length,
                  itemBuilder: (context, index) {
                    final item = _menuController.items[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.itemName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        'Price: RM${item.itemPrice.toString()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                      Text(
                                        'Calories: ${item.itemCalories.toString()}kcal',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  color: TColors.cream, // Popup background
                                  onSelected: (value) {
                                    if (value == 'Edit') {
                                      _showUpdateDialog(context, item, vendorId, cafeId);
                                    } else if (value == 'Delete') {
                                      _confirmDeleteItem(context, vendorId, cafeId, item.id);
                                    }
                                  },
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      value: 'Edit',
                                      child: Row(
                                        children: [
                                          Text('Edit'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Delete',
                                      child: Row(
                                        children: [
                                          Text('Delete'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: TColors.stark_blue,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: IconButton(
          icon: const Icon(Icons.add, size: 40, color: Colors.white),
          onPressed: () => _showAddItemDialog(context, vendorId, cafeId),
          tooltip: 'Add Menu Item',
        ),
      ),
    );
  }

  // Update Item Dialog
  void _showUpdateDialog(
      BuildContext context, CafeItem item, String vendorId, String cafeId) {
    _menuController.itemNameUpdate.text = item.itemName;
    _menuController.itemCostUpdate.text = item.itemPrice.toString();
    _menuController.itemCaloriesUpdate.text = item.itemCalories.toString();

    // Initialize checkboxes with the existing item data
    _menuController.isLowSugarUpdate.value = item.isLowSugar ?? false;
    _menuController.isSpicyUpdate.value = item.isSpicy ?? false;
    _menuController.isVegetarianUpdate.value = item.isVegetarian ?? false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: const Text('Update Item'),
          content: Form(
            key: _menuController.menuUpdateKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemNameUpdate,
                  decoration: const InputDecoration(labelText: 'Item\'s Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemCostUpdate,
                  decoration: const InputDecoration(labelText: 'Item\'s Cost (RM)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cost is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemCaloriesUpdate,
                  decoration: const InputDecoration(labelText: 'Item\'s Calories (kcal)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Calories are required'
                      : null,
                ),
                const SizedBox(height: 15),
                Obx(() => CheckboxListTile(
                      title: const Text('Low Sugar'),
                      value: _menuController.isLowSugarUpdate.value,
                      onChanged: (value) => _menuController
                          .isLowSugarUpdate.value = value ?? false,
                    )),
                Obx(() => CheckboxListTile(
                      title: const Text('Spicy'),
                      value: _menuController.isSpicyUpdate.value,
                      onChanged: (value) =>
                          _menuController.isSpicyUpdate.value = value ?? false,
                    )),
                Obx(() => CheckboxListTile(
                      title: const Text('Vegetarian'),
                      value: _menuController.isVegetarianUpdate.value,
                      onChanged: (value) => _menuController
                          .isVegetarianUpdate.value = value ?? false,
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: TColors.amber)),
            ),
            TextButton(
              onPressed: () async {
                await _menuController.updateCafeDetails(vendorId, cafeId, item.id);
                
                Get.snackbar(
                  "Success",
                  "Item's Details Are Updated Successfully!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );

                Navigator.pop(context);
              },
              child: Text('Save', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Delete Item Dialog
  void _confirmDeleteItem(
    BuildContext context, String vendorId, String cafeId, String itemId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Delete Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () async {
                // Call the delete method from the controller
                await _menuController.deleteMenuItem(vendorId, cafeId, itemId);

                Get.snackbar(
                  "Success",
                  "Item Successfully Deleted!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );

                Navigator.pop(context);
              },
              child: Text(
                'Delete',
                style: TextStyle(color: TColors.vermillion),
              ),
            ),
          ],
        );
      },
    );
  }

  // Add Item Dialog
  void _showAddItemDialog(
      BuildContext context, String vendorId, String cafeId) {
    _menuController.itemName.clear();
    _menuController.itemCost.clear();
    _menuController.itemCalories.clear();
    _menuController.resetPreferences();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: const Text('Add Menu Item'),
          content: Form(
            key: _menuController.menuFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _menuController.itemName,
                  decoration: const InputDecoration(labelText: 'Item\'s Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Name is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemCost,
                  decoration: const InputDecoration(labelText: 'Item\'s Cost (RM)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cost is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemCalories,
                  decoration: const InputDecoration(labelText: 'Item\'s Calories (kcal)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Calories are required'
                      : null,
                ),
                const SizedBox(height: 15),
                Obx(() => CheckboxListTile(
                      title: const Text('Low Sugar'),
                      value: _menuController.isLowSugar.value,
                      onChanged: (value) =>
                          _menuController.isLowSugar.value = value ?? false,
                    )),
                Obx(() => CheckboxListTile(
                      title: const Text('Spicy'),
                      value: _menuController.isSpicy.value,
                      onChanged: (value) =>
                          _menuController.isSpicy.value = value ?? false,
                    )),
                Obx(() => CheckboxListTile(
                      title: const Text('Vegetarian'),
                      value: _menuController.isVegetarian.value,
                      onChanged: (value) =>
                          _menuController.isVegetarian.value = value ?? false,
                    )),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: TColors.amber)),
            ),
            TextButton(
              onPressed: () async {
                if (_menuController.menuFormKey.currentState?.validate() ??
                    false) {
                  await _menuController.addItem(
                      vendorId, cafeId, 'default_image_url');
                  Navigator.pop(context);
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }
}
