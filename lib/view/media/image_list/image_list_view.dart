import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../widget/custom_shimmer_widget.dart';
import '../../../widget/custom_text_widget.dart';
import '../../../widget/empty_data_with_retry_widget.dart';

import 'image_list_view_controller.dart';
import 'image_preview_view.dart';

class ImageListView extends GetView<ImageListViewController> {
  const ImageListView({super.key});

  bool _isHeicOrHeif(String url) {
    final lowerCaseUrl = url.toLowerCase();
    return lowerCaseUrl.endsWith('.heic') || lowerCaseUrl.endsWith('.heif');
  }

  @override
  Widget build(BuildContext context) {
    final dynamicAppLocalizations = DynamicAppLocalizations.of(context);

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: Obx(
            () => CustomTextWidget(
              uiKey: const Key('lbl-nav-title'),
              textString: controller.appBarTitle.value,
              textSize: FontSize().appBar,
              isFontBold: false,
              fontColor: AppColors.white,
              isFontUnderline: false,
              fontStyle: FontStyle.normal,
            ),
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          onRefresh: controller.refreshMediaList,
          child: Obx(() {
            if (controller.isShimmerLoading.value) {
              return const ShimmerGrid();
            } else if (controller.mediaListData.isEmpty) {
              return EmptyDataWithRetry(
                messageLabel: dynamicAppLocalizations.t('no_image_found'),
                buttonText: dynamicAppLocalizations.t('retry'),
                onRetry: controller.refreshMediaList,
                icon: Icons.collections_bookmark_outlined,
              );
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: controller.handleScrollNotification,
                child: GridView.builder(
                  controller: controller.scrollController,
                  itemCount: controller.mediaListData.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1.0,
                  ),
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final media = controller.mediaListData[index];
                    controller.loadThumbnailForIndex(index);
                    return _buildGridTile(context, media.mediaUrl, index);
                  },
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildGridTile(BuildContext context, String imageUrl, int index) {
    final media = controller.mediaListData[index];
    final bool requiresHeicConversion = _isHeicOrHeif(imageUrl);
    final bool hasLoaded = controller.hasLoaded(index);

    Widget imageContent;

    if (!hasLoaded) {
      imageContent = _buildPlaceholder();
    } else if (requiresHeicConversion) {
      imageContent = FutureBuilder<String>(
        future: controller.convertHeifToJpg(imageUrl),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildConversionSpinner();
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              (snapshot.data?.isEmpty ?? true)) {
            return _buildErrorState(
              DynamicAppLocalizations.of(Get.context!).t('failed'),
              true,
              error: snapshot.error,
            );
          }
          return Image.file(
            File(snapshot.data!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildErrorState(
              DynamicAppLocalizations.of(Get.context!).t('failed'),
              false,
            ),
          );
        },
      );
    } else {
      imageContent = _buildCachedImage(imageUrl);
    }

    return Card(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(borderRadius),
        onTap: () {
          Get.to(
            () => ImageViewerPage(
              images: controller.mediaListData.map((e) => e.mediaUrl).toList(),
              initialIndex: index,
              redirectUrl: '',
            ),
          );
        },
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Hero(tag: media.mediaUrl, child: imageContent),
        ),
      ),
    );
  }

  Widget _buildConversionSpinner() {
    return Center(
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.grey200,
      child: const Center(
        child: Icon(Icons.image_outlined, color: AppColors.grey, size: 30),
      ),
    );
  }

  Widget _buildCachedImage(String imageUrl) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      memCacheWidth: 400,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            value: downloadProgress.progress,
            strokeWidth: 2,
            color: AppColors.primaryColor,
          ),
        ),
      ),
      errorWidget: (context, url, error) =>
          _buildErrorState('Failed to load image', false),
    );
  }

  // 💡 HELPER: Unified Error State
  Widget _buildErrorState(
    String message,
    bool requiresHeicConversion, {
    Object? error,
  }) {
    String detailedMessage = requiresHeicConversion
        ? '$message: HEIC/HEIF Conversion issue.'
        : message;

    return Container(
      color: AppColors.grey,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: AppColors.red),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
              child: CustomTextWidget(
                textString: detailedMessage,
                textSize: FontSize().small,
                fontColor: AppColors.grey800,
                numberOfLines: 3,
                textCenter: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
