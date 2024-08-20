import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:fyp_umakan/features/authentication/screens/onboarding/widget/onboarding_page.dart';
import 'package:fyp_umakan/features/authentication/screens/onboarding/widget/onboarding_skip.dart';
import 'package:fyp_umakan/features/authentication/screens/onboarding/widget/onboardingdot_navigation.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OnboardingController());
    return Scaffold(
      body: Stack(
        children: [
          //Horizontal Scrollable Pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: TImages.appLogo,
                title: "UMakan",
                subtitle: "More than just financial and nutrition management",
              ),
              OnBoardingPage(
                image: TImages.appLogo,
                title: "Manage your finance and nutrition",
                subtitle:
                    "GEt recommendations of food in UM that is within your budget",
              ),
              OnBoardingPage(
                image: TImages.appLogo,
                title: "Help Others",
                subtitle:
                    "Have an event and might have extra food? Need food but low on budget? Use UMakan!",
              )
            ],
          ),
          // Skip Button
          const OnBoardingSkip(),

          //Smooth Page const Icon(Iconsax.arrow_right3),
          const onBoardingDot_Navigation(),

          //Circular button
          Positioned(
              right: 24.0,
              bottom: 24.0,
              child: ElevatedButton(
                onPressed: () => OnboardingController.instance.nextPage(),
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  backgroundColor: const Color.fromARGB(255, 156, 236, 7),
                ),
                child: const Icon(
                  Iconsax.arrow_right_3,
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }
}
