import 'dart:ui';

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

  void _addVendor(BuildContext context) {
    final vendorNameController = TextEditingController();
    final vendorEmailController = TextEditingController();
    final vendorPasswordController = TextEditingController();
    final contactInfoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: const Text('Add Vendor'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextField(
                  controller: vendorNameController,
                  decoration: const InputDecoration(labelText: 'Vendor Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: vendorEmailController,
                  decoration: const InputDecoration(labelText: 'Vendor Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: vendorPasswordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactInfoController,
                  decoration: const InputDecoration(labelText: 'Contact Info'),
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
              child:
                  const Text('Cancel', style: TextStyle(color: TColors.amber)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseFirestore.instance.collection('Vendors').add({
                    'Vendor Name': vendorNameController.text,
                    'Vendor Email': vendorEmailController.text,
                    'Password': vendorPasswordController.text,
                    'Contact Info': contactInfoController.text,
                  });
                  Navigator.of(context).pop(); // Close the dialog on success
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Vendor added successfully')),
                  );
                } catch (e) {
                  Navigator.of(context).pop(); // Close the dialog on error
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to add vendor: $e')),
                  );
                }
              },
              child: const Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

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
            'Support Organisations',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 22),

          // Expanded to ensure the list takes up remaining space
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
                                    color: TColors
                                        .cream, // Set the background color of the popup menu
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
        color: Colors.orange,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorRegisterPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
