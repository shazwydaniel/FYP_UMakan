import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
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
      appBar: AppBar(
        title: const Text('Items'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(
        () {
          if (_menuController.items.isEmpty) {
            return const Center(child: Text('No items available.'));
          }

          return ListView.builder(
            itemCount: _menuController.items.length,
            itemBuilder: (context, index) {
              final item = _menuController.items[index];

              return Card(
                child: ListTile(
                  title: Text(item.itemName),
                  subtitle: Text(
                      'Price: ${item.itemPrice.toString()} | Calories: ${item.itemCalories.toString()}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _menuController.deleteMenuItem(vendorId, cafeId, item.id);
                    },
                  ),
                  onTap: () =>
                      _showUpdateDialog(context, item, vendorId, cafeId),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue,
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
          title: const Text('Update Item'),
          content: Form(
            key: _menuController.menuUpdateKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _menuController.itemNameUpdate,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Name is required'
                      : null,
                ),
                TextFormField(
                  controller: _menuController.itemCostUpdate,
                  decoration: const InputDecoration(labelText: 'Item Cost'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cost is required'
                      : null,
                ),
                TextFormField(
                  controller: _menuController.itemCaloriesUpdate,
                  decoration: const InputDecoration(labelText: 'Item Calories'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Calories are required'
                      : null,
                ),
                const SizedBox(height: 16),
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _menuController.updateCafeDetails(
                    vendorId, cafeId, item.id);
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

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
          title: const Text('Add Menu Item'),
          content: Form(
            key: _menuController.menuFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _menuController.itemName,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Name is required'
                      : null,
                ),
                TextFormField(
                  controller: _menuController.itemCost,
                  decoration: const InputDecoration(labelText: 'Item Cost'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Cost is required'
                      : null,
                ),
                TextFormField(
                  controller: _menuController.itemCalories,
                  decoration: const InputDecoration(labelText: 'Item Calories'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Calories are required'
                      : null,
                ),
                const SizedBox(height: 16),
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
              child: const Text('Cancel'),
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
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
