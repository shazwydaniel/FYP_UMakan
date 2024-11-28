// ignore_for_file: prefer_const_constructors

import "package:flutter/material.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/features/vendor/controller/vendor_controller.dart";
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
                      // Add any action for tapping the card if needed
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
                                  Container(
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: TColors.cobalt,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Stack(
                                        children: [
                                          // Left-side text elements
                                          Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Monthly Revenue',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Expected Earnings',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              right: 2.0),
                                                      child: Text(
                                                        'RM',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    /*Obx(() {
                                                      // Format the value with up to 2 decimal places
                                                      String formattedRevenue =
                                                          controller
                                                                      .vendor
                                                                      .value
                                                                      .revenue !=
                                                                  null
                                                              ? NumberFormat(
                                                                      '0.00')
                                                                  .format(controller
                                                                      .vendor
                                                                      .value
                                                                      .revenue)
                                                              : '0.00';

                                                      return Text(
                                                        "$formattedRevenue",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 28,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      );
                                                    }),*/
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Right-side elements (Status)
                                          Positioned(
                                            bottom: 0,
                                            right: 0,
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                color: TColors.teal
                                                    .withOpacity(0.7),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Iconsax.chart_1,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                    'Active',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
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

            // Financial Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4,
                    height: 40,
                    color: TColors.cobalt,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'Financial Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Financial Details (Card)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                color: TColors.cream,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Business Revenue",
                        style: TextStyle(
                          color: dark ? Colors.black : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      /*Obx(
                        () => Text(
                          "RM10",
                          style: TextStyle(
                            color: TColors.darkGreen,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),
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
