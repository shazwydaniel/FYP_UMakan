// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:iconsax/iconsax.dart';

class SupportOrganisationProfilePage extends StatelessWidget {
  const SupportOrganisationProfilePage({super.key});

  Future<void> _logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      print("Error logging out: $e");
      Get.snackbar("Error", "Failed to log out. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.cream, // Set background color
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Ensures minimal height for the column
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundImage:
                    AssetImage('assets/images/default_profile_icon.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Support Organisation Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'email@example.com',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 40),
              Container(
                width: 200, // Button width
                height: 50, // Button height
                decoration: BoxDecoration(
                  color: TColors.amber, // Original button color
                  borderRadius: BorderRadius.circular(20.0),
                  border: Border.all(
                    color: Colors.black,
                    width: 2.0,
                  ),
                ),
                child: TextButton(
                  onPressed: _logOut,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Iconsax.logout, color: Colors.white, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        'Log Out',
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
            ],
          ),
        ),
      ),
    );
  }
}