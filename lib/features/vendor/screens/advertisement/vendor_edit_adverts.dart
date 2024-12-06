import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:intl/intl.dart';

class EditAdPage extends StatelessWidget {
  final Advertisement ad;

  // Constructor for the EditAdPage
  EditAdPage({required this.ad}) {
    final advertController = AdvertController.instance;

    // Ensure the advertisement data is set properly
    advertController.advertisment.value = ad;
    advertController.initalizeNames(); // Initialize text fields
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final advertController = AdvertController.instance;
    final vendorController = VendorController.instance;

    // Initialize the controllers with the data from `ad`
    advertController.detailUpdateController.text = ad.detail;
    advertController.startDateUpdateController.text =
        ad.startDate != null ? dateFormat.format(ad.startDate!) : '';
    advertController.endDateUpdateController.text =
        ad.endDate != null ? dateFormat.format(ad.endDate!) : '';

    // Function to show the date picker and update the text field
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
        title: Text(
          'Edit Advertisement',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: advertController.updateForm,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Ad for ${ad.cafeName}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),

              // Detail Field
              TextFormField(
                controller: advertController.detailUpdateController,
                decoration: InputDecoration(
                  labelText: 'Detail',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              SizedBox(height: 20),

              // Start Date Field
              TextFormField(
                controller: advertController.startDateUpdateController,
                readOnly: true, // Prevent manual input
                decoration: InputDecoration(
                  labelText: 'Start Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onTap: () => _selectDate(
                    context, advertController.startDateUpdateController),
              ),
              SizedBox(height: 20),

              // End Date Field
              TextFormField(
                controller: advertController.endDateUpdateController,
                readOnly: true, // Prevent manual input
                decoration: InputDecoration(
                  labelText: 'End Date',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today), // Calendar icon
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onTap: () => _selectDate(
                    context, advertController.endDateUpdateController),
              ),
              SizedBox(height: 30),

              // Inside the body of your Form widget
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Other widgets like the title, TextFormFields, etc.

                  SizedBox(height: 30),

                  // Centering the Save and Delete Buttons
                  Center(
                    child: Column(
                      children: [
                        // Save Button
                        ElevatedButton(
                          onPressed: () async {
                            await advertController.updateAds(
                                vendorController.currentUserId,
                                ad.cafeId,
                                ad.id);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: Text(
                            'Save Changes',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        SizedBox(height: 20), // Spacing between buttons

                        // Delete Button
                        ElevatedButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
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
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
