import "package:flutter/material.dart";
import "package:get/get.dart";

class TCustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);

    final firstCurve = Offset(0, size.height - 20);
    final lastCurve = Offset(30, size.height - 20);
    path.quadraticBezierTo(firstCurve.dx, firstCurve.dy, lastCurve.dx, lastCurve.dy);

    final firstCurveB = Offset(0, size.height - 20);
    final lastCurveB = Offset(size.width - 30, size.height - 20);
    path.quadraticBezierTo(firstCurveB.dx, firstCurveB.dy, lastCurveB.dx, lastCurveB.dy);

    final firstCurveC = Offset(size.width, size.height - 20);
    final lastCurveC = Offset(size.width, size.height);
    path.quadraticBezierTo(firstCurveC.dx, firstCurveC.dy, lastCurveC.dx, lastCurveC.dy);

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}