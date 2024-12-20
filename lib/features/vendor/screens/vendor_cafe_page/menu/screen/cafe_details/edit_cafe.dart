import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:get/get.dart';

class EditCafeDetailsPage extends StatelessWidget {
  final CafeDetails cafe;
  final VoidCallback onSave;

  EditCafeDetailsPage({required this.cafe, required this.onSave}) {
    final controller = VendorController.instance;

    // Populate TextEditingControllers with the cafe details
    controller.cafeNameUpdate.text = cafe.name;
    controller.cafeLocationUpdate.text = cafe.location;
    controller.openingTimeUpdate.text = cafe.openingTime;
    controller.closingTimeUpdate.text = cafe.closingTime;
  }

  @override
  Widget build(BuildContext context) {
    final controller = VendorController.instance;

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
              // Cafe Location (Dropdown)
              DropdownButtonFormField<String>(
                value: controller.cafeLocationUpdate.text.isNotEmpty
                    ? controller.cafeLocationUpdate.text
                    : null, // Set the initial value
                onChanged: (value) {
                  controller.cafeLocationUpdate.text =
                      value!; // Update the controller
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
              const SizedBox(height: 20),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: TColors.mustard, // Black border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(
                        15), // Match button's border radius
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.updateCafeKey.currentState?.validate() ??
                          false) {
                        // Update the cafe details
                        await controller.updateCafeDetails(
                            controller.currentUserId, cafe.id);
                        onSave();
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
