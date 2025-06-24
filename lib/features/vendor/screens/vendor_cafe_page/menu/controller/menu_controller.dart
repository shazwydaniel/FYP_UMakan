import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/common/widgets/loaders/loaders.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/vendor_repository.dart';
import 'package:fyp_umakan/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class VendorMenuController extends GetxController {
  static VendorMenuController get instance => Get.find();

  final itemName = TextEditingController();
  final itemCost = TextEditingController();
  final itemCalories = TextEditingController();

  // Add these properties for preferences
  RxBool isSpicy = false.obs;
  RxBool isVegetarian = false.obs;
  RxBool isLowSugar = false.obs;

  // Add these properties for item preferences
  RxBool isSpicyUpdate = false.obs;
  RxBool isVegetarianUpdate = false.obs;
  RxBool isLowSugarUpdate = false.obs;

  RxBool isAvailable = false.obs;
  RxBool isAvailableUpdate = false.obs;

  GlobalKey<FormState> menuFormKey = GlobalKey<FormState>();

  //Update Variable
  final TextEditingController itemNameUpdate = TextEditingController();
  final TextEditingController itemCostUpdate = TextEditingController();
  final TextEditingController itemCaloriesUpdate = TextEditingController();
  GlobalKey<FormState> menuUpdateKey = GlobalKey<FormState>();

  // Add method to initialize these preferences when editing
  void initializePreferences(CafeItem menuItem) {
    isSpicyUpdate.value = menuItem.isSpicy ?? false;
    isVegetarianUpdate.value = menuItem.isVegetarian ?? false;
    isLowSugarUpdate.value = menuItem.isLowSugar ?? false;
  }

  // Add method to initialize these preferences when editing
  void initializeAvailability(CafeItem menuItem) {
    isAvailableUpdate.value = menuItem.isAvailable ?? false;
  }

  Rx<CafeItem> cafeItem = CafeItem.empty().obs;

  final VendorRepository vendorRepository = VendorRepository.instance;

  //Models
  final items = <CafeItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    initalizeNames();
  }

  // Add method to reset these preferences (useful after adding an item)
  void resetPreferences() {
    isSpicy.value = false;
    isVegetarian.value = false;
    isLowSugar.value = false;
    isAvailable.value = false;
  }

  //Fetch User Record
  Future<void> initalizeNames() async {
    itemNameUpdate.text = cafeItem.value.itemName;
    itemCaloriesUpdate.text = cafeItem.value.itemCalories.toString();
    itemCostUpdate.text = cafeItem.value.itemPrice.toString();
  }

  // Add method to update preferences in Firestore
  Future<void> updateItemPreferences(
      String vendorId, String cafeId, String itemId) async {
    Map<String, dynamic> updatedPreferences = {
      'isSpicy': isSpicyUpdate.value,
      'isVegetarian': isVegetarianUpdate.value,
      'isLowSugar': isLowSugarUpdate.value,
      'isAvailable': isAvailableUpdate.value
    };

    await vendorRepository.updateSingleMenuItem(
        updatedPreferences, vendorId, cafeId, itemId);
  }

  // Add method to handle adding menu items
  Future<void> addItem(String vendorId, String cafeId, String imageUrl) async {
    if (menuFormKey.currentState?.validate() ?? false) {
      try {
        CafeDetails cafeDetails =
            await vendorRepository.getCafeById(vendorId, cafeId);
        String itemLocation = cafeDetails.location;
        String itemCafe = cafeDetails.name;

        // Create a map for the menu item data
        Map<String, dynamic> itemData = {
          'itemName': itemName.text.trim(),
          'itemCost': double.tryParse(itemCost.text.trim()) ?? 0.00,
          'itemCalories': int.tryParse(itemCalories.text.trim()) ?? 0,
          'itemLocation': itemLocation,
          'itemCafe': itemCafe,
          'itemImage': imageUrl,
          'cafeId': cafeId,
          'isSpicy': isSpicy.value,
          'isVegetarian': isVegetarian.value,
          'isLowSugar': isLowSugar.value,
          'isAvailable': isAvailable.value,
        };

        print('itemData being sent: $itemData');

        // Call the repository method to add the item to Firestore
        await vendorRepository.addItemToCafe(vendorId, cafeId, itemData);

        print('itemName: ${itemName.text}');
        print('itemCost: ${itemCost.text}');
        print('itemCalories: ${itemCalories.text}');

        // Clear the text fields after adding the item
        itemName.clear();
        itemCost.clear();
        itemCalories.clear();
        resetPreferences();

        // Print confirmation
        print('Menu item added!');
      } catch (e) {
        // Handle error
        print('Error adding menu item: $e');
      }
    }
  }

  Future<void> fetchItemsForCafe(String vendorId, String cafeId) async {
    try {
      print(
          'Calling getItemsForCafe with vendorId: $vendorId, cafeId: $cafeId');

      // Fetch list of CafeItem objects from the repository
      final itemList = await vendorRepository.getItemsForCafe(vendorId, cafeId);

      // Debug: Log the fetched list
      print('Fetched itemList: $itemList');

      // Assign the fetched items directly to the observable list
      items.assignAll(itemList);
      print("Items fetched: ${items.length}");
    } catch (e) {
      // Debug: Print the error for deeper inspection
      print('Error fetching items in fetchItemsForCafe: $e');
      items.clear(); // Clear the list in case of an error
    }
  }

  Future<void> updateCafeDetails(
      String vendorId, String cafeId, String itemID) async {
    try {
      // Check internet connection
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        TLoaders.errorSnackBar(
            title: 'No Internet',
            message: 'Please check your internet connection.');
        return;
      }

      // Form Validation
      if (!menuUpdateKey.currentState!.validate()) {
        TLoaders.errorSnackBar(
            title: 'Invalid Input',
            message: 'Please fill all the required fields correctly.');
        return;
      }

      // Debug: Log the data being sent to Firestore
      print('Updating Cafe with data:');

      // Update data in Firebase Firestore
      Map<String, dynamic> updateItemName = {
        'itemName': itemNameUpdate.text.trim()
      };
      Map<String, dynamic> updateItemCalorie = {
        'itemCalories': itemCaloriesUpdate.text.trim()
      };
      Map<String, dynamic> updateItemCost = {
        'itemCost': itemCostUpdate.text.trim()
      };

      // Use methods in User Repository to transfer to Firebase
      await vendorRepository.updateSingleMenuItem(
          updateItemName, vendorId, cafeId, itemID);
      await vendorRepository.updateSingleMenuItem(
          updateItemCalorie, vendorId, cafeId, itemID);
      await vendorRepository.updateSingleMenuItem(
          updateItemCost, vendorId, cafeId, itemID);

      cafeItem.value.itemName = itemNameUpdate.text.trim();
      cafeItem.value.itemCalories =
          int.tryParse(itemCaloriesUpdate.text.trim()) ?? 0;
      cafeItem.value.itemPrice = cafeItem.value.itemPrice =
          double.tryParse(itemCostUpdate.text.trim()) ?? 0.0;

      // Show success Message
      TLoaders.successSnackBar(
          title: 'Success!', message: "Your cafe details have been updated!");
    } catch (e) {
      // Log the error for debugging
      debugPrint("Error update: $e");
      TLoaders.errorSnackBar(title: 'Oops!', message: e.toString());
    }
  }

  Future<String> uploadImage(
      File imageFile, String vendorId, String cafeId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child(
          'menu_images/$vendorId/$cafeId/${DateTime.now().toIso8601String()}');

      final uploadTask = await storageRef.putFile(imageFile);
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl; // Return the URL to store in Firestore
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Image upload failed.');
    }
  }

  Future<void> deleteMenuItem(
      String vendorId, String cafeId, String itemId) async {
    try {
      // Call the repository to delete the menu item from Firestore
      await vendorRepository.deleteMenuItem(vendorId, cafeId, itemId);

      // Clear the current cafeItem if it matches the deleted item
      if (cafeItem.value.id == itemId) {
        cafeItem.value = CafeItem.empty();
      }

      // Notify listeners of the updated state
      update();
      Get.snackbar(
        'Success',
        'Menu item deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete menu item: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
