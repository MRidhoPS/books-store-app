import 'package:flutter/material.dart';

extension ScreenUtils on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Breakpoints
  bool get isSmallScreen => screenWidth <= 321;
  bool get isMediumScreen => screenWidth >= 320 && screenWidth <= 768;
  bool get isLargeScreen => screenWidth > 768;

  double get autoWidth {
    if (isSmallScreen) return screenWidth * 0.4; // 90% layar untuk small
    if (isMediumScreen) return screenWidth * 0.7; // 70% layar untuk medium
    return screenWidth * 0.5; // 50% layar untuk large
  }

  double get autoHeight {
    if (isSmallScreen) return screenHeight * 0.4;
    if (isMediumScreen) return screenHeight * 0.3;
    return screenHeight * 0.25;
  }

  double dynamicAspectRatio({
    required double itemWidthFraction,
    required double itemHeightFraction,
  }) {
    final w = screenWidth * itemWidthFraction;
    final h = screenHeight * itemHeightFraction;
    return w / h;
  }
}
