// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:iconsax/iconsax.dart';

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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Item Details
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                          _showUpdateDialog(
                                              context, item, vendorId, cafeId);
                                        } else if (value == 'Delete') {
                                          _confirmDeleteItem(context, vendorId,
                                              cafeId, item.id);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'Edit',
                                          child: Row(
                                            children: [
                                              Icon(Icons.edit,
                                                  color: TColors.teal),
                                              SizedBox(width: 8),
                                              Text('Edit'),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem(
                                          value: 'Delete',
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete,
                                                  color: Colors.red),
                                              SizedBox(width: 8),
                                              Text('Delete'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Preferences Section
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    if (item.isSpicy)
                                      _buildPreferenceCircle(
                                          'S',
                                          const Color.fromARGB(
                                              255, 255, 134, 6)),
                                    if (item.isVegetarian)
                                      _buildPreferenceCircle(
                                          'V',
                                          const Color.fromARGB(
                                              255, 70, 215, 75)),
                                    if (item.isLowSugar)
                                      _buildPreferenceCircle(
                                          'LS', TColors.blush),
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
        notchMargin: 0.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Iconsax.add_circle,
                    color: Colors.white, size: 40),
                onPressed: () => _showAddItemDialog(context, vendorId, cafeId),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteItem(BuildContext context, String itemId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColors.cream,
        title: const Text('Delete Item'),
        content: const Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: TColors.amber)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        _menuController.deleteMenuItem(vendorId, cafeId, itemId);
        await _menuController.fetchItemsForCafe(vendorId, cafeId);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete item: $e')),
        );
      }
    }
  }

  // Update Item Dialog
  void _showUpdateDialog(
      BuildContext context, CafeItem item, String vendorId, String cafeId) {
    // Initialize the state of the checkboxes
    _menuController.isSpicyUpdate.value = item.isSpicy;
    _menuController.isVegetarianUpdate.value = item.isVegetarian;
    _menuController.isLowSugarUpdate.value = item.isLowSugar;

    // Pre-fill the text fields with the item's current values
    _menuController.itemNameUpdate.text = item.itemName;
    _menuController.itemCostUpdate.text = item.itemPrice.toString();
    _menuController.itemCaloriesUpdate.text = item.itemCalories.toString();

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
                  decoration:
                      const InputDecoration(labelText: 'Item\'s Cost (RM)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cost is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemCaloriesUpdate,
                  decoration: const InputDecoration(
                      labelText: 'Item\'s Calories (kcal)'),
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
                if (_menuController.menuUpdateKey.currentState?.validate() ??
                    false) {
                  // Update the item with new values
                  await _menuController.updateCafeDetails(
                      vendorId, cafeId, item.id);

                  await _menuController.updateItemPreferences(
                      vendorId, cafeId, item.id);

                  await _menuController.fetchItemsForCafe(vendorId, cafeId);

                  Get.snackbar(
                    "Success",
                    "Item's Details Are Updated Successfully!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );

                  Navigator.pop(context);
                }
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
                await _menuController.fetchItemsForCafe(vendorId, cafeId);

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
                  decoration:
                      const InputDecoration(labelText: 'Item\'s Cost (RM)'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cost is required'
                      : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _menuController.itemCalories,
                  decoration: const InputDecoration(
                      labelText: 'Item\'s Calories (kcal)'),
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
                  // Refresh items after adding
                  await _menuController.fetchItemsForCafe(vendorId, cafeId);
                  Navigator.pop(context); // Close the dialog
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

// Helper Function to Build Preference Circle
Widget _buildPreferenceCircle(String text, Color color) {
  return Container(
    width: 24, // Circle size
    height: 24,
    margin: EdgeInsets.only(right: 6), // Spacing between circles
    decoration: BoxDecoration(
      color: color, // Circle color
      shape: BoxShape.circle,
      border: Border.all(color: Colors.black, width: 2),
    ),
    alignment: Alignment.center,
    child: Text(
      text,
      style: TextStyle(
        color: Colors.black, // Text color
        fontWeight: FontWeight.bold,
        fontSize: 12, // Font size
      ),
    ),
  );
}
