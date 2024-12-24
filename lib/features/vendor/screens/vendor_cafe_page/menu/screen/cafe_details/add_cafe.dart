import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class AddCafe extends StatefulWidget {
  const AddCafe({Key? key}) : super(key: key);

  @override
  _AddCafeState createState() => _AddCafeState();
}

class _AddCafeState extends State<AddCafe> {
  final controller = VendorController.instance;
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    controller.cafeName.clear();
    controller.cafeLocation.clear();
    controller.openingTime.clear();
    controller.closingTime.clear();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectTime(
      BuildContext context, TextEditingController timeController) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      timeController.text = pickedTime.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Cafe'),
        backgroundColor: TColors.amber,
      ),
      backgroundColor: TColors.amber,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.cafeFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller.cafeName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Cafe Name', value),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Cafe Name',
                    prefixIcon: Icon(Iconsax.home, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: controller.cafeLocation.text.isNotEmpty
                      ? controller.cafeLocation.text
                      : null,
                  onChanged: (value) {
                    if (value != null) {
                      controller.cafeLocation.text = value;
                    }
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please select a cafe location'
                      : null,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Cafe Location',
                    prefixIcon: Icon(Iconsax.location, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
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
                      child: Text(value,
                          style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller.openingTime,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Opening Time',
                    prefixIcon: Icon(Iconsax.clock, color: Colors.white),
                    suffixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onTap: () => _selectTime(context, controller.openingTime),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: controller.closingTime,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Closing Time',
                    prefixIcon: Icon(Iconsax.clock, color: Colors.white),
                    suffixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  onTap: () => _selectTime(context, controller.closingTime),
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload Item Image',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8.0),
                    GestureDetector(
                      onTap: _pickImage, // Method to handle image selection
                      child: Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.cafeFormKey.currentState?.validate() ??
                          false) {
                        try {
                          // Initialize imageUrl as null
                          String? imageUrl;

                          // Upload image if selected
                          if (_selectedImage != null) {
                            imageUrl = await controller.uploadImage(
                              _selectedImage!,
                              controller.getCurrentUserId(),
                              controller.cafeName.text.trim(),
                            );
                          }

                          // Add cafe with the uploaded image URL or null
                          await controller.addCafe(
                              controller.getCurrentUserId(), imageUrl);

                          // Clear form fields
                          controller.cafeName.clear();
                          controller.cafeLocation.clear();
                          controller.openingTime.clear();
                          controller.closingTime.clear();
                          controller.cafeFormKey.currentState?.reset();

                          Navigator.pop(context, true);

                          print('Cafe added successfully');
                        } catch (e) {
                          print('Error adding cafe: $e');
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: TColors.amber,
                      backgroundColor: TColors.textLight,
                    ),
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
