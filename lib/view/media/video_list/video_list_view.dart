import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../utility/common_functions.dart';
import '../../../widget/custom_no_internet_widget.dart';
import '../../../widget/custom_text_widget.dart';
import 'unified_video_player_view.dart';
import 'video_list_view_controller.dart';
// import 'video_player_view.dart';

class VideoListView extends GetView<VideoListViewController> {
  const VideoListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(VideoListViewController());

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: CustomTextWidget(
            uiKey: const Key('lbl-nav-title'),
            textString: controller.appBarTitle.value,
            textSize: FontSize().appBar,
            isFontBold: false,
            fontColor: AppColors.white,
            isFontUnderline: false,
            fontStyle: FontStyle.normal,
          ),
        ),
        body: RefreshIndicator(
          color: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          onRefresh: controller.refreshMediaList,
          child: Obx(() {
            if(controller.homeController.isDisplayInternetConnection.value) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: CustomNoInternetWidget(
                                        displayMessage: controller.displayInternetConnection.isEmpty
                        ? ""
                        : controller.displayInternetConnection.value,
                        onPressed: () async {
                          await checkInternetStatus(
                            onConnected: () async {
                              controller.homeController.isDisplayInternetConnection.value = false;
                              // controller.fetchUserDetails();
                              await controller.refreshMediaList();
                            },
                            onNoConnection: () {
                              controller.homeController.isDisplayInternetConnection.value = true;
                            },
                          );
                        },
                      ),
                  ),
                );
              }
            if (controller.isShimmerLoading.value) {
              return _buildShimmerGrid();
            } else if (controller.mediaListData.isEmpty) {
              return _buildEmptyState(context);
            } else {
              return NotificationListener<ScrollNotification>(
                onNotification: controller.handleScrollNotification,
                child: ListView.builder(
                  controller: controller.scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.mediaListData.length,
                  itemBuilder: (_, index) {
                    final media = controller.mediaListData[index];
                    controller.loadThumbnailForIndex(index);
      
                    // final heroTag = 'video-hero-${media.mediaUrl}-$index';
      
                    return Card(
                      color: AppColors.white,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(borderRadius),
                        onTap: () {
                          // Get.to(
                          //   () => VideoPlayerView(
                          //     title: media.name,
                          //     url: media.mediaUrl,
                          //     heroTag: heroTag,
                          //   ),
                          //   opaque: false,
                          //   transition: Transition.fadeIn,
                          // );
                          Get.to(
                            () => UnifiedVideoPlayer(
                              title: media.name,
                              url: media.mediaUrl,
                              // heroTag: heroTag,
                            ),
                            opaque: false,
                            // transition: Transition.fadeIn,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(borderRadius),
                                ),
                                child: AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: media.thumbnail == null
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1.5,
                                            color: AppColors.primaryColor,
                                          ),
                                        )
                                      : Image.network(
                                          media.thumbnail!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomTextWidget(
                                            textString:
                                                DynamicAppLocalizations.of(
                                                  context,
                                                ).t(media.name.toString()),
                                            textSize: FontSize().medium,
                                            isFontBold: true,
                                            fontColor: AppColors.black,
                                            numberOfLines: 10,
                                          ),
      
                                          SizedBox(
                                            height: media.description.isEmpty
                                                ? 0
                                                : 4,
                                          ),
      
                                          media.description.isEmpty
                                              ? const SizedBox()
                                              : CustomTextWidget(
                                                  textString:
                                                      DynamicAppLocalizations.of(
                                                        context,
                                                      ).t(
                                                        media.description
                                                            .toString(),
                                                      ),
                                                  textSize: FontSize().regular,
                                                  isFontBold: false,
                                                  fontColor: AppColors.grey800,
                                                  numberOfLines: 20,
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),

      itemCount: 10,
      itemBuilder: (_, __) {
        return Shimmer.fromColors(
          baseColor: AppColors.grey.withValues(alpha: 0.3),
          highlightColor: AppColors.grey.withValues(alpha: 0.1),
          child: _buildShimmerCard(),
        );
      },
    );
  }

  Widget _buildShimmerCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 26,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 16,
              width: double.infinity,
              color: AppColors.white,
            ),
            const SizedBox(height: 8),
            Container(height: 16, width: 80, color: AppColors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final controller = Get.find<VideoListViewController>();

    return Center(
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.videocam_off_outlined,
              size: 80,
              color: AppColors.grey.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 24),

            CustomTextWidget(
              textString: DynamicAppLocalizations.of(
                Get.context!,
              ).t("no_videos_available"),
              textSize: FontSize().large,
              fontColor: AppColors.grey800,
              isFontBold: true,
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                controller.refreshMediaList();
              },
              icon: const Icon(Icons.refresh),
              label: CustomTextWidget(
                textString: DynamicAppLocalizations.of(Get.context!).t("retry"),
                textSize: FontSize().medium,
                isFontBold: true,
                fontColor: AppColors.white,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
