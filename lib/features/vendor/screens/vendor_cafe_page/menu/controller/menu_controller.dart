import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:get/get.dart';

class VendorMenuController extends GetxController {
  static VendorMenuController get instance => Get.find();

  final itemName = TextEditingController();
  final itemCost = TextEditingController();
  final itemCalories = TextEditingController();

  // Make sure this is defined as a field in the controller
  GlobalKey<FormState> menuFormKey = GlobalKey<FormState>();
  final VendorRepository vendorRepository = VendorRepository.instance;

  //Models
  final items = <CafeItem>[].obs;

  // Add method to handle adding menu items
  Future<void> addItem(String vendorId, String cafeId) async {
    if (menuFormKey.currentState?.validate() ?? false) {
      try {
        CafeDetails cafeDetails =
            await vendorRepository.getCafeById(vendorId, cafeId);
        String itemLocation = cafeDetails.location;
        // Create a map for the menu item data
        Map<String, dynamic> itemData = {
          'itemName': itemName.text.trim(),
          'itemCost': double.tryParse(itemCost.text.trim()) ?? 0.0,
          'itemCalories': int.tryParse(itemCalories.text.trim()) ?? 0,
          'itemLocation': itemLocation,
        };

        // Call the repository method to add the item to Firestore
        await vendorRepository.addItemToCafe(vendorId, cafeId, itemData);

        // Clear the text fields after adding the item
        itemName.clear();
        itemCost.clear();
        itemCalories.clear();

        // Print confirmation
        print('Menu item added!');
      } catch (e) {
        // Handle error
        print('Error adding menu item: $e');
      }
    }
  }

  // Fetch
  Future<void> fetchItemsForCafe(String vendorId, String cafeId) async {
    try {
      // Fetch list of cafes from the repository
      final itemList = await vendorRepository.getItemsForCafe(vendorId, cafeId);

      // Check if cafes were found
      if (itemList.isNotEmpty) {
        // Assign the fetched cafes to the observable list
        items.assignAll(itemList);
        print("Items fetched: ${items.length}");
      } else {
        print('No item found');
        items.clear(); // Optionally clear if no cafes are found
      }
    } catch (e) {
      print('Error fetching item: $e');
      items.clear(); // Handle error by clearing the list
    }
  }
}
