import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:fyp_umakan/vendor_navigation_menu.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';

class EditCafeDetailsPage extends StatefulWidget {
  final Rx<CafeDetails> cafe;
  final VoidCallback onSave;

  EditCafeDetailsPage({required this.cafe, required this.onSave});

  @override
  _EditCafeDetailsPageState createState() => _EditCafeDetailsPageState();
}

class _EditCafeDetailsPageState extends State<EditCafeDetailsPage> {
  final VendorController controller = VendorController.instance;
  final VendorMenuController vendorMenuController =
      VendorMenuController.instance;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    // Populate TextEditingControllers with the cafe details
    controller.cafeNameUpdate.text = widget.cafe.value.name;
    controller.cafeLocationUpdate.text = widget.cafe.value.location;
    controller.openingTimeUpdate.text = widget.cafe.value.openingTime;
    controller.closingTimeUpdate.text = widget.cafe.value.closingTime;
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  Future<void> deleteCafe() async {
    try {
      await controller.deleteCafe(
          controller.getCurrentUserId(), widget.cafe.value.id);
      widget.onSave(); // Trigger a callback to refresh the parent view

      // Navigate to VendorNavigationMenu with index 0
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => VendorNavigationMenu(),
        ),
        (route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting cafe: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.mustard,
      appBar: AppBar(
        title: const Text('Edit Cafe Details'),
        backgroundColor: TColors.mustard,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.updateCafeKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cafe Name
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: controller.cafeNameUpdate,
                validator: (value) =>
                    TValidator.validateEmptyText('Cafe Name', value),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Cafe Name',
                  prefixIcon: Icon(Iconsax.home, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Cafe Location
              DropdownButtonFormField<String>(
                value: controller.cafeLocationUpdate.text.isNotEmpty
                    ? controller.cafeLocationUpdate.text
                    : null,
                onChanged: (value) {
                  controller.cafeLocationUpdate.text = value!;
                },
                validator: (value) => value == null || value.isEmpty
                    ? 'Please select a cafe location'
                    : null,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Cafe Location',
                  prefixIcon: Icon(Iconsax.location, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                dropdownColor: const Color.fromARGB(255, 195, 167, 6),
                style: const TextStyle(color: Colors.black),
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                items: [
                  'KK1',
                  'KK2',
                  'KK3',
                  'KK4',
                  'KK5',
                  'KK6',
                  'KK7',
                  'KK8',
                  'KK9',
                  'KK10',
                  'KK11',
                  'KK12',
                  'Others',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Opening Time
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: controller.openingTimeUpdate,
                readOnly: true,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Opening Time',
                  prefixIcon: Icon(Iconsax.clock, color: Colors.black),
                  suffixIcon: Icon(Icons.access_time, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    controller.openingTimeUpdate.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Closing Time
              TextFormField(
                style: const TextStyle(color: Colors.black),
                controller: controller.closingTimeUpdate,
                readOnly: true,
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.black),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  labelText: 'Closing Time',
                  prefixIcon: Icon(Iconsax.clock, color: Colors.black),
                  suffixIcon: Icon(Icons.access_time, color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) {
                    controller.closingTimeUpdate.text = time.format(context);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Image Upload
              Text(
                'Upload Cafe Image',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10),
                    color: TColors.mustard,
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : widget.cafe.value.image != null &&
                              widget.cafe.value.image!.isNotEmpty
                          ? Image.network(
                              widget.cafe.value.image!,
                              fit: BoxFit.cover,
                            )
                          : const Center(child: Icon(Icons.add_a_photo)),
                ),
              ),
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (controller.updateCafeKey.currentState?.validate() ??
                        false) {
                      String? imageUrl = widget.cafe.value.image;
                      if (_selectedImage != null) {
                        imageUrl = await controller.uploadImage(
                          _selectedImage!,
                          controller.getCurrentUserId(),
                          widget.cafe.value.name,
                        );
                      }

                      await controller.updateCafeDetails(
                        controller.currentUserId,
                        widget.cafe.value.id,
                        imageUrl,
                      );
                      // Update the reactive CafeDetails object
                      widget.cafe.update((cafeDetails) {
                        if (cafeDetails != null) {
                          cafeDetails.image =
                              imageUrl!; // Update the image reactively
                          cafeDetails.name =
                              controller.cafeNameUpdate.text.trim();
                          cafeDetails.location =
                              controller.cafeLocationUpdate.text.trim();
                          cafeDetails.openingTime =
                              controller.openingTimeUpdate.text.trim();
                          cafeDetails.closingTime =
                              controller.closingTimeUpdate.text.trim();
                        }
                      });
                      widget.onSave();
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: TColors.textDark,
                    backgroundColor: TColors.textLight,
                    side: BorderSide(
                        color: Colors.black, // Border color of the button
                        width: 2.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Update'),
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
                              'Are you sure you want to delete this cafe?'),
                          actions: [
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: Text('Delete'),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await deleteCafe();
                      print("Cafe Deleted!");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.red,
                    side: BorderSide(
                        color: Colors.black, // Border color of the button
                        width: 2.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 20),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text('Delete Cafe'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
