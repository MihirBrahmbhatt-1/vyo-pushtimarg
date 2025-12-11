import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../navigation/pages.dart';

class ResetPasswordViewController extends GetxController {

    ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());
  final formKey = GlobalKey<FormState>();

  RxBool isLoading =false.obs;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  /// RULE CHECKS
  RxBool hasMinLength = false.obs;

  /// FINAL VALIDATION
  RxBool isNewPasswordValid = false.obs;
  RxBool isConfirmPasswordValid = false.obs;
  RxBool isButtonEnabled = false.obs;

  /// Validate password rules
  void validateNewPassword(String value) {
    hasMinLength.value = value.length >= 8;

    isNewPasswordValid.value = 
        hasMinLength.value;
  }

  /// Confirm password validation
  void validateConfirmPassword(String confirm, String newPass) {
    isConfirmPasswordValid.value =
        confirm.isNotEmpty && confirm == newPass;
  }

  /// Enable button only if everything is valid
  void checkForm() {
    isButtonEnabled.value =
        isNewPasswordValid.value && isConfirmPasswordValid.value;
  }

  /// Submit API
  Future<void> submitResetPassword() async {
    // Call your API here…
    isLoading.value = true;
    bool? isSuccess = await apiController.resetPasswordApi(phoneNumber: apiController.forgotPasswordsendOtpResponseModel.value!.mobileNumber.toString(), countryCode: apiController.forgotPasswordsendOtpResponseModel.value!.countryCode.toString(), password: confirmPasswordController.value.text);
    if(isSuccess == true){
      isLoading.value = false;
    
      Get.offAllNamed(Routes.signin);
    } else {
      isLoading.value = false;
    }
  }
}
