import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/logger.dart';
import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../navigation/pages.dart';
import '../../../utility/api_service_interceptor.dart';
import '../../../widget/countries.dart';

class ForgotPasswordViewController extends GetxController
    with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());

  final formKey = GlobalKey<FormState>().obs;

  TextEditingController phoneNumberTextController = TextEditingController();
  RxString phoneErrorMessage = "".obs;

  RxBool showPhoneError = false.obs;
  RxBool isLoading = false.obs;
  RxBool isValidePhoneNumber = false.obs;

  final Rx<Country> selectedCountry =
      countries.firstWhere((c) => c.code == "IN").obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);

    super.onInit();

    /// Listen to country change
    ever(selectedCountry, (c) {
      talker.info("COUNTRY CHANGED → ${c.name} (+${c.dialCode})");
      talker.info("FULL PHONE → ${getFullPhone()}");
    });

    /// Listen to phone number change
    phoneNumberTextController.addListener(() {
      talker.info("PHONE UPDATED → ${phoneNumberTextController.text}");
      talker.info("FULL PHONE → ${getFullPhone()}");
    });
    checkForDeviceInternetConnectivity();
  }

  checkForDeviceInternetConnectivity() async {
    if (await ApiServiceInterceptor.checkInternet()) {
      homeController.isDisplayInternetConnection.value = false;
    } else {
      homeController.isDisplayInternetConnection.value = true;
    }
  }

  /// Get final combined number
  String getFullPhone() {
    return "+${selectedCountry.value.dialCode}${phoneNumberTextController.text}";
  }

  bool validatePhone() {
    if (phoneNumberTextController.text.isEmpty) {
      phoneErrorMessage.value = "Enter phone number";
      showPhoneError.value = true;
      return false;
    }
    if (!isValidePhoneNumber.value) {
      showPhoneError.value = true;
      return false;
    }
    showPhoneError.value = false;
    return true;
  }

  sendForgotPasswordOtp() async {
    try {
      isLoading.value = true;
      bool result = await apiController.sendForgotPasswordOtp(
          phoneNumberTextController.text, '+${selectedCountry.value.dialCode}');
      if (result) {
        Get.toNamed(Routes.forgotpasswordverifyotp, arguments: {
          'verificationId': apiController
              .forgotPasswordsendOtpResponseModel.value?.verificationId
              .toString(),
          'phoneNumber': phoneNumberTextController.value.text.toString(),
          'countryCode': selectedCountry.value.dialCode
        });
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      talker.error('Error in userLogin func: ${e.toString()}');
    }
  }
}
