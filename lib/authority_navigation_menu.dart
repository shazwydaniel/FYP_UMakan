import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/features/authority/screens/authority_home_page.dart';
import 'package:fyp_umakan/features/community/screens/community_main_page.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';

class AuthorityNavigationMenu extends StatelessWidget {
  const AuthorityNavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthorityNavigationController());
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
            onDestinationSelected: (index) =>
                controller.selectedIndex.value = index,
            backgroundColor: darkMode ? TColors.stark_blue : TColors.stark_blue,
            indicatorColor: darkMode
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.home, color: TColors.cream),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.people, color: TColors.cream),
                label: 'Community',
              ),
            ],
          ),
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class AuthorityNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const AuthorityHomePage(),
    const CommunityMainPageScreen(),
  ];
}