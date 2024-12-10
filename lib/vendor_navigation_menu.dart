import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/community/screens/community_main_page.dart';
import 'package:fyp_umakan/features/discover/screens/discover.dart';
import 'package:fyp_umakan/features/student_management/screens/student_profile.dart';
import 'package:fyp_umakan/features/vendor/controller/vendor_controller.dart';
import 'package:fyp_umakan/features/vendor/screens/advertisement/vendor_adverts.dart';
import 'package:fyp_umakan/features/vendor/screens/profile/vendor_profile.dart';
import 'package:fyp_umakan/features/vendor/screens/reviews/vendor_reviews.dart';

import 'package:fyp_umakan/features/vendor/screens/vendor_register.dart';
import 'package:fyp_umakan/features/vendor/screens/home/vendors_home.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class VendorNavigationMenu extends StatelessWidget {
  const VendorNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VendorNavigationController());
    Get.put(VendorController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.amber : TColors.amber,
          indicatorColor: darkMode
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.1),
          destinations: const [
            NavigationDestination(
                icon: Icon(Iconsax.add, color: TColors.cream), label: 'Items'),
            NavigationDestination(
                icon: Icon(Iconsax.note_214, color: TColors.cream),
                label: 'Advertisment'),
            NavigationDestination(
                icon: Icon(Iconsax.star, color: TColors.cream),
                label: 'Reviews'),
            NavigationDestination(
                icon: Icon(Iconsax.user, color: TColors.cream),
                label: 'Profile'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class VendorNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    VendorsHome(),
    VendorAdsPage(),
    ReviewsPage(),
    VendorProfilePageScreen(),
  ];
}
