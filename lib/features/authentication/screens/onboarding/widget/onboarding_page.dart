import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.image});

  final String title, subtitle, image;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          top: 56.0,
          bottom: 24.0,
          left: 24.0,
          right: 24.0,
        ),
        child: Column(
          children: [
            Image(image: AssetImage(image)),
            Text(title, textAlign: TextAlign.center),
            const SizedBox(height: 16.0),
            Text(subtitle, textAlign: TextAlign.center),
          ],
        ));
  }
}
