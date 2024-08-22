import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';

class DiscoverPageScreen extends StatelessWidget {
  const DiscoverPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      backgroundColor: TColors.cream,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Container(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cafes &',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.black : Colors.black,
                    ),
                  ),
                  Text(
                    'Vendors',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: dark ? Colors.black : Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Browse for your meals and add them to your journal',
                    style: TextStyle(
                      fontSize: 15,
                      color: dark ? Colors.black : Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            // Grid of Cards
            GridView.builder(
              shrinkWrap: true, // Make the GridView wrap its content
              physics:
                  NeverScrollableScrollPhysics(), // Disable scrolling in the GridView
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two cards per row
                crossAxisSpacing: 10, // Space between columns
                mainAxisSpacing: 10, // Space between rows
                childAspectRatio: 1, // Square aspect ratio
              ),
              itemCount: 7, // Number of cards
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  padding: const EdgeInsets.all(15),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: Colors.white,
                    child: Center(
                      child: Text(
                        'KK${index + 1}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
