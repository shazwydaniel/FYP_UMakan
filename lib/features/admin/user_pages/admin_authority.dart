// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class AdminAuthority extends StatelessWidget {
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
              'Authorities',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),

            const SizedBox(height: 22),

            // User List (Fetch from 'Authority' Collection in Firebase)
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Authority')
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
                      child: Text('No authorities found.'),
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
                                    child: Text(
                                      user['Username'][0].toUpperCase(),
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: TColors.stark_blue,
                                    radius: 30,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user['Username'],
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
                                    color: TColors.cream, // Popup background
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
                                            // Icon(Iconsax.edit, color: TColors.forest),
                                            // const SizedBox(width: 10),
                                            Text('Edit'),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'Delete',
                                        child: Row(
                                          children: [
                                            // Icon(Iconsax.trash, color: TColors.vermillion),
                                            // const SizedBox(width: 10),
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
        color: TColors.stark_blue,
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
    final usernameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Add Authority'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
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
                  await FirebaseFirestore.instance.collection('Authority').doc(userId).set({
                    'Id': userId, // Save the UID in the document
                    'Username': usernameController.text.trim(),
                    'Email': emailController.text.trim(),
                    'Role': 'Authority',
                  });

                  Navigator.of(context).pop();
                } catch (e) {
                  // Handle errors
                  print('Error adding authority: $e');
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
    final usernameController = TextEditingController(text: user['Username']);
    final emailController = TextEditingController(text: user['Email']);
    // final passwordController = TextEditingController(text: user['Password']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: TColors.cream,
          title: Text('Edit Authority'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                // const SizedBox(height: 10),
                // TextField(
                //   controller: passwordController,
                //   decoration: InputDecoration(labelText: 'Password'),
                //   obscureText: true,
                // ),
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
                await FirebaseFirestore.instance.collection('Authority').doc(user.id).update({
                  'Username': usernameController.text,
                  'Email': emailController.text,
                  // 'Password': passwordController.text,
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
                await FirebaseFirestore.instance.collection('Authority').doc(userId).delete();
                Navigator.of(context).pop();
              },
              child: Text('Delete', style: TextStyle(color: TColors.vermillion)),
            ),
          ],
        );
      },
    );
  }
}