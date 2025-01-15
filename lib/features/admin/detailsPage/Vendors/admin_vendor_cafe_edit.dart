// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';

class AdminVendorCafeEdit extends StatefulWidget {
  final Map<String, dynamic> cafeData;
  final String vendorId;

  AdminVendorCafeEdit({required this.cafeData, required this.vendorId});

  @override
  _AdminVendorCafeEditState createState() => _AdminVendorCafeEditState();
}

class _AdminVendorCafeEditState extends State<AdminVendorCafeEdit> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cafeNameController;
  late TextEditingController _cafeLocationController;
  late TextEditingController _openingTimeController;
  late TextEditingController _closingTimeController;

  final VendorController _vendorController = Get.put(VendorController());

  @override
  void initState() {
    super.initState();
    _cafeNameController =
        TextEditingController(text: widget.cafeData['cafeName']);
    _cafeLocationController =
        TextEditingController(text: widget.cafeData['cafeLocation']);
    _openingTimeController =
        TextEditingController(text: widget.cafeData['openingTime']);
    _closingTimeController =
        TextEditingController(text: widget.cafeData['closingTime']);
  }

  @override
  void dispose() {
    _cafeNameController.dispose();
    _cafeLocationController.dispose();
    _openingTimeController.dispose();
    _closingTimeController.dispose();
    super.dispose();
  }

  Future<void> _saveCafeDetails() async {
    if (_formKey.currentState!.validate()) {
      try {
        final updatedData = {
          'cafeName': _cafeNameController.text.trim(),
          'cafeLocation': _cafeLocationController.text.trim(),
          'openingTime': _openingTimeController.text.trim(),
          'closingTime': _closingTimeController.text.trim(),
        };

        await _vendorController.vendorRepository.updateSingleFieldCafe(
          updatedData,
          widget.vendorId,
          widget.cafeData['cafe_ID'],
        );

        Get.snackbar(
          "Success",
          "Cafe details updated successfully!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Navigator.pop(context);
      } catch (e) {
        Get.snackbar(
          "Failed",
          "Failed to update cafe details!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        print('Error updating cafe details: $e');
      }
    }
  }

  // Main Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
        // title: Text(widget.cafeData['cafeName'] ?? 'Edit Cafe Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cafeData['cafeName'] ?? 'Cafe Name',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 22),
                _sectionHeader('Edit Details', TColors.vermillion),
                TextField(
                  controller: _cafeNameController,
                  decoration: const InputDecoration(
                    labelText: 'Cafe Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _cafeLocationController,
                  decoration: const InputDecoration(
                    labelText: 'Cafe Location',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _openingTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Opening Time',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _closingTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Closing Time',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 25),
                Center(
                  child: Container(
                    width: 200,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: TextButton.icon(
                      onPressed: _saveCafeDetails,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: const Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
