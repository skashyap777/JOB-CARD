import 'package:flutter/material.dart';

class AppColors {
  // Primary Palette
  static const Color orangePrimary = Color(0xFFFF6F3C);
  static const Color orangeLight = Color(0xFFFFF8F5);
  static const Color orangeBorder = Color(0xFFFFE8E0);
  static const Color amberDark = Color(0xFFE8744F);
  
  // Secondary / Contrast
  static const Color greenPrimary = Color(0xFF2E7D32);
  static const Color greenLight = Color(0xFFE8F5E9);
  static const Color blueAction = Color(0xFF1565C0);
  
  // Neutral
  static const Color textDark = Color(0xFF333333);
  static const Color textGrey = Color(0xFF666666);
  static const Color bgGrey = Color(0xFFF5F5F5);
  static const Color white = Colors.white;
}

class AppStyles {
  // Card Styles
  static BoxDecoration cardDecoration = BoxDecoration(
    color: AppColors.white,
    borderRadius: BorderRadius.circular(12.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // Common Text Styles
  static const TextStyle headerEn = TextStyle(
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
    fontSize: 20,
    height: 1.2,
  );

  static const TextStyle labelStyle = TextStyle(
    fontSize: 12.0,
    color: AppColors.textGrey,
  );

  static const TextStyle valueStyle = TextStyle(
    fontSize: 12.0,
    color: AppColors.textDark,
    fontWeight: FontWeight.bold,
  );
}
