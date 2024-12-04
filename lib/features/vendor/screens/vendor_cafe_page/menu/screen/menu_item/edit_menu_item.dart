import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
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
  final VendorController vendorController = VendorController.instance;

  File? selectedImage;

  @override
  void initState() {
    super.initState();
    controller.cafeItem.value = widget.menuItem;
    controller.itemNameUpdate.text = widget.menuItem.itemName;
    controller.itemCostUpdate.text = widget.menuItem.itemPrice.toString();
    controller.itemCaloriesUpdate.text =
        widget.menuItem.itemCalories.toString();
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
          vendorController.getCurrentUserId(),
          widget.cafeId,
        );
      }

      // Update the menu item details
      await controller.updateCafeDetails(
        vendorController.getCurrentUserId(),
        widget.cafeId,
        widget.menuItem.id,
      );

      // Update the image URL in Firestore if a new image was uploaded
      if (imageUrl != null) {
        await controller.vendorRepository.updateSingleMenuItem(
          {'itemImage': imageUrl},
          vendorController.getCurrentUserId(),
          widget.cafeId,
          widget.menuItem.id,
        );
      }

      Navigator.pop(context, true);
    }
  }

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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Menu Item',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
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
                const SizedBox(height: 20),

                // Image Picker
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Item Image',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
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
                  child: ElevatedButton(
                    onPressed: saveChanges,
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
      ),
    );
  }
}
