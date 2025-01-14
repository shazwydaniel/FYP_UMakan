// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp_umakan/data/repositories/authentication/authentication_repository.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:get/get.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    Get.offAllNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    // Get the current admin ID from FirebaseAuth
    final currentAdminId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: TColors.cream,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              const SizedBox(height: 60),
              Text(
                'Admin',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.black : Colors.black,
                ),
              ),
              Text(
                'Profile Page',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: dark ? Colors.black : Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Account Details Label
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.charcoal,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Account Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Fetch and display admin details
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Admins')
                    .doc(currentAdminId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return Center(
                      child: Text(
                        'Error fetching admin data.',
                        style: TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  final adminData = snapshot.data!.data() as Map<String, dynamic>;

                  return SizedBox(
                    width: double.infinity,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.4),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _profileDetail(
                            title: 'Name',
                            value: adminData['Admin Name'] ?? 'N/A',
                            dark: dark,
                          ),
                          const SizedBox(height: 15),
                          _profileDetail(
                            title: 'Email',
                            value: adminData['Admin Email'] ?? 'N/A',
                            dark: dark,
                          ),
                          const SizedBox(height: 15),
                          _profileDetail(
                            title: 'Role',
                            value: adminData['Role'] ?? 'N/A',
                            dark: dark,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 40),

              // Logout Button
              Center(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    color: TColors.amber,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  child: TextButton(
                    onPressed: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: TColors.cream,
                            title: const Text('Confirm Logout'),
                            content: const Text('Are you sure you want to log out?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(false),
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(true),
                                child: Text(
                                  'Log Out',
                                  style: TextStyle(
                                    color: TColors.amber,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        await AuthenticatorRepository.instance.logout();
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, color: Colors.white, size: 20),
                        const SizedBox(width: 10),
                        Text(
                          'Logout',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Profile Detail
  Widget _profileDetail({required String title, required String value, required bool dark}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: dark ? Colors.black54 : Colors.black54,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: dark ? Colors.black : Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}