// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/SubPages/admin_cafe_sub.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/admin_vendor_cafe_edit.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:get/get.dart';

class VendorDetailsPage extends StatefulWidget {
  final Map<String, dynamic> vendorData;

  VendorDetailsPage({required this.vendorData});

  @override
  _VendorDetailsPageState createState() => _VendorDetailsPageState();
}

class _VendorDetailsPageState extends State<VendorDetailsPage> {
  late Stream<QuerySnapshot> _cafeStream;
  final VendorController _vendorController = Get.put(VendorController());
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _cafeStream = FirebaseFirestore.instance
        .collection('Vendors')
        .doc(widget.vendorData['Id'])
        .collection('Cafe')
        .snapshots();
  }

  // Delete Cafe Dialog
  void _deleteCafe(String cafeId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: TColors.cream,
        title: const Text('Delete Cafe'),
        content: const Text('Are you sure you want to delete this cafe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: TColors.amber)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await FirebaseFirestore.instance
            .collection('Vendors')
            .doc(widget.vendorData['Id'])
            .collection('Cafe')
            .doc(cafeId)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cafe deleted successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete cafe: $e')),
        );
      }
    }
  }

  // Add Cafe Dialog
  void _addCafePopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: const Text('Add Cafe'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  TextField(
                    controller: _vendorController.cafeName,
                    decoration: const InputDecoration(labelText: 'Cafe Name'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _vendorController.cafeLocation,
                    decoration:
                        const InputDecoration(labelText: 'Cafe Location'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _vendorController.openingTime,
                    decoration:
                        const InputDecoration(labelText: 'Opening Time'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _vendorController.closingTime,
                    decoration:
                        const InputDecoration(labelText: 'Closing Time'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child:
                  const Text('Cancel', style: TextStyle(color: TColors.amber)),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final cafeData = {
                      'cafeName': _vendorController.cafeName.text.trim(),
                      'cafeLocation':
                          _vendorController.cafeLocation.text.trim(),
                      'openingTime': _vendorController.openingTime.text.trim(),
                      'closingTime': _vendorController.closingTime.text.trim(),
                    };

                    await _vendorController.addCafe(widget.vendorData['Id'],
                        null); // Add imageUrl if needed

                    Navigator.pop(context); // Close the popup on success
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cafe added successfully')),
                    );
                  } catch (e) {
                    Navigator.pop(context); // Close the popup on error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to add cafe: $e')),
                    );
                  }
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Main Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream,
      appBar: AppBar(
        backgroundColor: TColors.cream,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.vendorData['Vendor Name'] ?? 'Vendor Details',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 22),

            _sectionHeader('Cafes List', TColors.vermillion),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _cafeStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No cafes found.'));
                  }

                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final cafeDoc = snapshot.data!.docs[index];
                      final cafeData = cafeDoc.data() as Map<String, dynamic>;

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CafeSubPage(
                                cafeId: cafeData['cafe_ID'],
                                vendorId: widget.vendorData['Id'],
                                cafeName: cafeData['cafeName'],
                              ),
                            ),
                          );
                        },
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            cafeData['cafeName'] ?? 'No Name',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          Text(
                                            cafeData['cafeLocation'] ??
                                                'No Location',
                                            style: TextStyle(
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
                                        if (value == 'Edit') {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AdminVendorCafeEdit(
                                                cafeData: cafeData,
                                                vendorId:
                                                    widget.vendorData['Id'],
                                              ),
                                            ),
                                          );
                                        } else if (value == 'Delete') {
                                          _deleteCafe(cafeDoc.id);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'Edit',
                                          child: Text('Edit'),
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: TColors.vermillion,
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
                onPressed: () => _addCafePopup(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Section Header Widget
  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 4,
            height: 40,
            color: color,
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
