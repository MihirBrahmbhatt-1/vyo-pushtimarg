import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryColor = Color(0xFFFF8c00);
  static Color textColor = primaryColor.darken(0.25);
  static const Color shadowPrimaryColor = Color(0xFFFF8c00);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static Color grey200 = Colors.grey.shade200;
  static Color grey400 = Colors.grey.shade400;
  static Color grey800 = Colors.grey.shade800;
  static const Color lightgrey = Color.fromRGBO(220, 220, 230, 1);
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color blue = Colors.blue;
  static const Color transparent = Colors.transparent;

  static const Color shimmerBase = Color.fromARGB(255, 238, 238, 238);
  static const Color shiimmerHighlight = Color.fromRGBO(245, 245, 245, 1);
}

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight =
        hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
