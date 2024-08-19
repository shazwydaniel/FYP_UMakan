import "package:flutter/material.dart";

class TCircularContainer extends StatelessWidget {
  const TCircularContainer({
    super.key,
    this.width = 50,
    this.height = 50,
    this.radius = 50,
    this.padding = 0,
    this.child,
    this.backgroundColor = Colors.white,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final Widget? child;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: child,
    );
  }
}