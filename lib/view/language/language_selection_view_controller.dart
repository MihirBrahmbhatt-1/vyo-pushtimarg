import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/language_controller.dart';
import '../../model/language_model.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/local_db.dart';

class LanguageSelectionViewController extends GetxController
    with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  RxList<LanguageModel> languageListData = <LanguageModel>[].obs;

  RxString languageId = "".obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);

    fetchLanguage();
    final langCode = Get.find<LanguageController>().locale.value.languageCode;
    applySavedLanguage(langCode);

    super.onInit();
  }

  fetchLanguage() async {
    isLoading.value = true;

    dynamic apiResponse = await apiController.fetchLanguageList();

    if (apiResponse['languageList'] != null) {
      if (apiResponse['success'] == true) {
        languageListData = apiResponse['languageList'];
      }
      isLoading.value = false;
    }
  }

  void applySavedLanguage(String savedCode) {
    for (var item in languageListData) {
      item.isDefault = item.languageCode == savedCode;
    }
    languageListData.refresh();
  }

  submitLanguageSelection(String languageId) async {
    if (await ApiServiceInterceptor.checkInternet()) {
      homeController.isDisplayInternetConnection.value = false;
      
    isLoading.value = true;
    await apiController.getLanguageLabels(languageId);
    await LocalDB().setIsLanguageSelected(true);
    await LocalDB().reloadSharedPref();
    isLoading.value = false;
    } else {
      homeController.isDisplayInternetConnection.value = true;

    }
  }
}
