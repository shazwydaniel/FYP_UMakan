import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

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
      backgroundColor: TColors.amber,
      appBar: AppBar(
        title: Text(
          'Add Advertisment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: TColors.amber,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back arrow
        ),
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
                style: const TextStyle(color: Colors.white),
                controller: controller.adDetail,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  labelText: 'Advertisment Detail',
                  prefixIcon: Icon(Iconsax.edit, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              SizedBox(height: 16.0),

              // Text Field for Start Date
              TextField(
                style: const TextStyle(color: Colors.white),

                controller: controller.startDateController,
                readOnly: true, // Prevent manual input
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  labelText: 'Start Date',
                  prefixIcon: Icon(Iconsax.calendar, color: Colors.white),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onTap: () =>
                    _selectDate(context, controller.startDateController),
              ),
              const SizedBox(height: 16.0),

              // Text Field for End Date
              TextField(
                style: const TextStyle(color: Colors.white),

                controller: controller.endDateController,
                readOnly: true, // Prevent manual input
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.white),
                  floatingLabelStyle: TextStyle(color: Colors.white),
                  labelText: 'End Date',
                  prefixIcon: Icon(Iconsax.calendar, color: Colors.white),
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
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
                    backgroundColor: TColors.textLight,
                    foregroundColor: TColors.textDark,
                    side: BorderSide(
                        color: Colors.white, // Border color of the button
                        width: 2.0),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    minimumSize: const Size(double.infinity, 10),
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
