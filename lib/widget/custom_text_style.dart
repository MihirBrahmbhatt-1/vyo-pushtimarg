import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';

class CustomTextStyle {
  static const String fontFamily = 'Roboto';


  static TextStyle get errorTextStyle => GoogleFonts.getFont(
    fontFamily,
    color: AppColors.red,
    fontSize: FontSize().xsmall,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.normal,
  );
  static TextStyle get linkTextStyle => GoogleFonts.getFont(
    fontFamily,
    color: AppColors.blue,
    fontSize: FontSize().regular,
    fontStyle: FontStyle.normal,
  );
  static TextStyle get regularTextTheme => GoogleFonts.getFont(
    fontFamily,
    color: AppColors.black,
    fontSize: FontSize().regular,
    fontStyle: FontStyle.normal,
  );
}
