import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';

class OtpViewController extends GetxController with WidgetsBindingObserver {
  RxInt otpTextLength = 6.obs;

  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());

  late List<TextEditingController> otpTextController;

  late List<FocusNode> focusNodes;

  RxBool isOtpTextFieldModified = false.obs;
  RxString userEnteredOtp = ''.obs;

  RxBool isOtpInvalidMessageDisplay = false.obs;
  RxBool isDisplayedResendOtpButton = false.obs;
  RxBool isOtpExpired = false.obs;
  RxBool isLoading = false.obs;
  RxBool isLocked = false.obs;
  RxBool isSendingOtp = false.obs;

  RxInt remainingSeconds = resendOtpInSeconds.obs;
  RxInt remainingSendingOtpAttempts = 3.obs;

  Timer? calculateRemainingSecondsTimer;
  Timer? otpValidityTimer;

  RxBool allFilled = false.obs;

  RxString fetchOtpString = ''.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    otpTextController = List.generate(
      otpTextLength.value,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(otpTextLength.value, (_) => FocusNode());
    fetchOtpString.value = Get.arguments['otp'];
    super.onInit();
  }

  formattedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "$min" : "$min";
    String second = sec.toString().length <= 1 ? "$sec" : "$sec";
    String validateMinute = '';
    if (minute != '0') {
      validateMinute = "${minute}m ${second}s";
    } else {
      validateMinute = "${second}s";
    }
    return validateMinute;
  }

  getOtp() {
    userEnteredOtp.value = otpTextController
        .map((controller) => controller.text)
        .join('');
    return userEnteredOtp.value;
  }

  buildOtpField(int index) {
    return GetBuilder<OtpViewController>(
      builder: (c) {
        final isFilled = c.otpTextController[index].text.isNotEmpty;
        return AnimatedBuilder(
          animation: otpTextController[index],
          builder: (context, child) {
            return AnimatedScale(
              scale: isFilled ? 1.1 : 1.0,
              duration: Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: child,
            );
          },
          child: SizedBox(
            width: otpTextLength.value > 4 ? 40 : 50,
            height: otpTextLength.value > 4 ? 40 : 50,
            child: TextFormField(
              controller: otpTextController[index],
              focusNode: focusNodes[index],
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              maxLength: 1,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
              onChanged: (value) async {
                isOtpTextFieldModified.value = true;
                getOtp();
                if (value.isNotEmpty && index < otpTextLength.value - 1) {
                  FocusScope.of(
                    Get.context!,
                  ).requestFocus(focusNodes[index + 1]);
                } else if (value.isEmpty && index > 0) {
                  FocusScope.of(
                    Get.context!,
                  ).requestFocus(focusNodes[index - 1]);
                }
                for (int i = 0; i < otpTextLength.value; i++) {
                  if (otpTextController[i].text.trim().isEmpty) {
                    allFilled.value = false;
                    break;
                  } else {
                    allFilled.value = true;
                  }
                }
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                counterText: '',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.primaryColor,
                    width: 2,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: otpTextController[index].text.isEmpty
                        ? AppColors.red
                        : AppColors.black,
                    width: otpTextController[index].text.isEmpty ? 2 : 0,
                  ),
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        );
      },
    );
  }
}
