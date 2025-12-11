import 'package:flutter/cupertino.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';

class CustomTextStyle {
  static TextStyle errorTextStyle = TextStyle(
    color: AppColors.red,
    fontSize: FontSize().xsmall,
    fontStyle: FontStyle.normal,
  );
  static TextStyle linkTextStyle = TextStyle(
    color: AppColors.blue,
    fontSize: FontSize().regular,
    fontStyle: FontStyle.normal,
  );
  static TextStyle regularTextTheme = TextStyle(
    color: AppColors.black,
    fontSize: FontSize().regular,
    fontStyle: FontStyle.normal,
  );
}
