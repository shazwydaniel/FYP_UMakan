// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/features/authentication/screens/login/login.dart";
import "package:fyp_umakan/features/vendor/controller/vendor_controller.dart";
import "package:fyp_umakan/features/vendor/screens/profile/vendor_details_edit.dart";
import "package:fyp_umakan/features/vendor/screens/vendor_register.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:get/get.dart";
import "package:get/get_navigation/src/snackbar/snackbar.dart";
import "package:iconsax/iconsax.dart";

class VendorProfilePageScreen extends StatelessWidget {
  const VendorProfilePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    final controller = Get.put(VendorController());

    return Scaffold(
      backgroundColor: TColors.bubbleOrange,
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
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  Obx(
                    () => Text(
                      "${controller.vendor.value.vendorName}!",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: dark ? Colors.white : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Personal Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.teal,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Personal Details (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate to the new page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VendorDetailsEdit()),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      color: TColors.cream,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Vendor Name
                                  Text(
                                    controller.vendor.value.vendorName,
                                    style: TextStyle(
                                      color: dark ? Colors.black : Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Vendor Email
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.vendor.value.vendorEmail,
                                      style: TextStyle(
                                        color:
                                            dark ? Colors.black : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Vendor Contact Info
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 5.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      controller.vendor.value.contactInfo,
                                      style: TextStyle(
                                        color:
                                            dark ? Colors.black : Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Business Revenue (if applicable)
                                ],
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

            // Logout button
            Padding(
              padding: const EdgeInsets.only(top: 40, bottom: 20),
              child: Center(
                child: OutlinedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: TColors.cream,
                          title: Text('Confirm Logout'),
                          content: Text('Are you sure you want to log out?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                Navigator.of(context).pop();
                                try {
                                  await AuthenticatorRepository.instance
                                      .logout();

                                  print("Logged Out from Vendor Account");
                                } catch (e) {
                                  Get.snackbar(
                                    'Logout Error',
                                    e.toString(),
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                              child: Text('Log Out'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: TColors.amber),
                    backgroundColor: TColors.amber,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Logout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Iconsax.logout, color: Colors.white, size: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
