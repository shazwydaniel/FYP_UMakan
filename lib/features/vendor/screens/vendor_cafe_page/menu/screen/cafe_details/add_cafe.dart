import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/validators/validation.dart';
import 'package:iconsax/iconsax.dart';

class AddCafe extends StatelessWidget {
  AddCafe({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = VendorController.instance;

    // Clear the form fields when the AddCafe page is opened
    controller.cafeName.clear();
    controller.cafeLocation.clear();
    controller.openingTime.clear();
    controller.closingTime.clear();

    // Function to show a time picker
    Future<void> _selectTime(
        BuildContext context, TextEditingController timeController) async {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        // Format time as HH:mm
        timeController.text =
            pickedTime.format(context); // Localized time format
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Cafe'),
        backgroundColor: TColors.olive,
      ),
      backgroundColor: TColors.olive,
      body: SingleChildScrollView(
        // Wrap the Column in a SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: controller.cafeFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: controller.cafeName,
                  validator: (value) =>
                      TValidator.validateEmptyText('Cafe Name', value),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Cafe Name',
                    prefixIcon: Icon(
                      Iconsax.home,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Underline color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Underline color when focused
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: controller.cafeLocation,
                  validator: (value) =>
                      TValidator.validateEmptyText('Cafe Location', value),
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Cafe Location',
                    prefixIcon: Icon(
                      Iconsax.location,
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Underline color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Underline color when focused
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Opening Time Field
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: controller.openingTime,
                  readOnly: true, // Prevent manual input
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Opening Time',
                    prefixIcon: Icon(
                      Iconsax.clock,
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Underline color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Underline color when focused
                    ),
                  ),
                  onTap: () => _selectTime(context, controller.openingTime),
                ),
                const SizedBox(height: 16),

                // Closing Time Field
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: controller.closingTime,
                  readOnly: true, // Prevent manual input
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Closing Time',
                    prefixIcon: Icon(
                      Iconsax.clock,
                      color: Colors.white,
                    ),
                    suffixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color:
                              Colors.white), // Underline color when not focused
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.white), // Underline color when focused
                    ),
                  ),
                  onTap: () => _selectTime(context, controller.closingTime),
                ),
                const SizedBox(height: 20),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (controller.cafeFormKey.currentState?.validate() ??
                          false) {
                        // Add cafe
                        await controller.addCafe(controller.getCurrentUserId());

                        // Clear the form fields
                        controller.cafeFormKey.currentState?.reset();
                        Navigator.pop(context, true);

                        // Fetch updated list of cafes
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: TColors.olive,
                      backgroundColor: TColors.textLight,
                    ),
                    child: const Text('Save'),
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
