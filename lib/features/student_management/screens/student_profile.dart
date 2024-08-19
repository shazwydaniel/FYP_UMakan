import "package:flutter/material.dart";
import "package:fyp_umakan/data/repositories/authentication/authentication_repository.dart";
import "package:fyp_umakan/utils/constants/colors.dart";
import "package:fyp_umakan/utils/helpers/helper_functions.dart";
import "package:get/get.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_navigation/src/snackbar/snackbar.dart";
import "package:iconsax/iconsax.dart";

class StudentProfilePageScreen extends StatelessWidget {
  const StudentProfilePageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

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
                    'Hello',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                  Text(
                    'Ahmad Shazwy!',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Personal Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.teal,
                  ),
                  const SizedBox(width: 10), // Space between the line and text
                  Text(
                    'Personal Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.normal,
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
                  // First Card
                  Container(
                    height: 150, // Height of the rectangle card
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Name, Matrics Number, Email',
                        style: TextStyle(
                          color: dark ? Colors.black : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Financial Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.cobalt,
                  ),
                  const SizedBox(width: 10), // Space between the line and text
                  Text(
                    'Financial Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.normal,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Financial Details (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  // First Card
                  Container(
                    height: 150, // Height of the rectangle card
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Monthly Allowance',
                        style: TextStyle(
                          color: dark ? Colors.black : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Second Card
                  Container(
                    height: 150, // Height of the rectangle card
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Monthly Committments',
                        style: TextStyle(
                          color: dark ? Colors.black : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Health Details (Label)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 4, // Thin vertical line width
                    height: 40, // Adjust the height as needed
                    color: TColors.amber,
                  ),
                  const SizedBox(width: 10), // Space between the line and text
                  Text(
                    'Health Details',
                    style: TextStyle(
                      fontSize: 16, // Adjust the font size as needed
                      fontWeight: FontWeight.normal,
                      color: dark ? Colors.white : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            // Health Details (Cards)
            Padding(
              padding: const EdgeInsets.only(left: 40, right: 40, top: 20),
              child: Column(
                children: [
                  // First Card
                  Container(
                    height: 150, // Height of the rectangle card
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: TColors.cream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Weight, Height, Birthdate',
                        style: TextStyle(
                          color: dark ? Colors.black : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            //Logout button (Button)
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Center(
                child: OutlinedButton(
                  onPressed: () async {
                    try {
                      await AuthenticatorRepository.instance.logout();
                    } catch (e) {
                      Get.snackbar(
                        'Logout Error',
                        e.toString(),
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
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
