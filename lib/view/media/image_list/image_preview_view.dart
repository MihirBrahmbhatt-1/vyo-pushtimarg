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
  final String imageUrl;
  final String redirectUrl;

  const ImageViewerPage({
    super.key,
    required this.imageUrl,
    this.redirectUrl = '',
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage>
    with SingleTickerProviderStateMixin {
  late final TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();

    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 300),
        )..addListener(() {
          if (_animation != null) {
            _transformationController.value = _animation!.value;
          }
        });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTap(TapDownDetails details) {
    _animationController.stop();
    final currentScale = _transformationController.value.storage[0];
    final double targetScale = currentScale.abs() < 1.01 ? 2.0 : 1.0;
    final Matrix4 beginValue = _transformationController.value;
    final Matrix4 endValue;

    if (targetScale == 1.0) {
      endValue = Matrix4.identity();
    } else {
      final position = details.localPosition;
      final double translateX = -position.dx * (targetScale - 1);
      final double translateY = -position.dy * (targetScale - 1);
      final Matrix4 scaleMatrix = Matrix4.diagonal3Values(
        targetScale,
        targetScale,
        1.0,
      );
      final Matrix4 translateMatrix = Matrix4.translationValues(
        translateX,
        translateY,
        0.0,
      );
      endValue = translateMatrix.clone()..multiply(scaleMatrix);
    }
    _animation = Matrix4Tween(begin: beginValue, end: endValue).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward(from: 0.0);
  }

  Future<void> _launchUrl(BuildContext context, String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    final bool showRedirectButton = widget.redirectUrl.isNotEmpty;
    return Scaffold(
      backgroundColor: AppColors.transparent,

      body: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
        child: Container(
          color: AppColors.black.withValues(alpha: 0.5),

          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  final currentScale =
                      _transformationController.value.storage[0];
                  if (currentScale.abs() < 1.01) {
                    Navigator.pop(context);
                  }
                },
                onDoubleTapDown: _handleDoubleTap,
                child: Center(
                  child: Hero(
                    tag: widget.imageUrl,
                    child: Material(
                      color: AppColors.transparent,
                      child: InteractiveViewer(
                        transformationController: _transformationController,
                        panEnabled: true,
                        minScale: 1.0,
                        maxScale: 4.0,
                        child: CachedNetworkImage(
                          imageUrl: widget.imageUrl,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          ),
                          fit: BoxFit.contain,
                          height: double.infinity,
                          width: double.infinity,
                          errorWidget: (context, url, error) => const Icon(
                            Icons.error,
                            color: AppColors.red,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              if (showRedirectButton)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                    child: ElevatedButton.icon(
                      onPressed: () => _launchUrl(context, widget.redirectUrl),
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
                        foregroundColor: AppColors.primaryColor,
                        backgroundColor: AppColors.white.withValues(alpha: 0.9),
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
              Align(
                alignment: Alignment.topLeft,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
