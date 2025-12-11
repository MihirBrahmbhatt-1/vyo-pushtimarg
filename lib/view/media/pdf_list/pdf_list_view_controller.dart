import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../model/media_list_response_model.dart';

class PdfListViewController extends GetxController with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  RxSet<int> loadedIndexes = <int>{}.obs;
  RxList<MediaModel> mediaListData = <MediaModel>[].obs;
  final RxBool isShimmerLoading = true.obs;

  RxString appBarTitle = ''.obs;

  late String subCategoryId;

  final ScrollController scrollController = ScrollController();

  bool hasLoaded(int index) => loadedIndexes.contains(index);

  void markLoaded(int index) {
    loadedIndexes.add(index);
  }

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    appBarTitle.value = Get.arguments['title'];
    fetchMediaList();
  }

  fetchMediaList() async {
    subCategoryId = Get.arguments['subCategoryId'] ?? '';
    if (subCategoryId.isNotEmpty) {
      apiController.mediaListData.value = [];
      isShimmerLoading.value = true;
      await apiController.fetchMediaList(
        id: subCategoryId,
        languageId: homeController.selectedLanguageId.value,
        jwtToken: homeController.jwtToken.value,
      );

      mediaListData.value = apiController.mediaListData;
      isShimmerLoading.value = false;
    }
  }

  Future<void> refreshMediaList() async {
    await fetchMediaList();
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification) {
      var first = scrollController.position.pixels ~/ 120;
      var last = first + 6;

      for (int i = first; i <= last; i++) {
        if (i < mediaListData.length) loadThumbnailForIndex(i);
      }
    }
    return false;
  }

  void loadThumbnailForIndex(int index) {
    if (loadedIndexes.contains(index)) return;
    loadedIndexes.add(index);
    update();
    for (int i = 1; i <= 5; i++) {
      int nextIndex = index + i;
      if (nextIndex < mediaListData.length &&
          !loadedIndexes.contains(nextIndex)) {
        loadedIndexes.add(nextIndex);
      }
    }
  }
}
