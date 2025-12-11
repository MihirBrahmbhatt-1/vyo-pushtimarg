import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../const/app_color.dart';

// ignore: must_be_immutable
class CustomTextWidget extends StatelessWidget {
  final String textString;
  final double textSize;
  bool? isFontBold = false;
  bool? isFontUnderline = false;
  Color? fontColor = AppColors.black;
  bool? textCenter = false;
  int? numberOfLines = 1;
  FontStyle? fontStyle = FontStyle.normal;
  final Key? uiKey;

  CustomTextWidget({
    super.key,
    required this.textString,
    required this.textSize,
    this.isFontBold,
    required this.fontColor,
    this.isFontUnderline,
    this.textCenter,
    this.numberOfLines,
    this.fontStyle = FontStyle.normal,
    this.uiKey,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      key: uiKey,
      textString,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      maxLines: numberOfLines,
      textAlign: textCenter == true ? TextAlign.center : TextAlign.start,
      style: GoogleFonts.roboto(
        textStyle: TextStyle(
          decoration:
              isFontUnderline == true ? TextDecoration.underline : TextDecoration.none,
          fontSize: textSize,
          fontWeight: isFontBold == true ? FontWeight.bold : FontWeight.normal,
          letterSpacing: .2,
          fontStyle: fontStyle,
          color: fontColor,
        ),
      ),
    );
  }
}
