import 'package:flutter/material.dart';
import 'dart:math';

class Responsive {
  static double screenWidth(BuildContext c) => MediaQuery.of(c).size.width;

  static bool isDesktop(BuildContext c) => screenWidth(c) >= 1200;
  static bool isTablet(BuildContext c) => screenWidth(c) >= 800 && screenWidth(c) < 1200;
  static bool isMobile(BuildContext c) => screenWidth(c) < 800;

  static EdgeInsets horizontalPadding(
    BuildContext c, {
    double desktop = 100,
    double tablet = 48,
    double mobile = 16,
    double verticalDesktop = 30,
    double verticalMobile = 20,
  }) {
    if (isDesktop(c)) {
      return EdgeInsets.symmetric(horizontal: desktop, vertical: verticalDesktop);
    } else if (isTablet(c)) {
      return EdgeInsets.symmetric(horizontal: tablet, vertical: verticalDesktop);
    } else {
      return EdgeInsets.symmetric(horizontal: mobile, vertical: verticalMobile);
    }
  }

  static double imageSizeFor(BuildContext c, {double max = 200, double desktopFactor = 0.15, double tabletFactor = 0.25, double mobileFactor = 0.35}) {
    final w = screenWidth(c);
    final factor = isDesktop(c) ? desktopFactor : isTablet(c) ? tabletFactor : mobileFactor;
    return min(max, w * factor);
  }
}