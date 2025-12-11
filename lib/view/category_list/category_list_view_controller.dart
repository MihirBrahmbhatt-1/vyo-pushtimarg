import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';

class CategoryListViewController extends GetxController
    with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final RxBool isShimmerLoading = true.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);

    fetchCategoryList();
    super.onInit();
  }

  fetchCategoryList() async {
    isShimmerLoading.value = true;
    await apiController.fetchCategoryList(
      languageId: homeController.selectedLanguageId.value,
      jwtToken: homeController.jwtToken.value,
    );
    isShimmerLoading.value = false;
  }

  Future<void> refreshCategoryList() async {
    await fetchCategoryList();
  }

  Map<String, dynamic> getMediaDetails(String categoryName) {
    const Map<String, Map<String, dynamic>> mediaTypeLookup = {
      'audio': {'icon': Icons.audiotrack, 'color': AppColors.primaryColor},
      'pdf': {'icon': Icons.picture_as_pdf, 'color': AppColors.red},
      'video': {'icon': Icons.videocam, 'color': AppColors.blue},
      'image': {'icon': Icons.image, 'color': AppColors.green},
    };

    final name = categoryName.toLowerCase();
    for (final keyword in mediaTypeLookup.keys) {
      if (name.contains(keyword) ||
          (keyword == 'image' && name.contains('images'))) {
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
