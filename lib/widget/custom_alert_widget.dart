import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../const/constant.dart';
import '../localization/dynamic_app_localizations.dart';
import 'custom_button_widget.dart';
import 'custom_text_widget.dart';

class CustomAlertWidget {
  infoAlertDialog({
    required String displayText,
    String? displaySubText,
    String? cancelButtonText,
    required String buttonText,
    required bool statusType,
    VoidCallback? onButtonTap,
    bool showCancelButton = false,
  }) {
    return Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      radius: 10,
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 50,
            child: statusType
                ? Lottie.asset(
                    "assets/lottie/success.json",
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.colorFilter(
                          // Target every shape fill
                          const ['**'],
                          value: ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),
                    height: 100,
                    fit: BoxFit.contain,
                    width: 100,
                    repeat: false,
                    animate: true,
                  )
                : Lottie.asset(
                    delegates: LottieDelegates(
                      values: [
                        ValueDelegate.colorFilter(
                          // Target every shape fill
                          const ['Dot', 'Line'],
                          value: ColorFilter.mode(
                            AppColors.primaryColor,
                            BlendMode.srcOver,
                          ),
                        ),
                      ],
                    ),
                    'assets/lottie/exclamation.json',
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    repeat: false,
                    animate: true,
                  ),
          ),
          const SizedBox(height: 5),
          CustomTextWidget(
            textString: displayText.isNotEmpty
                ? DynamicAppLocalizations.of(
                    Get.context!,
                  ).t(displayText.toString())
                : '',
            textSize: FontSize().xmedium,
            isFontBold: false,
            fontColor: AppColors.black,
            isFontUnderline: false,
            numberOfLines: 10,
            textCenter: true,
          ),
          SizedBox(height: displaySubText == null ? 0 : 6),
          CustomTextWidget(
            textString: displaySubText != null
                ? DynamicAppLocalizations.of(
                    Get.context!,
                  ).t(displaySubText.toString())
                : '',
            textSize: FontSize().regular,
            isFontBold: false,
            fontColor: AppColors.black,
            isFontUnderline: false,
            numberOfLines: 10,
            textCenter: true,
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showCancelButton)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CustomTextButton(
                    title: cancelButtonText ?? 'Cancel',
                    width: 120,
                    textColor: AppColors.black,
                    backgroundColor: AppColors.white,
                    onPressed: () {
                      Navigator.of(Get.context!).pop();
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CustomElevatedButton(
                  title: buttonText,
                  width: 100,
                  textColor: AppColors.white,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () async {
                    if (onButtonTap != null) {
                      Navigator.of(Get.context!).pop();
                      onButtonTap();
                    } else {
                      Navigator.of(Get.context!).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  errorAlertDialog({
    required String displayText,
    String? displaySubText,
    required String buttonText,
    VoidCallback? onButtonTap,
    bool showCancelButton = false,
    String? cancelButtonText,
    required bool statusType,
  }) {
    return Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      radius: 10,
      backgroundColor: AppColors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.white,
            radius: 50,
            child: Lottie.asset(
              delegates: LottieDelegates(
                values: [
                  ValueDelegate.colorFilter(
                    // Target every shape fill
                    const ['Dot', 'Line'],
                    value: ColorFilter.mode(
                      AppColors.primaryColor,
                      BlendMode.srcOver,
                    ),
                  ),
                ],
              ),
              'assets/lottie/exclamation.json',
              width: 80,
              height: 80,
              fit: BoxFit.contain,
              repeat: false,
              animate: true,
            ),
          ),
          const SizedBox(height: 6),
          CustomTextWidget(
            textString: displayText,
            textSize: FontSize().medium,
            isFontBold: false,
            fontColor: AppColors.black,
            isFontUnderline: false,
            numberOfLines: 10,
            textCenter: true,
          ),
          SizedBox(height: displaySubText == null ? 0 : 6),
          CustomTextWidget(
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t(displaySubText.toString()),
            textSize: FontSize().regular,
            isFontBold: false,
            fontColor: AppColors.black,
            isFontUnderline: false,
            numberOfLines: 10,
            textCenter: true,
          ),
          const SizedBox(height: 12),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (showCancelButton)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 14.0),
                  child: CustomTextButton(
                    title: cancelButtonText ?? 'Cancel',
                    width: 120,
                    textColor: AppColors.black,
                    backgroundColor: AppColors.white,
                    onPressed: () {
                      Navigator.of(Get.context!).pop();
                    },
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: CustomElevatedButton(
                  title: buttonText,
                  width: 100,
                  textColor: AppColors.white,
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () async {
                    if (onButtonTap != null) {
                      Navigator.of(Get.context!).pop();
                      onButtonTap();
                    } else {
                      Navigator.of(Get.context!).pop();
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  textFieldAlertDialog({
    required String displayText,
    String? displaySubText,
    required String buttonText,
    VoidCallback? onButtonTap,
    bool showCancelButton = false,
    String? cancelButtonText,
    required bool statusType,
    required bool isLoading,
    required TextEditingController textController,
    required String textLabel,
    required Widget content,
  }) {
    return Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      radius: 10,
      backgroundColor: AppColors.white,
      content: content,
    );
  }

  simpleAlertDialog({
    String? title,
    String? description,
    Widget? content,
    double? height,
    double radius = 10,
    bool barrierDismissible = false,
    bool showCancelButton = false,
    String cancelButtonText = 'Cancel',
    required String buttonText,
    VoidCallback? onButtonTap,
    bool? canPop = true,
  }) {
    return Get.defaultDialog(
      title: "",
      titleStyle: const TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      barrierDismissible: barrierDismissible,
      radius: radius,
      backgroundColor: AppColors.white,
      contentPadding: const EdgeInsets.all(16),
      content: PopScope(
        canPop: canPop!,
        child: SizedBox(
          height: height,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              if (title != null && title.isNotEmpty)
                CustomTextWidget(
                  textString: DynamicAppLocalizations.of(Get.context!).t(title),
                  textSize: FontSize().medium,
                  isFontBold: true,
                  fontColor: AppColors.black,
                  textCenter: true,
                  numberOfLines: 5,
                ),

              if (title != null) const SizedBox(height: 8),

              // Description
              if (description != null && description.isNotEmpty)
                CustomTextWidget(
                  textString:
                      DynamicAppLocalizations.of(Get.context!).t(description),
                  textSize: FontSize().regular,
                  isFontBold: false,
                  fontColor: AppColors.black,
                  numberOfLines: 20,
                  textCenter: true,
                ),

              if (content != null) ...[
                const SizedBox(height: 12),
                content,
              ],

              const SizedBox(height: 20),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showCancelButton)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: CustomTextButton(
                        title: DynamicAppLocalizations.of(
                          Get.context!,
                        ).t("cancel"),
                        width: 110,
                        textColor: AppColors.black,
                        backgroundColor: AppColors.white,
                        onPressed: () {
                          // Navigator.of(Get.context!).pop();
                          Get.back(result: 'cancel');
                        },
                      ),
                    ),
                  CustomElevatedButton(
                    title: buttonText,
                    width: 120,
                    textColor: AppColors.white,
                    backgroundColor: AppColors.primaryColor,
                    onPressed: () {
                      Navigator.of(Get.context!).pop();
                      if (onButtonTap != null) {
                        onButtonTap();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
