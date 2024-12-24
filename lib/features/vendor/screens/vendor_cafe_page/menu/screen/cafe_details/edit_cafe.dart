import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_cafe_page/menu/controller/menu_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:image_picker/image_picker.dart';

class EditCafeDetailsPage extends StatefulWidget {
  final CafeDetails cafe;
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
    controller.cafeNameUpdate.text = widget.cafe.name;
    controller.cafeLocationUpdate.text = widget.cafe.location;
    controller.openingTimeUpdate.text = widget.cafe.openingTime;
    controller.closingTimeUpdate.text = widget.cafe.closingTime;
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
                controller: controller.cafeNameUpdate,
                validator: (value) =>
                    TValidator.validateEmptyText('Cafe Name', value),
                decoration: const InputDecoration(
                  labelText: 'Cafe Name',
                  border: OutlineInputBorder(),
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
                  labelText: 'Cafe Location',
                  border: OutlineInputBorder(),
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
                controller: controller.openingTimeUpdate,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Opening Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
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
                controller: controller.closingTimeUpdate,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Closing Time',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.access_time),
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
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : widget.cafe.image != null &&
                              widget.cafe.image!.isNotEmpty
                          ? Image.network(
                              widget.cafe.image!,
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
                      String? imageUrl = widget.cafe.image;
                      if (_selectedImage != null) {
                        imageUrl = await controller.uploadImage(
                          _selectedImage!,
                          controller.getCurrentUserId(),
                          widget.cafe.name,
                        );
                      }

                      await controller.updateCafeDetails(
                        controller.currentUserId,
                        widget.cafe.id,
                        imageUrl,
                      );
                      widget.onSave();
                      vendorMenuController.fetchItemsForCafe(
                          VendorController.instance.getCurrentUserId(),
                          widget.cafe.id);
                      Navigator.pop(context, true);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: TColors.mustard,
                    backgroundColor: TColors.textLight,
                  ),
                  child: const Text('Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
