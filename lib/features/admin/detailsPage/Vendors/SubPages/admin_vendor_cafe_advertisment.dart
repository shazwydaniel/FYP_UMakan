import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_advert_controller.dart';
import 'package:fyp_umakan/features/vendor/model/advertisment/vendor_adverts_model.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class AdminAdvertisementsPage extends StatelessWidget {
  final String vendorId;
  final String cafeId;

  AdminAdvertisementsPage({required this.vendorId, required this.cafeId});

  final AdvertController advertController = Get.put(AdvertController());
  final DateFormat dateFormat = DateFormat('dd MMM yyyy');

  @override
  Widget build(BuildContext context) {
    advertController.fetchAdvertisementsByCafe(vendorId, cafeId);

    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
        title: const Text('Advertisements'),
      ),
      body: Obx(() {
        if (advertController.allAdvertisements.isEmpty) {
          return const Center(
            child: Text('No advertisements available.',
                style: TextStyle(fontSize: 16, color: Colors.black54)),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: ListView.builder(
            itemCount: advertController.allAdvertisements.length,
            itemBuilder: (context, index) {
              final ad = advertController.allAdvertisements[index];
              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    ad.detail,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "From: ${ad.startDate != null ? dateFormat.format(ad.startDate!) : 'N/A'}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    "Until: ${ad.endDate != null ? dateFormat.format(ad.endDate!) : 'N/A'}",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuButton<String>(
                              color: TColors.cream,
                              onSelected: (value) {
                                if (value == 'Delete') {
                                  _showDeleteConfirmationDialog(context, ad.id);
                                } else if (value == 'Edit') {
                                  _showUpdateAdDialog(context, ad);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'Edit',
                                  child: Row(
                                    children: [
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.red,
        shape: const CircularNotchedRectangle(),
        notchMargin: 0.0,
        child: Container(
          height: 60.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Iconsax.add_circle,
                    color: Colors.white, size: 40),
                onPressed: () => _showAddAdDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String adId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: const Text('Delete Advertisement'),
          content: const Text(
              'Are you sure you want to delete this advertisement? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                await advertController.deleteAd(vendorId, cafeId, adId);
                Navigator.pop(context);
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
          backgroundColor: TColors.cream,
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                if (advertController.menuFormKey.currentState?.validate() ??
                    false) {
                  await advertController.addAdvert(vendorId, cafeId);
                  Navigator.pop(context);
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.green)),
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
          backgroundColor: TColors.cream,
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
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            TextButton(
              onPressed: () async {
                if (advertController.updateForm.currentState?.validate() ??
                    false) {
                  await advertController.updateAds(vendorId, cafeId, ad.id);
                  Navigator.pop(context);
                }
              },
              child:
                  const Text('Update', style: TextStyle(color: Colors.green)),
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
