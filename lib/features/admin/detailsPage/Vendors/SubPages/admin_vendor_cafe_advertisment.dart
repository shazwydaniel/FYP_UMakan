import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AdminAdvertisementsPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;

  AdminAdvertisementsPage({required this.vendorId, required this.cafeId});

  final AdvertController advertController = Get.put(AdvertController());
  final DateFormat dateFormat = DateFormat('dd MMM yyyy'); // Date formatter

  @override
  Widget build(BuildContext context) {
    // Fetch advertisements for the specific cafe when the page loads
    advertController.fetchAdvertisementsByCafe(vendorId, cafeId);

    return Scaffold(
      backgroundColor: TColors.textLight,
      appBar: AppBar(
        title: const Text('Advertisements'),
        backgroundColor: TColors.amber,
      ),
      body: Obx(() {
        if (advertController.allAdvertisements.isEmpty) {
          return const Center(
            child: Text(
              'No advertisements available.',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          itemCount: advertController.allAdvertisements.length,
          itemBuilder: (context, index) {
            final ad = advertController.allAdvertisements[index];
            return Card(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                title: Text(
                  ad.detail,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "From: ${ad.startDate != null ? dateFormat.format(ad.startDate!) : 'N/A'}\n"
                  "Until: ${ad.endDate != null ? dateFormat.format(ad.endDate!) : 'N/A'}",
                  style: const TextStyle(fontSize: 14),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _showDeleteConfirmationDialog(context, ad.id);
                  },
                ),
                onTap: () => _showUpdateAdDialog(context, ad),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: TColors.amber,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: IconButton(
          icon: const Icon(Icons.add, size: 40, color: Colors.white),
          onPressed: () => _showAddAdDialog(context),
          tooltip: 'Add Advertisement',
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String adId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Advertisement'),
          content: const Text(
              'Are you sure you want to delete this advertisement? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await advertController.deleteAd(vendorId, cafeId, adId);
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showAddAdDialog(BuildContext context) {
    advertController.adDetail.clear();
    advertController.startDateController.clear();
    advertController.endDateController.clear();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Advertisement'),
          content: Form(
            key: advertController.menuFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: advertController.adDetail,
                  decoration: const InputDecoration(labelText: 'Detail'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Detail is required'
                      : null,
                ),
                TextField(
                  controller: advertController.startDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(
                      context, advertController.startDateController),
                ),
                TextField(
                  controller: advertController.endDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () =>
                      _selectDate(context, advertController.endDateController),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (advertController.menuFormKey.currentState?.validate() ??
                    false) {
                  await advertController.addAdvert(vendorId, cafeId);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showUpdateAdDialog(BuildContext context, Advertisement ad) {
    advertController.detailUpdateController.text = ad.detail;
    advertController.startDateUpdateController.text =
        ad.startDate?.toLocal().toString().split(' ')[0] ?? '';
    advertController.endDateUpdateController.text =
        ad.endDate?.toLocal().toString().split(' ')[0] ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Advertisement'),
          content: Form(
            key: advertController.updateForm,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: advertController.detailUpdateController,
                  decoration: const InputDecoration(labelText: 'Detail'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Detail is required'
                      : null,
                ),
                TextField(
                  controller: advertController.startDateUpdateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Start Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(
                      context, advertController.startDateUpdateController),
                ),
                TextField(
                  controller: advertController.endDateUpdateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'End Date',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(
                      context, advertController.endDateUpdateController),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (advertController.updateForm.currentState?.validate() ??
                    false) {
                  await advertController.updateAds(vendorId, cafeId, ad.id);
                  Navigator.pop(context);
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = picked.toLocal().toString().split(' ')[0];
    }
  }
}
