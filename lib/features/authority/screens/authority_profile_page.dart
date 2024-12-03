// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:iconsax/iconsax.dart';

class AuthorityProfilePage extends StatelessWidget {
  const AuthorityProfilePage({super.key});

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
        child: Container(
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
      ),
    );
  }
}