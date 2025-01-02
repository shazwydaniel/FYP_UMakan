import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fyp_umakan/features/authentication/screens/login/login.dart';
import 'package:fyp_umakan/features/authority/controller/authority_controller.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class AuthorityProfilePage extends StatelessWidget {
  AuthorityProfilePage({super.key});

  final AuthorityController _controller = Get.put(AuthorityController());

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
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: TColors.cream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello,',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Obx(() {
                    final profile = _controller.profileData.value;
                    return Text(
                      profile['Username'] ?? 'Authority',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Account Details Label
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.bubbleBlue,
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
            ),
            const SizedBox(height: 15),

            // Account Details (Frosted Glass Card)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.4),
                            width: 1.5,
                          ),
                        ),
                        child: Obx(() {
                          final profile = _controller.profileData.value;
                          if (profile.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _profileDetail(
                                  title: "Username",
                                  value: profile['Username'],
                                  dark: dark,
                                ),
                                const SizedBox(height: 15),
                                _profileDetail(
                                  title: "Email",
                                  value: profile['Email'],
                                  dark: dark,
                                ),
                                const SizedBox(height: 15),
                                _profileDetail(
                                  title: "ID",
                                  value: profile['Id'],
                                  dark: dark,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Logout Button
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 40),
              child: Center(
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
            ),
          ],
        ),
      ),
    );
  }

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