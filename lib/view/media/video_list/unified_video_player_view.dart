import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:omni_video_player/omni_video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../const/app_color.dart';
import 'video_platform.dart';

class UnifiedVideoPlayer extends StatefulWidget {
  final String url;
  final String title;

  const UnifiedVideoPlayer({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<UnifiedVideoPlayer> createState() => _UnifiedVideoPlayerState();
}

class _UnifiedVideoPlayerState extends State<UnifiedVideoPlayer> {
  YoutubePlayerController? _ytController;
  OmniPlaybackController? _omniController;
  WebViewController? _webController;

  late final VideoPlatform _platform;
  late final Uri _uri;

  // ignore: unused_field
  double _bufferedPercentage = 0.0;
  Timer? _watchdog;

  @override
  void initState() {
    super.initState();

    final normalizedUrl = normalizeYouTubeUrl(widget.url);
    _uri = Uri.parse(normalizedUrl);
    _platform = detectVideoPlatform(normalizedUrl);

    _initControllers();
  }

  String normalizeYouTubeUrl(String url) {
    if (url.startsWith('http://')) {
      return url.replaceFirst('http://', 'https://');
    }
    return url;
  }

  void _initControllers() {
    if (_platform == VideoPlatform.youtube) {
      final normalizedUrl = normalizeYouTubeUrl(widget.url);
      final videoId = YoutubePlayer.convertUrlToId(normalizedUrl);
      if (videoId != null) {
        _ytController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            loop: false,
            enableCaption: true,
            disableDragSeek: false,
            hideControls: false,
            hideThumbnail: false,
            controlsVisibleAtStart: true,
            forceHD: false,
            showLiveFullscreenButton: false,
          ),
        );

        _ytController!.addListener(() {
          final value = _ytController!.value;
          setState(() {
            _bufferedPercentage =
                (value.buffered / value.metaData.duration.inSeconds) * 100;
          });
        });
      }
    }

    if (_platform == VideoPlatform.instagram ||
        _platform == VideoPlatform.facebook ||
        _platform == VideoPlatform.tiktok ||
        _platform == VideoPlatform.twitter) {
      _webController = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(_uri);
    }
  }

  @override
  void dispose() {
    _watchdog?.cancel();
    _ytController?.dispose();
    _omniController?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
      // DeviceOrientation.landscapeLeft,
    ]);
    super.dispose();
  }

  // void _openExternally() async {
  //   if (await canLaunchUrl(_uri)) {
  //     await launchUrl(_uri, mode: LaunchMode.externalApplication);
  //     if (mounted) Get.back();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: Stack(
        children: [
          _buildPlayer(),
          _closeButton(),
          // if (_bufferedPercentage < 100)
          //   _loadingIndicator(),
        ],
      ),
    );
  }

  Widget _buildPlayer() {
    switch (_platform) {
      case VideoPlatform.youtube:
        return _buildYouTube();
      case VideoPlatform.instagram:
      case VideoPlatform.facebook:
      case VideoPlatform.tiktok:
      case VideoPlatform.twitter:
        return _buildWebView();
      case VideoPlatform.vimeo:
      case VideoPlatform.direct:
        return _buildOmni();
      default:
        return _unsupported();
    }
  }

  Widget _buildYouTube() {
    if (_ytController == null) return _unsupported();
    return _blurWrapper(
      child: YoutubePlayer(
        controller: _ytController!,
        onReady: () {
          _ytController!.play();
        },
        onEnded: (metadata) {
          // print("Video Ended: ${metadata.title} $metadata");
        },
      ),
    );
  }

  Widget _buildOmni() {
    return _blurWrapper(
      child: OmniVideoPlayer(
        callbacks: VideoPlayerCallbacks(
          onControllerCreated: (controller) {
            _omniController?.dispose();
            _omniController = controller;
            controller.play();
          },
        ),
        options: VideoPlayerConfiguration(
          videoSourceConfiguration:
              VideoSourceConfiguration.network(videoUrl: _uri),
        ),
      ),
    );
  }

  Widget _buildWebView() {
    return _blurWrapper(
      child: WebViewWidget(controller: _webController!),
    );
  }

  Widget _blurWrapper({required Widget child}) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Container(
        color: AppColors.black.withValues(alpha: 0.3),
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: child,
          ),
        ),
      ),
    );
  }

  // Widget _loadingIndicator() {
  //   return Positioned(
  //     top: MediaQuery.of(context).size.height * 0.4,
  //     left: MediaQuery.of(context).size.width * 0.4,
  //     child: const CircularProgressIndicator(
  //       color: Colors.white,
  //     ),
  //   );
  // }

  Widget _closeButton() {
    return Positioned(
      top: 10,
      left: 10,
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            _ytController?.pause();
            _omniController?.pause();
            SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
            Get.back();
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.black.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(8),
            child: const Icon(Icons.close, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _unsupported() {
    return const Center(
      child: Text(
        'Unsupported video source',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
