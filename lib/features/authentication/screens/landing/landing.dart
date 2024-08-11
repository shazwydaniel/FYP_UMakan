import 'package:flutter/material.dart';
import 'package:fyp_umakan/utils/constants/image_strings.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          Image(image: AssetImage(TImages.leaf))
        ]
      )
    );
  }
}