import 'package:flutter/material.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';
import 'custom_text_widget.dart';

class CustomElevatedButtonWidget extends StatelessWidget {
  final Key? buttonKey;
  final String buttonText;
  final bool? isLoading;
  final void Function()? onPressed;

  const CustomElevatedButtonWidget({
    super.key,
    required this.buttonText,
    required this.buttonKey,
    this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      key: buttonKey,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: buttonBorderRadius,
          ),
        
      ),
      onPressed: onPressed,
      child: isLoading == true
          ? SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                color: AppColors.white,
              ),
            )
          : CustomTextWidget(
              uiKey: buttonKey,
              textString: buttonText,
              textSize: FontSize().medium,
              isFontBold: true,
              fontColor: AppColors.white,
              isFontUnderline: false,
            ),
    );
  }
}
