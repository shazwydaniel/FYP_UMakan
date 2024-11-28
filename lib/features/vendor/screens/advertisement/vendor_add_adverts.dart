import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VendorAdverts extends StatelessWidget {
  VendorAdverts({super.key, required this.cafeId});

  final String vendorId = VendorController.instance.getCurrentUserId();
  final String cafeId;
  final controller = Get.put(AdvertController());

  // Function to show the date picker and set the selected date.
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to current date
      firstDate: DateTime(2000), // Earliest date selectable
      lastDate: DateTime(2100), // Latest date selectable
    );

    if (picked != null) {
      controller.text =
          picked.toLocal().toString().split(' ')[0]; // Format as YYYY-MM-DD
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Advertisment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: controller.menuFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text Field for Item Name
              TextField(
                controller: controller.adDetail,
                decoration: InputDecoration(
                  labelText: 'Advertisment Detail',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),

              // Text Field for Start Date
              TextField(
                controller: controller.startDateController,
                readOnly: true, // Prevent manual input
                decoration: const InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                ),
                onTap: () =>
                    _selectDate(context, controller.startDateController),
              ),
              const SizedBox(height: 16.0),

              // Text Field for End Date
              TextField(
                controller: controller.endDateController,
                readOnly: true, // Prevent manual input
                decoration: const InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                ),
                onTap: () => _selectDate(context, controller.endDateController),
              ),
              const SizedBox(height: 16.0),

              // Add Button
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    // Call the addAdvert function from the controller
                    await controller.addAdvert(vendorId, cafeId);

                    // Close the page and return the entered data (optional)
                    Navigator.pop(context);
                  },
                  child: Text('Add Item'),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
