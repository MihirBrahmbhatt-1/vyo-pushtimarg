import 'package:flutter/material.dart';
import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';

class SurveySuccessViewController extends GetxController
    with WidgetsBindingObserver {
  final ApiController apiController = Get.find<ApiController>();
  final HomeController homeController = Get.find<HomeController>();

  RxBool showButton = false.obs;
  final controller = ConfettiController();

  @override
  void onInit() {
    super.onInit();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    await apiController.getUserProfileByPhoneNumber(
      phoneNumber: homeController.userPhoneNumber.value,
      jwtToken: homeController.jwtToken.toString(),
    );
  }

  void playConfetti(BuildContext context) {
    Confetti.launch(
      context,
      options: const ConfettiOptions(
          particleCount: 200, spread: 100, y: 1, startVelocity: 60),
    );

    Future.delayed(const Duration(seconds: 2), () {
      showButton.value = true;
    });
  }
}
