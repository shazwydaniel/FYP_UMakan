import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:fyp_umakan/features/community/screens/community_main_page.dart';
import 'package:fyp_umakan/features/student_management/screens/student_profile.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,
            backgroundColor: darkMode ? Colors.teal : TColors.teal,
            indicatorColor: darkMode ? Colors.white.withOpacity(0.1) : Colors.white.withOpacity(0.1),

            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.user, color: TColors.cream), label: 'Profile'),
              NavigationDestination(icon: Icon(Iconsax.home, color: TColors.cream), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.emoji_happy, color: TColors.cream), label: 'Discover'),
              NavigationDestination(icon: Icon(Iconsax.people, color: TColors.cream), label: 'Community'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
} 

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [const StudentProfilePageScreen(), const HomePageScreen(), Container(color: TColors.mustard,), const CommunityMainPageScreen()];
}