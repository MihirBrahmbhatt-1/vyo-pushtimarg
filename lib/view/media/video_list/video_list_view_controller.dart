import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:omni_video_player/omni_video_player.dart';

import '../../../const/app_color.dart';
import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../model/media_list_response_model.dart';

class VideoListViewController extends GetxController
    with WidgetsBindingObserver {
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

  String extractYoutubeId(String url) {
    final RegExp regExp = RegExp(
      r'(?:youtu\.be\/|v\/|u\/\w\/|embed\/|live\/|watch\?v=)([a-zA-Z0-9_-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(url);
    final id = match?.group(1) ?? '';
    return id;
  }

  void loadThumbnailForIndex(int index) {
    if (index >= mediaListData.length) return;
    loadedIndexes.add(index);
    final media = mediaListData[index];
    final id = extractYoutubeId(media.mediaUrl);

    if (id.isNotEmpty) {
      media.thumbnail = "https://img.youtube.com/vi/$id/hqdefault.jpg";
      update();
    } else {
      media.thumbnail = '';
      update();
    }

    if (index + 1 < mediaListData.length) {
      Future.delayed(const Duration(milliseconds: 150), () {
        loadThumbnailForIndex(index + 1);
      });
    }
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
      var last = first + 3;

      for (int i = first; i <= last; i++) {
        if (i < mediaListData.length) loadThumbnailForIndex(i);
      }
    }
    return false;
  }

  void startPreview(String url) {
    Get.to(
      () => _PreviewVideoPlayer(url: url),
      opaque: false,
      fullscreenDialog: true,
    );
  }
}

class _PreviewVideoPlayer extends StatefulWidget {
  final String url;
  const _PreviewVideoPlayer({required this.url});

  @override
  State<_PreviewVideoPlayer> createState() => _PreviewVideoPlayerState();
}

class _PreviewVideoPlayerState extends State<_PreviewVideoPlayer> {
  OmniPlaybackController? _controller;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black.withValues(alpha: 0.9),
      body: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: _controller != null
              ? OmniVideoPlayer(
                  callbacks: VideoPlayerCallbacks(
                    onControllerCreated: (controller) {
                      if (mounted) {
                        _controller = controller;
                        controller.play();
                        Future.delayed(const Duration(seconds: 5), () {
                          if (Get.isSnackbarOpen == false &&
                              Get.isDialogOpen == false) {
                            Get.back();
                          }
                        });
                      } else {
                        controller.dispose();
                      }
                    },
                  ),
                  options: VideoPlayerConfiguration(
                    videoSourceConfiguration: VideoSourceConfiguration.youtube(
                      videoUrl: Uri.parse(widget.url),
                    ),
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(color: AppColors.white),
                ),
        ),
      ),
    );
  }
}
