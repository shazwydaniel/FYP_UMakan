import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:get/get.dart';

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
    // Initialize controllers with existing data
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

        // Call the update method from the repository
        await _vendorController.vendorRepository.updateSingleFieldCafe(
          updatedData,
          widget.vendorId,
          widget.cafeData['cafe_ID'],
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cafe details updated successfully')),
        );
        Navigator.pop(context); // Close the edit page
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
      appBar: AppBar(
        title: Text(widget.cafeData['cafeName'] ?? 'Edit Cafe Details'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Edit Cafe Details',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cafeNameController,
                decoration: const InputDecoration(labelText: 'Cafe Name'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _cafeLocationController,
                decoration: const InputDecoration(labelText: 'Cafe Location'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Location is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _openingTimeController,
                decoration: const InputDecoration(labelText: 'Opening Time'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Opening Time is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _closingTimeController,
                decoration: const InputDecoration(labelText: 'Closing Time'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Closing Time is required'
                    : null,
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _saveCafeDetails,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Changes'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
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
