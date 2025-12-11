import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_color.dart';

class Themes {
  static final lightTheme = ThemeData.light().copyWith(
    focusColor: AppColors.primaryColor,
    scaffoldBackgroundColor: AppColors.white,
    dividerColor: const Color.fromARGB(255, 0, 0, 0),
    cardColor: AppColors.white,
    hintColor: AppColors.black,
    shadowColor: AppColors.grey,
    brightness: Brightness.light,
    hoverColor: AppColors.black,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: AppColors.grey400,
      selectionHandleColor: AppColors.grey400,
      cursorColor: AppColors.grey400,
    ),
    cupertinoOverrideTheme: CupertinoThemeData(
      primaryColor: AppColors.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(fillColor: AppColors.red),
    highlightColor: AppColors.grey200,
    unselectedWidgetColor: AppColors.grey800,
    canvasColor: AppColors.primaryColor,
    secondaryHeaderColor: AppColors.grey200,
    dialogTheme: DialogThemeData(
        backgroundColor: AppColors.white,
      ),
    disabledColor: AppColors.grey.withValues(alpha: 0.4),
    textTheme: TextTheme(
      titleSmall: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: AppColors.black,
      ),
      titleLarge: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: 18,
        color: AppColors.black,
      ),
      titleMedium: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppColors.black,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      labelMedium: TextStyle(
        color: AppColors.black,
        fontStyle: FontStyle.normal,
        fontSize: 16,
      ),
      labelSmall: TextStyle(
        color: AppColors.black,
        fontStyle: FontStyle.normal,
        fontSize: 14,
      ),
      bodySmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.normal,
        fontSize: 12,
        color: AppColors.primaryColor,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontStyle: FontStyle.italic,
        color: AppColors.primaryColor,
      ),
      bodyLarge: TextStyle(
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.primaryColor,
      ),
      displaySmall: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppColors.black,
        fontSize: 12,
      ),
      displayMedium: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppColors.black,
        fontSize: 14,
      ),
      headlineLarge: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppColors.primaryColor,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontStyle: FontStyle.normal,
        color: AppColors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        color: AppColors.grey,
        fontStyle: FontStyle.normal,
        fontSize: 12,
      ),
    ),
  );
}
