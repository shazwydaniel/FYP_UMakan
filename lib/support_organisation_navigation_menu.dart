import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/support_organisation/screens/support_organisation_home_page.dart';
import 'package:fyp_umakan/features/support_organisation/screens/support_organisation_profile_page.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';

class SupportOrganisationNavigationMenu extends StatefulWidget {
  const SupportOrganisationNavigationMenu({super.key});

  @override
  _SupportOrganisationNavigationMenuState createState() =>
      _SupportOrganisationNavigationMenuState();
}

class _SupportOrganisationNavigationMenuState
    extends State<SupportOrganisationNavigationMenu> {
  final controller = Get.put(SupportOrganisationNavigationController());
  final darkMode = THelperFunctions.isDarkMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: MaterialStateProperty.all(
              TextStyle(
                color: TColors.textDark,
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
            backgroundColor: darkMode(context)
                ? TColors.blush
                : TColors.blush,
            indicatorColor: darkMode(context)
                ? Colors.white.withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.global, color: TColors.textDark),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Iconsax.security_user, color: TColors.textDark),
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

class SupportOrganisationNavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final List<Widget> screens = [
    const SupportOrganisationHomePage(),
    const SupportOrganisationProfilePage(),
  ];
}