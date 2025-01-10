// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
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
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: TColors.blush,
        child: Container(
          height: 80.0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    _showAddUserDialog(context);
                  },
                  backgroundColor: TColors.cream,
                  child: const Icon(Icons.add, color: TColors.gunmetal),
                ),
                const SizedBox(height: 5),
                Text(
                  'Add New User',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: TColors.cream,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Add User Dialog
  void _showAddUserDialog(BuildContext context) {
    final organisationNameController = TextEditingController();
    final emailController = TextEditingController();
    final contactNumberController = TextEditingController();
    final locationController = TextEditingController();
    final telegramHandleController = TextEditingController();

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
                await FirebaseFirestore.instance
                    .collection('SupportOrganisation')
                    .add({
                  'Organisation Name': organisationNameController.text,
                  'Email': emailController.text,
                  'Contact Number': contactNumberController.text,
                  'Location': locationController.text,
                  'Telegram Handle': telegramHandleController.text,
                  'Role': 'Support Organisation',
                  'Active Status': 'Active',
                });
                Navigator.of(context).pop();
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
                await FirebaseFirestore.instance
                    .collection('SupportOrganisation')
                    .doc(userId)
                    .delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: TColors.amber)),
            ),
          ],
        );
      },
    );
  }
}