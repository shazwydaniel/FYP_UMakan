import 'package:flutter/material.dart';
import 'package:fyp_umakan/features/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class onBoardingDot_Navigation extends StatelessWidget {
  const onBoardingDot_Navigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    return Positioned(
        bottom: 25,
        left: 36,
        child: SmoothPageIndicator(
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          count: 3,
          effect: const ExpandingDotsEffect(
              activeDotColor: Colors.orange, dotHeight: 6),
        ));
  }
}
