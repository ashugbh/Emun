import 'package:flutter/material.dart';
import 'package:emun/core/theme/app_colors.dart';

class EmunDesignSystem {
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing20 = 20;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing40 = 40;
  static const double spacing48 = 48;

  static const double radiusSmall = 10;
  static const double radiusMedium = 16;
  static const double radiusLarge = 24;

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationMedium = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 600);

  static const List<BoxShadow> softShadow = [
    BoxShadow(
      color: Color(0x14000000),
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];

  static const LinearGradient heroGradient = LinearGradient(
    colors: [
      AppColors.primaryDark,
      AppColors.primary,
      AppColors.mint,
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
