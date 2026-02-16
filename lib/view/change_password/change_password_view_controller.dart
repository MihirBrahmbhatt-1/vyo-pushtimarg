import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/common_functions.dart';

class ChangePasswordController extends GetxController
    with WidgetsBindingObserver {
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

  RxString displayInternetConnection = "".obs;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    fetchInternetStatus();
  }

  showMessage(String message) {
    displayInternetConnection.value = message.toString();
  }

  fetchInternetStatus() async {
    await checkInternetStatus(
      checkInternet: ApiServiceInterceptor.checkInternetFunction,
      showMessage: showMessage,
      onConnected: () async {
        homeController.isDisplayInternetConnection.value = false;
        // isLoading.value = true;
      },
      onNoConnection: () {
        // isLoading.value = false;
        homeController.isDisplayInternetConnection.value = true;
      },
    );
  }

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
      await checkInternetStatus(
        onConnected: () async {
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
            try {
              apiController.logoutUser(
                deviceId: homeController.userDeviceIdString.value,
                jwtToken: homeController.jwtToken.value,
              );
            } catch (e) {
              talker.error('Error in _perforLogout func: ${e.toString()}');
            }
          }
        },
        onNoConnection: () {
          homeController.isDisplayInternetConnection.value = true;
        },
      );
    } catch (e) {
      talker.error('No Internet connection');
    }
  }
}
