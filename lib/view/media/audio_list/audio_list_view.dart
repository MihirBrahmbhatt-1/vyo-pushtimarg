import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../model/media_list_response_model.dart';
import '../../../widget/custom_shimmer_widget.dart';
import '../../../widget/custom_text_widget.dart';
import '../../../widget/empty_data_with_retry_widget.dart';
import 'audio_list_view_controller.dart';

class AudioListView extends GetView<AudioListViewController> {
  const AudioListView({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamicAppLocalizations = DynamicAppLocalizations.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: CustomTextWidget(
            textString: controller.appBarTitle.value,
            textSize: FontSize().appBar,
            fontColor: AppColors.white,
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          onRefresh: controller.refreshMediaList,
          child: Obx(() {
            if (controller.isShimmerLoading.value) {
              return const ShimmerList();
            }

            if (controller.mediaListData.isEmpty) {
              return EmptyDataWithRetry(
                messageLabel: dynamicAppLocalizations.t('no_audio_found'),
                buttonText: dynamicAppLocalizations.t('retry'),
                onRetry: controller.refreshMediaList,
                icon: Icons.music_off,
              );
            }

            return NotificationListener<ScrollNotification>(
              onNotification: (notification) =>
                  controller.handleScrollNotification(context, notification),
              child: ListView.builder(
                controller: controller.scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: controller.mediaListData.length,
                itemBuilder: (_, index) {
                  final media = controller.mediaListData[index];

                  return AudioListItem(
                    media: media,
                    controller: controller,
                    dynamicAppLocalizations: dynamicAppLocalizations,
                  );
                },
              ),
            );
          }),
        ),
        bottomNavigationBar: controller.currentlyPlayingUrl.value.isNotEmpty
            ? _buildMiniPlayer()
            : null,
      ),
    );
  }

  Widget _buildMiniPlayer() {
    final currentName = controller.currentTrackName.value;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      height: 120,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => controller.handlePlaybackToggle(
                  currentName,
                  controller.currentlyPlayingUrl.value,
                ),
                child: Obx(
                  () => Icon(
                    controller.playerState.value == PlayerState.playing
                        ? Icons.pause_circle_filled
                        : Icons.play_circle_fill,
                    color: AppColors.white,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: CustomTextWidget(
                  textString: currentName,
                  textSize: FontSize().medium,
                  isFontBold: true,
                  fontColor: AppColors.white,
                  numberOfLines: 1,
                ),
              ),

              // const Icon(Icons.volume_down, color: AppColors.white, size: 20),
              // SizedBox(
              //   width: 80,
              //   child: Obx(
              //     () => Slider(
              //       value: controller.volume.value,
              //       min: 0.0,
              //       max: 1.0,
              //       activeColor: AppColors.red,
              //       inactiveColor: AppColors.white.withValues(alpha: 0.3),
              //       onChanged: controller.setVolume,
              //     ),
              //   ),
              // ),
              // const Icon(Icons.volume_up, color: AppColors.white, size: 20),

              // Stop/Close Button
              IconButton(
                icon: const Icon(Icons.close, color: AppColors.white),
                onPressed: controller.stopPlayback,
              ),
            ],
          ),
          SizedBox(
            height: 30,
            child: Obx(
              () => Row(
                children: [
                  SizedBox(
                    width: 35,
                    child: CustomTextWidget(
                      textString: controller.formatDuration(
                        controller.currentPosition.value,
                      ),
                      textSize: FontSize().small,
                      fontColor: AppColors.white,
                    ),
                  ),

                  Expanded(
                    child: Slider(
                      value: controller.currentPosition.value.inSeconds
                          .toDouble(),
                      min: 0.0,
                      max: controller.currentDuration.value.inSeconds
                          .toDouble(),
                      activeColor: AppColors.red,
                      inactiveColor: AppColors.white.withValues(alpha: 0.3),
                      onChanged: (double value) =>
                          controller.seek(Duration(seconds: value.toInt())),
                    ),
                  ),

                  SizedBox(
                    width: 35,
                    child: CustomTextWidget(
                      textString: controller.formatDuration(
                        controller.currentDuration.value,
                      ),
                      textSize: FontSize().small,
                      fontColor: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class AudioListItem extends StatelessWidget {
  final MediaModel media;
  final AudioListViewController controller;
  final DynamicAppLocalizations dynamicAppLocalizations;

  const AudioListItem({
    super.key,
    required this.media,
    required this.controller,
    required this.dynamicAppLocalizations,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasDescription = media.description.toString().isNotEmpty;
    return Card(
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () async {
          if (controller.bufferingUrl.value != media.mediaUrl) {
            await controller.handlePlaybackToggle(
              dynamicAppLocalizations.t(media.name.toString()),
              media.mediaUrl,
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              AudioThumbnailWidget(
                url: media.thumbnail,
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextWidget(
                      textString: dynamicAppLocalizations.t(
                        media.name.toString(),
                      ),
                      textSize: FontSize().medium,
                      isFontBold: true,
                      fontColor: AppColors.black,
                      numberOfLines: 2,
                    ),
                    if (hasDescription) const SizedBox(height: 4),
                    if (hasDescription)
                      CustomTextWidget(
                        textString: dynamicAppLocalizations.t(
                          media.description.toString(),
                        ),
                        textSize: FontSize().small,
                        fontColor: AppColors.grey800,
                        numberOfLines: 10,
                      ),
                  ],
                ),
              ),
              SizedBox(width: media.description.isEmpty ? 0 : 8),
              _buildPlaybackIndicator(media),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaybackIndicator(MediaModel media) {
    final bool isPlayable = media.mediaUrl.isNotEmpty;
    if (!isPlayable) {
      return const Icon(
        Icons.warning_amber_rounded,
        size: 30,
        color: AppColors.red,
      );
    }

    return Obx(() {
      final isPlayingThisTrack =
          controller.currentlyPlayingUrl.value == media.mediaUrl;
      final isBufferingThisTrack =
          controller.bufferingUrl.value == media.mediaUrl;
      final isPlaying = controller.playerState.value == PlayerState.playing;

      if (isBufferingThisTrack) {
        return const SizedBox(
          width: 30,
          height: 30,
          child: Padding(
            padding: EdgeInsets.all(4.0),
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppColors.primaryColor,
            ),
          ),
        );
      }

      if (isPlayingThisTrack && isPlaying) {
        return const AudioVisualizerLottie();
      }

      return Icon(
        isPlayingThisTrack && isPlaying
            ? Icons.pause_circle_filled
            : Icons.play_circle_fill,
        size: 30,
        color: isPlayingThisTrack ? AppColors.primaryColor : AppColors.grey,
      );
    });
  }
}

class AudioThumbnailWidget extends StatelessWidget {
  final String? url;

  const AudioThumbnailWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    const double size = 30.0;

    if (url == null || url!.isEmpty) {
      return const SizedBox(
        width: size,
        height: size,
        child: Icon(Icons.music_note, color: AppColors.grey, size: 30),
      );
    }

    return Container(
      width: size,
      height: size,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: CachedNetworkImage(
        imageUrl: url!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          color: AppColors.grey.withValues(alpha: 0.2),
          child: const Center(child: Icon(Icons.image, color: AppColors.grey)),
        ),
        errorWidget: (context, url, error) => Container(
          color: AppColors.red.withValues(alpha: 0.1),
          child: const Center(
            child: Icon(Icons.error_outline, color: AppColors.red),
          ),
        ),
      ),
    );
  }
}

class AudioVisualizerLottie extends StatelessWidget {
  const AudioVisualizerLottie({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 30,
      child: Lottie.asset(
        'assets/lottie/audio_visualizer.json',
        repeat: true,
        reverse: false,
        animate: true,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.colorFilter(
              const ['**'],
              value: ColorFilter.mode(AppColors.primaryColor, BlendMode.srcIn),
            ),
          ],
        ),
        width: 250,
        height: 250,
      ),
    );
  }
}
