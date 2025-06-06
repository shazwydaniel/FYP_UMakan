// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:ui';

import 'package:iconsax/iconsax.dart';

class AdminSupportorg extends StatelessWidget {
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
            // Page Title
            Text(
              'Let\'s Manage',
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

            _sectionHeader('Users List', TColors.blush),

            // User List
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('SupportOrganisation')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error fetching data.'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No support organisations found.'),
                    );
                  }

                  final users = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return Padding(
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
                                    backgroundImage:
                                        NetworkImage(user['Profile Picture']),
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['Organisation Name'],
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          user['Email'],
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    color: TColors.cream, // Set the background color of the popup menu
                                    onSelected: (value) {
                                      if (value == 'Edit') {
                                        _showEditUserDialog(context, user);
                                      } else if (value == 'Delete') {
                                        _confirmDeleteUser(context, user.id);
                                      }
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'Edit',
                                        child: Row(
                                          children: [
                                            Text('Edit'),
                                            // const SizedBox(width: 10),
                                            // Icon(Iconsax.edit, color: TColors.forest), 
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            Text('Delete'),
                                            // const SizedBox(width: 10),
                                            // Icon(Iconsax.trash, color: TColors.vermillion), 
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
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // Bottom Navbar 
      bottomNavigationBar: BottomAppBar(
        color: TColors.blush,
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: SizedBox(
          height: 80.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Iconsax.add_circle, color: Colors.white, size: 40),
                onPressed: () {
                  _showAddUserDialog(context);
                },
              ),
              // Text(
              //   'Add New User',
              //   style: TextStyle(
              //     fontSize: 12,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.white,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  // Add User Dialog
  void _showAddUserDialog(BuildContext context) {
    final organisationNameController = TextEditingController();
    final emailController = TextEditingController();
    final contactNumberController = TextEditingController();
    final locationController = TextEditingController();
    final telegramHandleController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Add Support Organisation'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextField(
                  controller: organisationNameController,
                  decoration: InputDecoration(labelText: 'Organisation Name'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: contactNumberController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: telegramHandleController,
                  decoration: InputDecoration(labelText: 'Telegram Handle'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: TColors.amber)),
            ),
            TextButton(
              onPressed: () async {
                try {
                  // Create the user in Firebase Authentication
                  final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );

                  // Use the UID as the Firestore document ID
                  final userId = userCredential.user!.uid;

                  // Add the user data to Firestore with the UID as the document ID
                  await FirebaseFirestore.instance
                      .collection('SupportOrganisation')
                      .doc(userId) // Explicitly set the document ID
                      .set({
                    'Id': userId, // Save the UID in the document
                    'Organisation Name': organisationNameController.text.trim(),
                    'Email': emailController.text.trim(),
                    'Contact Number': contactNumberController.text.trim(),
                    'Location': locationController.text.trim(),
                    'Telegram Handle': telegramHandleController.text.trim(),
                    'Role': 'Support Organisation',
                    'Active Status': 'Active',
                    'Profile Picture': '', // Initialize as empty
                  });

                  Get.snackbar(
                    "Success",
                    "User is Successfully Registered!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );

                  Navigator.of(context).pop();
                } catch (e) {
                  // Handle errors
                  Get.snackbar(
                    "Failed",
                    "User Registeration Failed!",
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                  print('Error adding Support Organisation: $e');
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Edit User Dialog
  void _showEditUserDialog(BuildContext context, QueryDocumentSnapshot user) {
    final organisationNameController =
        TextEditingController(text: user['Organisation Name']);
    final emailController = TextEditingController(text: user['Email']);
    final contactNumberController =
        TextEditingController(text: user['Contact Number']);
    final locationController = TextEditingController(text: user['Location']);
    final telegramHandleController =
        TextEditingController(text: user['Telegram Handle']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Edit Support Organisation'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextField(
                  controller: organisationNameController,
                  decoration: InputDecoration(labelText: 'Organisation Name'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: contactNumberController,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: locationController,
                  decoration: InputDecoration(labelText: 'Location'),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: telegramHandleController,
                  decoration: InputDecoration(labelText: 'Telegram Handle'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(color: TColors.amber)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('SupportOrganisation')
                    .doc(user.id)
                    .update({
                  'Organisation Name': organisationNameController.text,
                  'Email': emailController.text,
                  'Contact Number': contactNumberController.text,
                  'Location': locationController.text,
                  'Telegram Handle': telegramHandleController.text,
                });
                Get.snackbar(
                  "Success",
                  "User's Details Are Updated Successfully!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save', style: TextStyle(color: Colors.green)),
            ),
          ],
        );
      },
    );
  }

  // Confirm Delete User Dialog
  void _confirmDeleteUser(BuildContext context, String userId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Delete User'),
          content: Text('Are you sure you want to delete this user?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
               child: Text('Cancel', style: TextStyle(color: Colors.green)),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance.collection('SupportOrganisation').doc(userId).delete();
                Get.snackbar(
                  "Success",
                  "Account Successfully Deleted!",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: TColors.amber)),
            ),
          ],
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