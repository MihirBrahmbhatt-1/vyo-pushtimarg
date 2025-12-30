import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../utility/common_functions.dart';
import '../../widget/countries.dart';

class LoginViewController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());

  final formKey = GlobalKey<FormState>().obs;
  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool showPhoneError = false.obs;
  RxBool isValidePhoneNumber = false.obs;

  RxString phoneErrorMessage = "".obs;

  // Country selectedCountry = countries.firstWhere((c) => c.code == "IN");
  final Rx<Country> selectedCountry = countries
      .firstWhere((c) => c.code == "IN")
      .obs;

  @override
  void onInit() {
    checkDeviceConfig();
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
  }

  bool validatePhone() {
    if (phoneNumberTextController.text.isEmpty) {
      phoneErrorMessage.value = DynamicAppLocalizations.of(Get.context!).t("phone_number_is_required");
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

  /// Get final combined number
  String getFullPhone() {
    return "+${selectedCountry.value.dialCode}${phoneNumberTextController.text}";
  }

  userLogin() async {
    try {
      isLoading.value = true;
      bool result = await apiController.userLoginApi(
        countryCode: selectedCountry.value.dialCode.toString(),
        phoneNumber: phoneNumberTextController.value.text,
        password: passwordController.value.text,
      );
      if (result) {
        isLoading.value = false;
        // Get.put(DashboardViewController());
        Get.offAllNamed(Routes.home);
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      talker.error('Error in userLogin func: ${e.toString()}');
    }
  }
}
