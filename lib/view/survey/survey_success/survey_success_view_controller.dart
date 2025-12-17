import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';

class SurveySuccessViewController extends GetxController
    with WidgetsBindingObserver {
  late ConfettiController? confettiController;
  final ApiController apiController = Get.find<ApiController>();
  final HomeController homeController = Get.find<HomeController>();

  RxBool showButton = false.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    confettiController = ConfettiController(
      duration: const Duration(milliseconds: 200),
    );
    await apiController.getUserProfileByPhoneNumber(
      phoneNumber: homeController.userPhoneNumber.value,
      jwtToken: homeController.jwtToken.toString(),
    );
    
    confettiController?.play();
    confettiController?.addListener(() {
      if (confettiController?.state == ConfettiControllerState.stopped) {
        showButton.value = true;
      }
    });
  }

  @override
  void dispose() {
    confettiController?.dispose();
    super.dispose();
  }
}
