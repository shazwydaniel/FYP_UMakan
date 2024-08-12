import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/screens/homepage/homepage.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) => controller.selectedIndex.value = index,

            destinations: const [
              NavigationDestination(icon: Icon(Iconsax.user), label: 'Profile'),
              NavigationDestination(icon: Icon(Iconsax.home), label: 'Home'),
              NavigationDestination(icon: Icon(Iconsax.cake), label: 'Discover'),
              NavigationDestination(icon: Icon(Iconsax.people), label: 'Community'),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
} 

class NavigationController extends GetxController{
  final Rx<int> selectedIndex = 0.obs;

  final screens = [Container(color: Colors.green,), const HomePageScreen(), Container(color: Colors.cyan,), Container(color: Colors.pink,),];
}