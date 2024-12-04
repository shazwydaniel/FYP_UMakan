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

  GlobalKey<FormState> menuFormKey = GlobalKey<FormState>();

  //Update Variable
  final TextEditingController itemNameUpdate = TextEditingController();
  final TextEditingController itemCostUpdate = TextEditingController();
  final TextEditingController itemCaloriesUpdate = TextEditingController();
  GlobalKey<FormState> menuUpdateKey = GlobalKey<FormState>();
  Rx<CafeItem> cafeItem = CafeItem.empty().obs;

  final VendorRepository vendorRepository = VendorRepository.instance;

  //Models
  final items = <CafeItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    initalizeNames();
  }

  //Fetch User Record
  Future<void> initalizeNames() async {
    itemNameUpdate.text = cafeItem.value.itemName;
    itemCaloriesUpdate.text = cafeItem.value.itemCalories.toString();
    itemCostUpdate.text = cafeItem.value.itemPrice.toString();
  }

  // Add method to handle adding menu items
  Future<void> addItem(String vendorId, String cafeId, String imageUrl) async {
    if (menuFormKey.currentState?.validate() ?? false) {
      print('Form validated successfully.');
      try {
        CafeDetails cafeDetails =
            await vendorRepository.getCafeById(vendorId, cafeId);
        String itemLocation = cafeDetails.location;
        String itemCafe = cafeDetails.name;
        // Create a map for the menu item data
        Map<String, dynamic> itemData = {
          'itemName': itemName.text.trim(),
          'itemCost': double.tryParse(itemCost.text.trim()) ?? 0.0,
          'itemCalories': int.tryParse(itemCalories.text.trim()) ?? 0,
          'itemLocation': itemLocation,
          'itemCafe': itemCafe,
          'itemImage': imageUrl,
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
}
