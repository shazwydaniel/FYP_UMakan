// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/community/screens/community_main_page.dart';
import 'package:fyp_umakan/features/discover/screens/discover.dart';
import 'package:fyp_umakan/features/student_management/screens/student_profile.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    final indicatorColors = [
      TColors.cobalt, // Community
      TColors.mustard, // Cafe
      Colors.grey, // Track (disabled)
      TColors.bubbleOrange, // Profile
    ];

    const disabledIndex = 2; // Track

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                );
              }
              return TextStyle(
                color: TColors.cream,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              );
            }),
            indicatorColor: indicatorColors[controller.selectedIndex.value],
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              if (index == disabledIndex) {
                Get.snackbar(
                  'Track Feature Unavailable',
                  'The Track feature is temporarily disabled.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.grey.shade800,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(12),
                );
                return;
              }
              controller.selectedIndex.value = index;
            },
            backgroundColor: darkMode ? TColors.teal : TColors.teal,
            destinations: [
              NavigationDestination(
                icon: Icon(Iconsax.people, color: TColors.cream),
                selectedIcon: Icon(Iconsax.people, color: Colors.black),
                label: 'Community',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.reserve, color: TColors.cream),
                selectedIcon: Icon(Iconsax.reserve, color: Colors.black),
                label: 'Cafe',
              ),

              // Disabled Track destination (centered label + red wrench badge)
              NavigationDestination(
                icon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Iconsax.calculator, color: TColors.cream),
                    Positioned(
                      right: -2,
                      top: 2,
                      child: Icon(
                        Icons.build_rounded,
                        size: 14,
                        color: TColors.amber,
                      ),
                    ),
                  ],
                ),
                selectedIcon: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Iconsax.calculator, color: Colors.black),
                    Positioned(
                      right: -2,
                      top: 2,
                      child: Icon(
                        Icons.build_rounded,
                        size: 14,
                        color: TColors.amber,
                      ),
                    ),
                  ],
                ),
                label: 'Track',
              ),

              NavigationDestination(
                icon: Icon(Iconsax.user_tag, color: TColors.cream),
                selectedIcon: Icon(Iconsax.user_tag, color: Colors.black),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const CommunityMainPageScreen(),
    const DiscoverPageScreen(),
    const HomePageScreen(), // Track (disabled)
    const StudentProfilePageScreen(),
  ];
}