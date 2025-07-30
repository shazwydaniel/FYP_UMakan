import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

class EditAdPage extends StatelessWidget {
  final Advertisement ad;

  // Constructor for the EditAdPage
  EditAdPage({required this.ad}) {
    final advertController = AdvertController.instance;
    advertController.advertisment.value = ad;
    advertController.selectedStatus.value = ad.status;
    advertController.initalizeNames();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final advertController = AdvertController.instance;
    final vendorController = VendorController.instance;

    advertController.detailUpdateController.text = ad.detail;
    advertController.startDateUpdateController.text =
        ad.startDate != null ? dateFormat.format(ad.startDate!) : '';
    advertController.endDateUpdateController.text =
        ad.endDate != null ? dateFormat.format(ad.endDate!) : '';

    Future<void> _selectDate(
        BuildContext context, TextEditingController controller) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );

      if (picked != null) {
        controller.text = dateFormat.format(picked); // Format as 'YYYY-MM-DD'
      }
    }

    // Function to show the delete confirmation dialog
    void _showDeleteConfirmationDialog(BuildContext context) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Confirm Delete',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ],
            ),
            content: Text(
              'Are you sure you want to delete this advertisement?',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await advertController.deleteAd(
                      vendorController.currentUserId, ad.cafeId, ad.id);
                  Navigator.pop(context); // Close the dialog
                  Navigator.pop(context); // Return to the previous page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(
                      horizontal: 25, vertical: 10), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  'Delete',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColors.amber,
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back arrow
        ),
      ),
      backgroundColor: TColors.amber,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Form(
            key: advertController.updateForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Edit Advertisement for ${ad.cafeName}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Detail Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: advertController.detailUpdateController,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter advertisement details'
                      : null,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.white),
                    floatingLabelStyle: TextStyle(color: Colors.white),
                    labelText: 'Advertisement Details',
                    prefixIcon: Icon(Iconsax.edit, color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Start Date Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: advertController.startDateUpdateController,
                  readOnly: true,
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
                  onTap: () => _selectDate(
                      context, advertController.startDateUpdateController),
                ),
                const SizedBox(height: 16),

                // End Date Field
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: advertController.endDateUpdateController,
                  readOnly: true,
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
                  onTap: () => _selectDate(
                      context, advertController.endDateUpdateController),
                ),
                const SizedBox(height: 25),

                Obx(() => DropdownButtonFormField<String>(
                      value: advertController.selectedStatus.value,
                      dropdownColor: TColors.amber,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        labelStyle: TextStyle(color: Colors.white),
                        floatingLabelStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      ),
                      items: ['Promotion', 'Bantuan'].map((status) {
                        return DropdownMenuItem<String>(
                          value: status,
                          child: Text(status,
                              style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        if (newValue != null) {
                          advertController.selectedStatus.value = newValue;
                        }
                      },
                    )),
                const SizedBox(height: 25),

                Center(
                  child: Column(
                    children: [
                      // Save Button
                      ElevatedButton(
                        onPressed: () async {
                          await advertController.updateAds(
                              vendorController.currentUserId, ad.cafeId, ad.id);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.textLight,
                          foregroundColor: TColors.textDark,
                          side: BorderSide(color: Colors.white, width: 2.0),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          minimumSize: const Size(double.infinity, 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Save Changes',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Delete Button
                      ElevatedButton(
                        onPressed: () => _showDeleteConfirmationDialog(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.black,
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
                        child: const Text(
                          'Delete Advertisement',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
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
