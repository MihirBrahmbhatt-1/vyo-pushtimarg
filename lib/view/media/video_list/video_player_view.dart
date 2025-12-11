import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omni_video_player/omni_video_player.dart';

import '../../../const/app_color.dart';

class VideoPlayerView extends StatefulWidget {
  final String url;
  final String title;
  final String heroTag;

  const VideoPlayerView({
    super.key,
    required this.url,
    required this.title,
    required this.heroTag,
  });

  @override
  State<VideoPlayerView> createState() => _VideoPlayerViewState();
}

class _VideoPlayerViewState extends State<VideoPlayerView> {
  OmniPlaybackController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: AppColors.black.withValues(alpha: 0.3),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(1),
                    child: OmniVideoPlayer(
                      callbacks: VideoPlayerCallbacks(
                        onControllerCreated: (controller) {
                          if (mounted) {
                            _controller = controller;
                            controller.play();
                          } else {
                            controller.dispose();
                          }
                        },
                      ),
                      options: VideoPlayerConfiguration(
                        videoSourceConfiguration:
                            VideoSourceConfiguration.youtube(
                              videoUrl: Uri.parse(widget.url),
                              preferredQualities: [
                                OmniVideoQuality.high720,
                                OmniVideoQuality.medium480,
                              ],
                            ),

                        playerUIVisibilityOptions: PlayerUIVisibilityOptions()
                            .copyWith(
                              showPlaybackSpeedButton: true,
                              showFullScreenButton: true,
                              showThumbnailAtStart: true,
                              showGradientBottomControl: true,
                              enableForwardGesture: true,
                              useSafeAreaForBottomControls: true,
                            ),

                        customPlayerWidgets: CustomPlayerWidgets().copyWith(
                          loadingWidget: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primaryColor,
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            left: 10,
            child: SafeArea(
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.close,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
