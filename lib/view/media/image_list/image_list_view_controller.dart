import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:get/get.dart';
import 'package:heif_converter/heif_converter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../model/media_list_response_model.dart';

class ImageListViewController extends GetxController
    with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  RxSet<int> loadedIndexes = <int>{}.obs;
  RxList<MediaModel> mediaListData = <MediaModel>[].obs;

  final RxBool isShimmerLoading = true.obs;
  RxString appBarTitle = ''.obs;

  final RxMap<String, String> _convertedImagePaths = <String, String>{}.obs;

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
    subCategoryId = Get.arguments['subCategoryId'];
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

  Future<String> convertHeifToJpg(String heicUrl) async {
    if (_convertedImagePaths.containsKey(heicUrl)) {
      return _convertedImagePaths[heicUrl]!;
    }

    if (!heicUrl.toLowerCase().endsWith('.heic') &&
        !heicUrl.toLowerCase().endsWith('.heif')) {
      return heicUrl;
    }

    final String jpgKey = 'converted_${heicUrl.hashCode}.jpg';
    final convertedFileInfo = await DefaultCacheManager().getFileFromCache(
      jpgKey,
    );
    if (convertedFileInfo != null) {
      _convertedImagePaths[heicUrl] = convertedFileInfo.file.path;
      return convertedFileInfo.file.path;
    }

    File? heicFileToConvert;
    String? convertedPath;

    try {
      final heicFileInfo = await DefaultCacheManager().getSingleFile(heicUrl);
      heicFileToConvert = heicFileInfo;

      final directory = await getTemporaryDirectory();
      final jpgPath = path.join(directory.path, jpgKey);

      final resultPath = await HeifConverter.convert(
        heicFileToConvert.path,
        output: jpgPath,
      );

      if (resultPath == null || resultPath.isEmpty) {
        throw Exception('HeifConverter returned an empty or null path.');
      }
      convertedPath = resultPath;
      await DefaultCacheManager().putFile(
        jpgKey,
        await File(convertedPath).readAsBytes(),
        fileExtension: 'jpg',
      );

      _convertedImagePaths[heicUrl] = convertedPath;

      return convertedPath;
    } catch (e) {
      debugPrint('HEIC/HEIF Conversion Error for $heicUrl: $e');
      // Re-throw to be caught by FutureBuilder
      rethrow;
    } finally {}
  }
}
