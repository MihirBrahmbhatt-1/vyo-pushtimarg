import 'package:flutter/material.dart';

// Your App Imports
import '../const/app_color.dart'; 
import '../const/app_constant.dart';
import '../widget/custom_text_widget.dart';
// Assuming FontSize is accessible via an import or defined globally

typedef RetryCallback = void Function();

class EmptyDataWithRetry extends StatelessWidget {
  final String messageLabel;
  final String buttonText;
  final RetryCallback onRetry;
  final IconData? icon;

  const EmptyDataWithRetry({
    super.key,
    required this.messageLabel,
    required this.buttonText,
    required this.onRetry,
    this.icon = Icons.info_outline, // Default icon
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. Informative Icon
            Icon(
              icon,
              size: 60,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),

            // 2. The Dynamic Text Message
            CustomTextWidget(
              textString: messageLabel,
              fontColor: AppColors.grey,
              isFontBold: true,
              textSize: FontSize().regular,
              textCenter: true,
            ),
            const SizedBox(height: 24),

            // 3. The Elevated Retry Button
            ElevatedButton(
              onPressed: onRetry, // 🎯 Executes the passed-in callback function
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: CustomTextWidget(
                textString: buttonText,
                fontColor: AppColors.white,
                isFontBold: true,
                textSize: FontSize().regular,
              ),
            ),
          ],
        ),
      ),
    );
  }
}