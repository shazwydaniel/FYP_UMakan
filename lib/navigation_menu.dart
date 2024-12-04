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
      TColors.amber, // Home
      TColors.mustard, // Discover
      TColors.cobalt, // Community
      TColors.bubbleOrange, // Profile
    ];

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
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            backgroundColor: darkMode ? TColors.teal : TColors.teal,
            destinations: [
              NavigationDestination(
                icon: Icon(Iconsax.home, color: TColors.cream),
                selectedIcon: Icon(Iconsax.home, color: Colors.black),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.emoji_happy, color: TColors.cream),
                selectedIcon: Icon(Iconsax.emoji_happy, color: Colors.black),
                label: 'Discover',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.people, color: TColors.cream),
                selectedIcon: Icon(Iconsax.people, color: Colors.black),
                label: 'Community',
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
    const HomePageScreen(),
    const DiscoverPageScreen(),
    const CommunityMainPageScreen(),
    const StudentProfilePageScreen(),
  ];
}
