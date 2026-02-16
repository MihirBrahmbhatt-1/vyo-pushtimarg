import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../const/constant.dart';
import 'custom_button_widget.dart';
import 'custom_text_widget.dart';

class CustomNoInternetWidget extends StatefulWidget {
  final VoidCallback onPressed;
  final String displayMessage;

  const CustomNoInternetWidget({
    super.key,
    required this.onPressed,
    this.displayMessage = '',
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
              textString: widget.displayMessage.isEmpty ? noInternetConnectionString : widget.displayMessage.toString(),
              textSize: FontSize().regular,
              isFontBold: false,
              fontColor: AppColors.black,
              isFontUnderline: false,
              numberOfLines: 10,
              textCenter: true,
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
