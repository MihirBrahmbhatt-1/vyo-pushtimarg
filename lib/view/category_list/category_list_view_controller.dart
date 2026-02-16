import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/common_functions.dart';

class CategoryListViewController extends GetxController
    with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final RxBool isShimmerLoading = true.obs;
  RxString displayInternetConnection = "".obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);

    fetchCategoryList();
    super.onInit();
  }

  showMessage(String message) {
    displayInternetConnection.value = message.toString();
  }

  fetchCategoryList() async {
    isShimmerLoading.value = true;

    await checkInternetStatus(
      checkInternet: ApiServiceInterceptor.checkInternetFunction,
      showMessage: showMessage,
      onConnected: () async {
        homeController.isDisplayInternetConnection.value = false;
        isShimmerLoading.value = true;

        await apiController.fetchCategoryList(
          languageId: homeController.selectedLanguageId.value,
          jwtToken: homeController.jwtToken.value,
        );
        isShimmerLoading.value = false;
      },
      onNoConnection: () {
        isShimmerLoading.value = false;

        homeController.isDisplayInternetConnection.value = true;
      },
    );
  }

  Future<void> refreshCategoryList() async {
    await fetchCategoryList();
  }

  Map<String, dynamic> getMediaDetails(String categoryType) {
    const Map<String, Map<String, dynamic>> mediaTypeLookup = {
      '4': {'icon': Icons.audiotrack, 'color': AppColors.primaryColor},
      '3': {'icon': Icons.picture_as_pdf, 'color': AppColors.red},
      '2': {'icon': Icons.videocam, 'color': AppColors.blue},
      '1': {'icon': Icons.image, 'color': AppColors.green},
    };

    final categoryTypeString = categoryType.toLowerCase();
    for (final keyword in mediaTypeLookup.keys) {
      if (categoryTypeString.contains(keyword) || (keyword == '1')) {
        final details = mediaTypeLookup[keyword]!;
        return {
          'icon': details['icon'],
          'color': (details['color'] as Color).withValues(alpha: 0.8),
        };
      }
    }
    return {'icon': Icons.folder, 'color': AppColors.grey};
  }
}
