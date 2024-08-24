import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/cafes/model/cafe_details_model.dart';
import 'package:fyp_umakan/features/cafes/screens/cafe.dart';
import 'package:fyp_umakan/features/moneyjournal/screens/money_journal_main_page.dart';
import 'package:fyp_umakan/navigation_menu.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:bubble_lens/bubble_lens.dart';
import 'package:get/get.dart';

class DiscoverPageScreen extends StatelessWidget {
  const DiscoverPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    final List<CafeDetailsData> cafes = [
      CafeDetailsData(
          name: 'QBistro',
          logoPath: TImages.QBistro_Logo,
          details: 'QBistro serves a variety of meals and snacks.'),
      CafeDetailsData(
          name: 'Zus Coffee',
          logoPath: TImages.Zus_Logo,
          details: 'Zus Coffee is known for its artisanal coffee blends.'),
      CafeDetailsData(
          name: 'KK7 Cafe',
          logoPath: TImages.KK7_Logo,
          details: 'KK7 Cafe offers a variety of traditional meals.'),
      CafeDetailsData(
          name: 'KK8',
          logoPath: TImages.KK8_Logo,
          details: 'KK8 serves a variety of meals and snacks.'),
      CafeDetailsData(
          name: 'KK11',
          logoPath: TImages.KK11_Logo,
          details: 'KK11 Coffee is known for its artisanal coffee blends.'),
      CafeDetailsData(
          name: 'KK12 Cafe',
          logoPath: TImages.KK12_Logo,
          details: 'KK12 Cafe offers a variety of traditional meals.'),
    ];

    return Scaffold(
      backgroundColor: TColors.mustard,
      body: Stack(
        children: [
          // Title Section
          /*Container(
            padding: const EdgeInsets.only(left: 40, right: 40, top: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Cafes',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Browse for your meals and add them to your journal',
                  style: TextStyle(
                    fontSize: 15,
                    color: dark ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),*/

          // BubbleLens Section
          Positioned.fill(
            child: Container(
              color: TColors.mustard,
              height: MediaQuery.of(context).size.height -
                  500, // Set height dynamically

              child: BubbleLens(
                duration: const Duration(milliseconds: 100),
                width: MediaQuery.of(context).size.width,
                height:
                    MediaQuery.of(context).size.height, // Use available height
                widgets: cafes.map((cafe) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to the cafe details page
                      Get.to(() => CafePage(cafe: cafe));
                    },
                    child: Image.asset(cafe.logoPath),
                  );
                }).toList(),
              ),
            ),
          ),

          Positioned(
            top: 100, // Adjust this value to position the title as desired
            left: 40,
            right: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover Cafes',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: dark ? Colors.white : Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Browse for your meals and add them to your journal',
                  style: TextStyle(
                    fontSize: 15,
                    color: dark ? Colors.white : Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Spacer to push content to the center
          /*Expanded(
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: 150, // Set the width of the circular card
                      height: 150, // Set the height of the circular card
                      decoration: BoxDecoration(
                        color: TColors
                            .amber, // Background color of the circular card
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          "Kolej Kediaman",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: dark ? Colors.white : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Surrounding Circles
                  Positioned(
                    left:
                        150, // Center the circle horizontally near the left edge of central circle
                    top:
                        150, // Center the circle vertically near the top edge of central circle with some padding
                    child: Container(
                      width: 75, // Circle width
                      height: 75, // Circle height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                        color: Colors
                            .white, // Background color of the surrounding circle
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          TImages.QBistro_Logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right:
                        150, // Center the circle horizontally near the right edge of central circle with some padding
                    bottom:
                        150, // Center the circle vertically near the top edge of central circle with some padding
                    child: Container(
                      width: 75, // Circle width
                      height: 75, // Circle height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                        color: Colors
                            .white, // Background color of the surrounding circle
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          TImages.Zus_Logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right:
                        100, // Center the circle horizontally near the right edge of central circle with some padding
                    top:
                        180, // Center the circle vertically near the top edge of central circle with some padding
                    child: Container(
                      width: 75, // Circle width
                      height: 75, // Circle height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                        color: Colors
                            .white, // Background color of the surrounding circle
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          TImages.KK7_Logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left:
                        100, // Center the circle horizontally near the right edge of central circle with some padding
                    bottom:
                        180, // Center the circle vertically near the top edge of central circle with some padding
                    child: Container(
                      width: 75, // Circle width
                      height: 75, // Circle height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                        color: Colors
                            .white, // Background color of the surrounding circle
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          TImages.KK8_Logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right:
                        70, // Center the circle horizontally near the right edge of central circle with some padding
                    top:
                        310, // Center the circle vertically near the top edge of central circle with some padding
                    child: Container(
                      width: 75, // Circle width
                      height: 75, // Circle height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                        color: Colors
                            .white, // Background color of the surrounding circle
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          TImages.KK12_Logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left:
                        70, // Center the circle horizontally near the right edge of central circle with some padding
                    bottom:
                        310, // Center the circle vertically near the top edge of central circle with some padding
                    child: Container(
                      width: 75, // Circle width
                      height: 75, // Circle height
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.2), // Shadow color
                            blurRadius: 10, // Shadow blur radius
                            spreadRadius: 2, // Shadow spread radius
                            offset: Offset(0, 4), // Shadow offset
                          ),
                        ],
                        color: Colors
                            .white, // Background color of the surrounding circle
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          TImages.KK11_Logo,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
        ],
      ),
    );
  }
}
