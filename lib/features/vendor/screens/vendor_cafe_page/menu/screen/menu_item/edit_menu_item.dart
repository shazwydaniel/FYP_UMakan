import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class EditMenuItemPage extends StatefulWidget {
  final CafeItem menuItem;
  final String cafeId;

  EditMenuItemPage({required this.menuItem, required this.cafeId});

  @override
  _EditMenuItemPageState createState() => _EditMenuItemPageState();
}

class _EditMenuItemPageState extends State<EditMenuItemPage> {
  final VendorMenuController controller = Get.put(VendorMenuController());

  String vendorId = VendorController.instance.getCurrentUserId();

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    controller.cafeItem.value = widget.menuItem;
    controller.itemNameUpdate.text = widget.menuItem.itemName;
    controller.itemCostUpdate.text = widget.menuItem.itemPrice.toString();
    controller.itemCaloriesUpdate.text =
        widget.menuItem.itemCalories.toString();

    // Initialize the preferences
    controller.initializePreferences(widget.menuItem);
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> saveChanges() async {
    if (controller.menuUpdateKey.currentState?.validate() ?? false) {
      String? imageUrl;

      // Upload the new image if one is selected
      if (selectedImage != null) {
        imageUrl = await controller.uploadImage(
          selectedImage!,
          vendorId,
          widget.cafeId,
        );
      }

      // Update the menu item details
      await controller.updateCafeDetails(
        vendorId,
        widget.cafeId,
        widget.menuItem.id,
      );

      // Update preferences in Firestore
      await controller.updateItemPreferences(
        vendorId,
        widget.cafeId,
        widget.menuItem.id,
      );

      // Update the image URL in Firestore if a new image was uploaded
      if (imageUrl != null) {
        await controller.vendorRepository.updateSingleMenuItem(
          {'itemImage': imageUrl},
          vendorId,
          widget.cafeId,
          widget.menuItem.id,
        );
      }

      Navigator.pop(context, true);
    }
  }

  Future<void> deleteMenuItem() async {
    try {
      await controller.deleteMenuItem(
        vendorId,
        widget.cafeId,
        widget.menuItem.id,
      );
      print("Item Deleted!");
      // Navigate back to the menu list after deletion
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting menu item: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.amber,
      appBar: AppBar(
        title: const Text('Edit Menu Item'),
        backgroundColor: TColors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.menuUpdateKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item Name Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller.itemNameUpdate,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Item Name',
                    prefixIcon: Icon(Iconsax.edit, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Item Price Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller.itemCostUpdate,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Price (RM)',
                    prefixIcon: Icon(Iconsax.money, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Item Calories Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller.itemCaloriesUpdate,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Calories',
                    prefixIcon: Icon(Iconsax.weight, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Text(
                  "Prefences",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                Obx(() => CheckboxListTile(
                      title: const Text(
                        'Spicy',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: controller.isSpicyUpdate.value,
                      activeColor: Colors.white,
                      checkColor: TColors.textDark,
                      onChanged: (value) {
                        controller.isSpicyUpdate.value = value!;
                      },
                    )),
                Obx(() => CheckboxListTile(
                      title: const Text(
                        'Vegetarian',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: controller.isVegetarianUpdate.value,
                      activeColor: Colors.white,
                      checkColor: TColors.textDark,
                      onChanged: (value) {
                        controller.isVegetarianUpdate.value = value!;
                      },
                    )),
                Obx(() => CheckboxListTile(
                      title: const Text(
                        'Low Sugar',
                        style: TextStyle(color: Colors.white),
                      ),
                      value: controller.isLowSugarUpdate.value,
                      activeColor: Colors.white,
                      checkColor: TColors.textDark,
                      onChanged: (value) {
                        controller.isLowSugarUpdate.value = value!;
                      },
                    )),

                SizedBox(height: 20),

                // Image Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Item Image',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 180,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: selectedImage != null
                            ? Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : (widget.menuItem.itemImage != null &&
                                    widget.menuItem.itemImage.isNotEmpty)
                                ? Image.network(
                                    widget.menuItem.itemImage,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Icon(Icons.add_a_photo),
                                  ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Update Button
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    child: ElevatedButton(
                      onPressed: saveChanges,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 20),
                          backgroundColor: TColors.textLight,
                          foregroundColor: TColors.textDark,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          side: BorderSide(
                              color: Colors.white, // Border color of the button
                              width: 2.0)),
                      child: const Text('Update Menu Item'),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Delete Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      bool confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Confirm Deletion'),
                            content: Text(
                                'Are you sure you want to delete this item?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await deleteMenuItem();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.red,
                      side: BorderSide(
                          color: Colors.white, // Border color of the button
                          width: 2.0),
                    ),
                    child: const Text('Delete Menu Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
