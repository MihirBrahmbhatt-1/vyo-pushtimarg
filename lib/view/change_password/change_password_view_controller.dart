import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../navigation/pages.dart';
import '../../utility/local_db.dart';

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
      await LocalDB().setIsLoggedIn(false);
      await LocalDB().setIsUserExists(false);
      await LocalDB().setIsUserProfileCompleted(false);
      await LocalDB().setJwtToken('');
      await LocalDB().setDashboardVersion('');
      await LocalDB().setDashboardSliderVersion('');
      await LocalDB().setDashboardHtmlCache('');
      await LocalDB().setDashboardImageSliderCache('');
      await LocalDB().setLabelLanguageVersion('');
      await LocalDB().removeJwtToken();
      homeController.jwtToken.value = '';
      homeController.isLoggedIn.value = false;
      homeController.selectedIndex.value = 0;
      Get.offAllNamed(Routes.signin);
    }
  }
}
