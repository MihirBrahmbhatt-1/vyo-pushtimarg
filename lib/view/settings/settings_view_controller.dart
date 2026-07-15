import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/common_functions.dart';

class SettingsViewController extends GetxController with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());

    TextEditingController deleteAccountController = TextEditingController();

  RxBool isLoading = false.obs;
  RxString displayInternetConnection = "".obs;
  RxString deleteAccountErrorText = "".obs;  

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

  logoutUser() async {
    try {
      isLoading.value = true;
      await apiController.logoutUser(
        deviceId: homeController.userDeviceIdString.value,
        jwtToken: homeController.jwtToken.value,
      );
      isLoading.value = false;
    } catch (e) {
      talker.error('Error in _perforLogout func: ${e.toString()}');
    }
  }

  deleteUser() async {
    try {
      isLoading.value = true;
      await apiController.deleteUser(
        jwtToken: homeController.jwtToken.value,
      );
      isLoading.value = false;
    } catch (e) {
      talker.error('Error in deleteUser func: ${e.toString()}');
    }
  }
}
