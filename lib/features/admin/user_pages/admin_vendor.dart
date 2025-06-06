// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/features/admin/detailsPage/Vendors/admin_vendor_details.dart';
import 'package:fyp_umakan/features/vendor/screens/vendor_register.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:get/get.dart';

class AdminVendor extends StatefulWidget {
  @override
  _AdminVendor createState() => _AdminVendor();
}

class _AdminVendor extends State<AdminVendor> {
  late Stream<QuerySnapshot> _vendorsStream;
  final VendorController _vendorController = Get.put(VendorController());

  @override
  void initState() {
    super.initState();
    _vendorsStream =
        FirebaseFirestore.instance.collection('Vendors').snapshots();
  }

  // Edit User Dialog
  void _showEditVendorDialog(BuildContext context, String vendorId) {
    final vendorNameController = TextEditingController();
    final vendorEmailController = TextEditingController();
    final contactInfoController = TextEditingController();

    FirebaseFirestore.instance
        .collection('Vendors')
        .doc(vendorId)
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>;
        vendorNameController.text = data['Vendor Name'] ?? '';
        vendorEmailController.text = data['Vendor Email'] ?? '';
        contactInfoController.text = data['Contact Info'] ?? '';

        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              backgroundColor: TColors.cream,
              title: const Text('Edit Vendor'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    TextField(
                      controller: vendorNameController,
                      decoration:
                          const InputDecoration(labelText: 'Vendor Name'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: vendorEmailController,
                      decoration:
                          const InputDecoration(labelText: 'Vendor Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: contactInfoController,
                      decoration:
                          const InputDecoration(labelText: 'Contact Info'),
                      keyboardType: TextInputType.phone,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel',
                      style: TextStyle(color: TColors.amber)),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('Vendors')
                          .doc(vendorId)
                          .update({
                        'Vendor Name': vendorNameController.text,
                        'Vendor Email': vendorEmailController.text,
                        'Contact Info': contactInfoController.text,
                      });

                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Vendor updated successfully')),
                      );
                    } catch (e) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to update vendor: $e')),
                      );
                    }
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.green)),
                ),
              ],
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vendor not found')),
        );
      }
    }).catchError((e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch vendor details: $e')),
      );
    });
  }

  // Delete User Dialog
  void _deleteVendor(BuildContext context, String vendorId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: const Text('Delete Vendor'),
          content: const Text('Are you sure you want to delete this vendor?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child:
                  const Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance
                      .collection('Vendors')
                      .doc(vendorId)
                      .delete();

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Vendor deleted successfully')),
                  );
                } catch (e) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete vendor: $e')),
                  );
                }
              },
              child:
                  const Text('Delete', style: TextStyle(color: TColors.amber)),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Page Title
          Text(
            'Lets Manage',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'Vendors',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 22),

          _sectionHeader('Users List', TColors.vermillion),

          // User List (Fetch from 'Vendors' Collection in Firebase)
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _vendorsStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No vendors found.'));
                }

                final vendors = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: vendors.length,
                  itemBuilder: (context, index) {
                    final vendorDoc = vendors[index];
                    final vendorData = vendorDoc.data() as Map<String, dynamic>;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                VendorDetailsPage(vendorData: vendorData),
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
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: TColors.vermillion,
                                    backgroundImage: vendorData[
                                                    'Profile Picture'] !=
                                                null &&
                                            vendorData['Profile Picture']
                                                .isNotEmpty
                                        ? NetworkImage(
                                                vendorData['Profile Picture'])
                                            as ImageProvider
                                        : null,
                                    child: vendorData['Profile Picture'] ==
                                                null ||
                                            vendorData['Profile Picture']
                                                .isEmpty
                                        ? Text(
                                            vendorData['Vendor Name'] != null &&
                                                    vendorData['Vendor Name']
                                                        .isNotEmpty
                                                ? vendorData['Vendor Name'][0]
                                                    .toUpperCase()
                                                : '',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          )
                                        : null,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          vendorData['Vendor Name'] ??
                                              'No Name',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          vendorData['Vendor Email'] ??
                                              'No Email',
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
                                        _showEditVendorDialog(
                                            context, vendorDoc.id);
                                      } else if (value == 'Delete') {
                                        _deleteVendor(context, vendorDoc.id);
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
                                      PopupMenuItem(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            Text('Delete'),
                                          ],
                                        ),
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
        ]),
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
                icon: Icon(Iconsax.add_circle, color: Colors.white, size: 40),
                onPressed: () {
                  _showAddVendorDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddVendorDialog(BuildContext context) {
    final vendorController = Get.put(VendorController());

    showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 550,
          width: 200,
          child: AlertDialog(
            backgroundColor: TColors.cream,
            title: Text('Add Vendor'),
            content: Form(
              key: vendorController.vendorFormKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: vendorController.vendorName,
                      decoration: InputDecoration(labelText: 'Vendor Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vendor name is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: vendorController.vendorEmail,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: vendorController.vendorPassword,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: vendorController.contactInfo,
                      decoration: InputDecoration(labelText: 'Contact Info'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Contact info is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: const BorderSide(color: Colors.black, width: 2.0),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10), // Space between buttons
                  // Register Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (vendorController.vendorFormKey.currentState
                                ?.validate() ??
                            false) {
                          try {
                            await vendorController.register();

                            Navigator.of(context).pop();
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "Failed to register vendor.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                        backgroundColor: TColors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Register',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
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
