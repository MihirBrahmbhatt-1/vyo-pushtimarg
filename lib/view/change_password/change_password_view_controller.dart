import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/common_functions.dart';
import '../../widget/custom_alert_widget.dart';

class ChangePasswordController extends GetxController {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final formKey = GlobalKey<FormState>();

  final currentController = TextEditingController().obs;
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController().obs;

  RxBool isFormValid = false.obs;
  RxBool isBtnLoading = false.obs;

  RxBool showCurrent = false.obs;
  RxBool showNew = false.obs;
  RxBool showConfirm = false.obs;

  RxBool hasMinLength = false.obs;

  void validatePassword(String value) {
    hasMinLength.value = value.length >= 8;
  }

  void validateForm() {
    final isValid = formKey.currentState?.validate() ?? false;
    isFormValid.value = isValid && hasMinLength.value;
  }

  Future<void> submitChangePassword() async {
    if (!isFormValid.value) return;

    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        isBtnLoading.value = true;
        bool isSuccess = await apiController.changePassword(
          userId: homeController.customerIdString.value,
          currentPassword: confirmPasswordController.value.text,
          oldPassword: currentController.value.text,
          newPassword: confirmPasswordController.value.text,
          jwtToken: homeController.jwtToken.value,
        );
        isBtnLoading.value = false;
        if (isSuccess) {
          clearAppDataAndLogout();
        }
      } else {
        CustomAlertWidget().simpleAlertDialog(
            title: DynamicAppLocalizations.of(Get.context!)
                .t("no_internet_connection"),
            description: '',
            canPop: false,
            buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
            onButtonTap: () {
              Get.back();
            });
      }
    } catch (e) {
      talker.error('No Internet connection');
    }
  }
}
