import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/admin/admin_homepage.dart';
import 'package:fyp_umakan/features/admin/admin_profile.dart';
import 'package:fyp_umakan/features/authority/screens/authority_profile_page.dart';
import 'package:fyp_umakan/features/authority/screens/authority_home_page.dart';
import 'package:fyp_umakan/features/community/screens/community_main_page.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';

class AdminNavigationMenu extends StatelessWidget {
  const AdminNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminNavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                color: TColors.cream,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          child: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) {
              if (index < controller.screens.length) {
                controller.selectedIndex.value = index;
              }
            },
            backgroundColor: darkMode ? TColors.charcoal : TColors.charcoal,
            indicatorColor: darkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.global, color: TColors.cream),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.security_user, color: TColors.cream),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.selectedIndex.value,
          children: controller.screens,
        ),
      ),
    );
  }
}

class AdminNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    AdminHomePage(),
    AdminProfilePage(),
  ];
}
