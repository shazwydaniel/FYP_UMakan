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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cafe details updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update cafe: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
        title: Text(widget.cafeData['cafeName'] ?? 'Edit Cafe Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(
                  'Edit Cafe Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _saveCafeDetails,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
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
