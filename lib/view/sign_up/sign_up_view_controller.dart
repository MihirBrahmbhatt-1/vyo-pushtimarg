import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../navigation/pages.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/local_db.dart';
import '../../widget/countries.dart';

class SignUpViewController extends GetxController with WidgetsBindingObserver  {
  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());

  final formKey = GlobalKey<FormState>().obs;

  TextEditingController phoneNumberTextController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  RxBool isLoading = false.obs;
  RxBool isPasswordVisible = true.obs;
  RxBool showPhoneError = false.obs;
  RxBool isValidePhoneNumber = false.obs;


  RxString phoneErrorMessage = "".obs;

  // Country selectedCountry = countries.firstWhere((c) => c.code == "IN");
  final Rx<Country> selectedCountry =
    countries.firstWhere((c) => c.code == "IN").obs;

     @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);

    super.onInit();

    checkForDeviceInternetConnectivity();
  }

  checkForDeviceInternetConnectivity() async {
    if (await ApiServiceInterceptor.checkInternet()) {
      homeController.isDisplayInternetConnection.value = false;
    } else {
      homeController.isDisplayInternetConnection.value = true;
    }
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


  sendOtp() async {
    try {
      isLoading.value = true;
      bool result = await apiController.sendPhoneNumberOtp(
        phoneNumberTextController.value.text,
        '+${selectedCountry.value.dialCode}',
      );
      if (result) {
        homeController.userPhoneNumber.value = phoneNumberTextController.value.text;
        homeController.isUserExists.value = apiController.sendOtpResponseModel.value!.isUserExist!;
        homeController.countryCode.value = '+${selectedCountry.value.dialCode}';
        await LocalDB().setUserPhoneNumber(phoneNumberTextController.value.text.toString());
        await LocalDB().setCountryCode('+${selectedCountry.value.dialCode}');
        await LocalDB().setIsUserExists(apiController.sendOtpResponseModel.value!.isUserExist!);
        await LocalDB().reloadSharedPref();
        await homeController.reload();
        Get.toNamed(Routes.verifyotp, arguments: {'verificationId': apiController.sendOtpResponseModel.value?.verificationId.toString(), 'phoneNumber': phoneNumberTextController.value.text.toString(), 'countryCode': selectedCountry.value.dialCode});
        phoneNumberTextController.text = '';
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      talker.error('Error in sendOtp func: ${e.toString()}');
    }
  }
}
