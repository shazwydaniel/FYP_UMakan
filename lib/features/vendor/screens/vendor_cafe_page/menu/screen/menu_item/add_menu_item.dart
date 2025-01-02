import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart'; // Import the package
import 'dart:io';

class AddMenuItemPage extends StatefulWidget {
  final String cafeId;

  AddMenuItemPage({Key? key, required this.cafeId}) : super(key: key);

  @override
  State<AddMenuItemPage> createState() => _AddMenuItemPageState();
}

class _AddMenuItemPageState extends State<AddMenuItemPage> {
  final VendorMenuController controller = Get.put(VendorMenuController());
  final vendorId = VendorController.instance.getCurrentUserId();

  File? selectedImage; // To store the picked image

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        title: Text('Add Menu Item'),
        backgroundColor: TColors.mustard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.menuFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Field for Item Name
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: controller.itemName,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Item Name',
                  prefixIcon: Icon(Iconsax.edit, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Text Field for Item Cost
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: controller.itemCost,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Item Cost',
                  prefixIcon: Icon(Iconsax.money, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an item cost';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),

              // Text Field for Item Calories
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: controller.itemCalories,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Item Calories',
                  prefixIcon: Icon(Iconsax.weight, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item calories';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),

              Text(
                "Prefences",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              // Preferences Checkboxes
              Obx(() => CheckboxListTile(
                    title: Text(
                      'Spicy',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: controller.isSpicy.value,
                    activeColor: Colors.black,
                    checkColor: TColors.textLight,
                    onChanged: (value) {
                      controller.isSpicy.value = value!;
                    },
                  )),
              Obx(() => CheckboxListTile(
                    title: Text(
                      'Vegetarian',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: controller.isVegetarian.value,
                    activeColor: Colors.black,
                    checkColor: TColors.textLight,
                    onChanged: (value) {
                      controller.isVegetarian.value = value!;
                    },
                  )),
              Obx(() => CheckboxListTile(
                    title: Text(
                      'Low Sugar',
                      style: TextStyle(color: Colors.black),
                    ),
                    value: controller.isLowSugar.value,
                    activeColor: Colors.black,
                    checkColor: TColors.textLight,
                    onChanged: (value) {
                      controller.isLowSugar.value = value!;
                    },
                  )),
              const SizedBox(height: 20),
              // Image Picker Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Item Image',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 20.0),
                  GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: selectedImage != null
                          ? Image.file(
                              selectedImage!,
                              fit: BoxFit.cover,
                            )
                          : Center(child: Icon(Icons.add_a_photo)),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.0),

              // Add Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.menuFormKey.currentState?.validate() ??
                        false) {
                      if (selectedImage == null) {
                        Get.snackbar('Error', 'Please upload an image.');
                        return;
                      }

                      // Upload the image and add the item
                      final imageUrl = await controller.uploadImage(
                          selectedImage!, vendorId, widget.cafeId);
                      await controller.addItem(
                        vendorId,
                        widget.cafeId,
                        imageUrl,
                      );

                      // Close the page after adding the item
                      Navigator.pop(context, true);
                    }
                  },
                  child: Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
                      backgroundColor: TColors.textLight,
                      foregroundColor: TColors.textDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(
                          color: Colors.white, // Border color of the button
                          width: 2.0)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
