import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/home_controller.dart';
import '../../model/category_list_response_model.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/common_functions.dart';

class SubCategoryViewController extends GetxController with WidgetsBindingObserver {

  HomeController homeController = Get.put(HomeController());


  late CategoryListResponseModel categoryList;
  late List<SubCategories> subCategory = [];

  RxString appBarTitle = ''.obs;
  RxString displayInternetConnection = "".obs;


  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    fetchSubCategoryList();
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

  fetchSubCategoryList() async {
     categoryList = Get.arguments['categoryObj'];
     subCategory = categoryList.subCategories!;
     appBarTitle.value = Get.arguments['title'];

  }
}