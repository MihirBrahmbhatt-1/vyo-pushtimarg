import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../controller/api_controller.dart';
import '../../../controller/home_controller.dart';
import '../../../model/media_list_response_model.dart';

class AudioListViewController extends GetxController
    with WidgetsBindingObserver {
  final ApiController apiController = Get.find<ApiController>();
  final HomeController homeController = Get.find<HomeController>();

  final AudioPlayer audioPlayer = AudioPlayer();
  late String subCategoryId;

  final RxString currentlyPlayingUrl = "".obs;
  final RxString currentTrackName = "".obs;
  final RxString bufferingUrl = "".obs;
  final Rx<PlayerState> playerState = PlayerState.stopped.obs;

  final Rx<Duration> currentPosition = Duration.zero.obs;
  final Rx<Duration> currentDuration = Duration.zero.obs;
  final RxDouble volume = 1.0.obs;

  final RxBool isShimmerLoading = true.obs;
  final RxString appBarTitle = ''.obs;
  final RxList<MediaModel> mediaListData = <MediaModel>[].obs;
  final ScrollController scrollController = ScrollController();
  final RxSet<int> loadedIndexes = <int>{}.obs;

  String formatDuration(Duration d) {
    if (d.inSeconds <= 0) return '00:00';
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();

    final arguments = Get.arguments as Map<String, dynamic>;
    appBarTitle.value = arguments['title'] ?? 'Audio List';
    subCategoryId = arguments['subCategoryId'] ?? '';

    fetchMediaList();
    _initAudioListeners();
    _initVolumeController();
  }

  void _initAudioListeners() {
    audioPlayer.onDurationChanged.listen((d) => currentDuration.value = d);
    audioPlayer.onPositionChanged.listen((p) => currentPosition.value = p);

    audioPlayer.onPlayerStateChanged.listen((s) {
      playerState.value = s;
      if (s == PlayerState.playing) {
        bufferingUrl.value = "";
      }
      if (s == PlayerState.stopped || s == PlayerState.paused) {
        if (bufferingUrl.value.isNotEmpty) bufferingUrl.value = "";
      }
    });

    audioPlayer.onPlayerComplete.listen((event) {
      stopPlayback();
    });
  }

  void _initVolumeController() async {
    double initialDeviceVolume = await VolumeController.instance.getVolume();
    volume.value = initialDeviceVolume;
    audioPlayer.setVolume(initialDeviceVolume);

    VolumeController.instance.addListener((newDeviceVolume) {
      if (volume.value != newDeviceVolume) {
        volume.value = newDeviceVolume;
        audioPlayer.setVolume(newDeviceVolume);
      }
    });

    ever(volume, (newVolume) {
      VolumeController.instance.setVolume(newVolume);
    });
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    VolumeController.instance.removeListener();
    super.onClose();
  }

  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  Future<void> setVolume(double vol) async {
    volume.value = vol;
    await audioPlayer.setVolume(vol);
  }

  void stopPlayback() {
    audioPlayer.stop();
    currentlyPlayingUrl.value = "";
    currentTrackName.value = "";
    bufferingUrl.value = "";
    currentPosition.value = Duration.zero;
    currentDuration.value = Duration.zero;
  }

  Future<void> handlePlaybackToggle(String name, String url) async {
    if (url.isEmpty) return;

    if (currentlyPlayingUrl.value == url) {
      if (audioPlayer.state == PlayerState.paused) {
        try {
          final cachedFile = await DefaultCacheManager().getSingleFile(url);
          await audioPlayer.play(DeviceFileSource(cachedFile.path));
        } catch (e) {
          stopPlayback();
        }
      } else {
        await audioPlayer.pause();
      }
      // currentlyPlayingUrl.value = "";
      return;
    }

    if (audioPlayer.state == PlayerState.playing ||
        audioPlayer.state == PlayerState.paused) {
      stopPlayback();
    }

    bufferingUrl.value = url;
    currentlyPlayingUrl.value = url;
    currentTrackName.value = name;

    try {
      final cachedFile = await DefaultCacheManager().getSingleFile(url);
      await audioPlayer.play(DeviceFileSource(cachedFile.path));
    } catch (e) {
      stopPlayback();
    }
  }

  Future<void> fetchMediaList() async {
    apiController.mediaListData.value = [];
    isShimmerLoading.value = true;

    try {
      if (subCategoryId.isNotEmpty) {
        await apiController.fetchMediaList(
          id: subCategoryId,
          languageId: homeController.selectedLanguageId.value,
          jwtToken: homeController.jwtToken.value,
        );
        mediaListData.value = apiController.mediaListData;
      }
    } catch (e) {
      mediaListData.clear();
    }
    isShimmerLoading.value = false;
  }

  Future<void> refreshMediaList() async {
    if (currentlyPlayingUrl.value.isNotEmpty) stopPlayback();
    await fetchMediaList();
  }

  bool handleScrollNotification(
    BuildContext context,
    ScrollNotification notification,
  ) {
    if (notification is ScrollEndNotification) {
      const double itemHeight = 120.0;
      const int prefetchCount = 6;

      var firstVisibleIndex = (scrollController.position.pixels / itemHeight)
          .floor();
      var lastVisibleIndex = firstVisibleIndex + prefetchCount;

      for (int i = firstVisibleIndex; i <= lastVisibleIndex; i++) {
        if (i < mediaListData.length) {
          loadThumbnailForIndex(context, i);
        }
      }
    }
    return false;
  }

  void loadThumbnailForIndex(BuildContext context, int index) {
    if (index >= mediaListData.length) return;
    if (loadedIndexes.contains(index)) return;

    final media = mediaListData[index];
    final thumbnailUrl = media.thumbnail;

    if (thumbnailUrl != null && thumbnailUrl.isNotEmpty) {
      try {
        precacheImage(CachedNetworkImageProvider(thumbnailUrl), context);
      } catch (e) {
        // print('Error precaching image for index $index: $e');
      }
    }

    loadedIndexes.add(index);
  }
}
