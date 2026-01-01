import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../widget/custom_text_widget.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> images;
  final int initialIndex;
  final String redirectUrl;

  const ImageViewerPage({
    super.key,
    required this.images,
    required this.initialIndex,
    this.redirectUrl = '',
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late int _currentIndex;

  final Map<int, TransformationController> _transformControllers = {};
  final Map<int, AnimationController> _animationControllers = {};

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
  }

  TransformationController _getTransformController(int index) {
    return _transformControllers.putIfAbsent(
      index,
      () => TransformationController(),
    );
  }

  AnimationController _getAnimationController(int index) {
    return _animationControllers.putIfAbsent(
      index,
      () => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
  }

  void _handleDoubleTap(int index, TapDownDetails details) {
    final controller = _getTransformController(index);
    final animationController = _getAnimationController(index);

    animationController.stop();

    final currentScale = controller.value.storage[0];
    final double targetScale = currentScale < 1.5 ? 2.5 : 1.0;

    final Matrix4 begin = controller.value;
    final Matrix4 end;

    if (targetScale == 1.0) {
      end = Matrix4.identity();
    } else {
      final position = details.localPosition;
      end = Matrix4.identity()
        ..translate(
          -position.dx * (targetScale - 1),
          -position.dy * (targetScale - 1),
        )
        ..scale(targetScale);
    }

    final animation = Matrix4Tween(begin: begin, end: end).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );

    animationController.addListener(() {
      controller.value = animation.value;
    });

    animationController.forward(from: 0);
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _transformControllers.values) {
      c.dispose();
    }
    for (final a in _animationControllers.values) {
      a.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showRedirectButton = widget.redirectUrl.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.transparent,
      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: AppColors.black.withValues(alpha: 0.6),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.images.length,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemBuilder: (context, index) {
                  final imageUrl = widget.images[index];

                  return GestureDetector(
                    onTap: () {
                      final scale =
                          _getTransformController(index).value.storage[0];
                      if (scale < 1.01) Navigator.pop(context);
                    },
                    onDoubleTapDown: (details) =>
                        _handleDoubleTap(index, details),
                    child: Center(
                      child: Hero(
                        tag: imageUrl,
                        child: InteractiveViewer(
                          transformationController:
                              _getTransformController(index),
                          panEnabled: true,
                          minScale: 1.0,
                          maxScale: 4.0,
                          child: CachedNetworkImage(
                            imageUrl: imageUrl,
                            fit: BoxFit.contain,
                            width: double.infinity,
                            height: double.infinity,
                            placeholder: (_, __) => const Center(
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                              ),
                            ),
                            errorWidget: (_, __, ___) => const Icon(
                              Icons.error,
                              color: AppColors.red,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              Positioned(
                top: 50,
                right: 20,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: CustomTextWidget(
                              textString: '${_currentIndex + 1} / ${widget.images.length}',
                              textSize: FontSize().regular,
                              fontColor: AppColors.white,
                              isFontUnderline: false,
                            ),
                ),
              ),

              Positioned(
                top: 40,
                left: 15,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.black.withValues(alpha: 0.6),
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

              if (showRedirectButton)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          _launchUrl(context, widget.redirectUrl),
                      icon: const Icon(Icons.arrow_forward),
                      label: CustomTextWidget(
                        textString: DynamicAppLocalizations.of(
                          Get.context!,
                        ).t("navigate"),
                        textSize: FontSize().regular,
                        fontColor: AppColors.primaryColor,
                        isFontBold: false,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.white.withValues(alpha: 0.9),
                        foregroundColor: AppColors.primaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
