import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../const/constant.dart';
import 'custom_button_widget.dart';
import 'custom_text_widget.dart';

class CustomNoInternetWidget extends StatefulWidget {
  final VoidCallback onPressed;

  const CustomNoInternetWidget({
    super.key,
    required this.onPressed,
  });

  @override
  State<CustomNoInternetWidget> createState() => _CustomNoInternetWidgetState();
}

class _CustomNoInternetWidgetState extends State<CustomNoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie/NoInternet.json',
            width: 200,
            height: 200,
            fit: BoxFit.fill,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: CustomTextWidget(
              uiKey: Key('noInternetText-key'),
              textString: noInternetConnectionString,
              textSize: FontSize().regular,
              isFontBold: false,
              fontColor: AppColors.black,
              isFontUnderline: false,
              numberOfLines: 1,
              textCenter: false,
            ),
          ),
          CustomElevatedButton(
            title: retryString,
            width: 200,
            textColor: AppColors.white,
            backgroundColor: AppColors.primaryColor,
            onPressed: widget.onPressed,
          ),
        ],
      ),
    );
  }
}
