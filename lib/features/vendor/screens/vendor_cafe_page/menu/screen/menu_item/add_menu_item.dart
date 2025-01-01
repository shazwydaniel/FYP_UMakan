import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
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
                controller: controller.itemName,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  border: OutlineInputBorder(),
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
                controller: controller.itemCost,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Cost',
                  border: OutlineInputBorder(),
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
                controller: controller.itemCalories,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Item Calories',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter item calories';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24.0),

              // Preferences Checkboxes
              Obx(() => CheckboxListTile(
                    title: Text('Spicy'),
                    value: controller.isSpicy.value,
                    onChanged: (value) {
                      controller.isSpicy.value = value!;
                    },
                  )),
              Obx(() => CheckboxListTile(
                    title: Text('Vegetarian'),
                    value: controller.isVegetarian.value,
                    onChanged: (value) {
                      controller.isVegetarian.value = value!;
                    },
                  )),
              Obx(() => CheckboxListTile(
                    title: Text('Low Sugar'),
                    value: controller.isLowSugar.value,
                    onChanged: (value) {
                      controller.isLowSugar.value = value!;
                    },
                  )),

              // Image Picker Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Upload Item Image',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 8.0),
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
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    backgroundColor: TColors.forest,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
