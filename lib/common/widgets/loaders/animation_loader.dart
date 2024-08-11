import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fyp_umakan/utils/constants/sizes.dart';
import 'package:fyp_umakan/utils/constants/colors.dart';
import 'package:fyp_umakan/utils/helpers/helper_functions.dart';

class TAnimationLoaderWidget extends StatelessWidget{
  // static void openAnimationLoader(String text, String animation) {
  // }

  const TAnimationLoaderWidget(
    {
      super.key,
      required this.text ,
      required this.animation,
      this.showAction = false,
      this.actionText,
      this.onActionPressed,

    }
  );

  final String text;
  final String animation;
  final bool showAction;
  final String? actionText;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, width: MediaQuery.of(context).size.width * 0.8),
          const SizedBox(height: TSizes.defaultSpace),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: TSizes.defaultSpace),
          showAction ? SizedBox(
            width: 250,
            child: OutlinedButton(
              onPressed: onActionPressed,
              style: OutlinedButton.styleFrom(backgroundColor: TColors.olive),
              child: Text(
                actionText!,
                style: Theme.of(context).textTheme.bodyMedium!.apply(color: TColors.cream),
              ),
            ),
          )
          : const SizedBox(),
        ],
      ),
    );
  }
}