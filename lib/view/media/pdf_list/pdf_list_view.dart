import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../widget/custom_shimmer_widget.dart';
import '../../../widget/custom_text_widget.dart';
import '../../../widget/empty_data_with_retry_widget.dart';
import 'pdf_list_view_controller.dart';
import 'pdf_preview_view.dart';

class PdfListView extends GetView<PdfListViewController> {
  const PdfListView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.put(PdfListViewController());
    final dynamicAppLocalizations = DynamicAppLocalizations.of(context);

    return Scaffold(
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
          if (controller.isShimmerLoading.value) {
            return const ShimmerList();
          } else if (controller.mediaListData.isEmpty) {
            return EmptyDataWithRetry(
              messageLabel: dynamicAppLocalizations.t('no_pdf_found'),
              buttonText: dynamicAppLocalizations.t('retry'),
              onRetry: controller.refreshMediaList,
            );
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

                  return Card(
                    color: AppColors.white,
                    margin: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 8.0,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        _viewDocument(
                          DynamicAppLocalizations.of(
                            context,
                          ).t(media.name.toString()),
                          media.mediaUrl,
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              color: AppColors.red,
                              size: 30,
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomTextWidget(
                                    textString: DynamicAppLocalizations.of(
                                      context,
                                    ).t(media.name.toString()),
                                    textSize: FontSize().medium,
                                    isFontBold: true,
                                    fontColor: AppColors.black,
                                    numberOfLines: 2,
                                  ),

                                  media.description.isEmpty
                                      ? const SizedBox()
                                      : Padding(
                                          padding: const EdgeInsets.only(
                                            top: 4.0,
                                          ),
                                          child: CustomTextWidget(
                                            textString:
                                                DynamicAppLocalizations.of(
                                                  context,
                                                ).t(
                                                  media.description.toString(),
                                                ),
                                            textSize: 13,
                                            isFontBold: false,
                                            fontColor: AppColors.grey800,
                                            numberOfLines: 2,
                                          ),
                                        ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.chevron_right,
                              size: 24,
                              color: AppColors.grey,
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
    );
  }

  _viewDocument(String name, String url) {
    if (url.isEmpty) {
      return;
    }
    Get.to(() => PdfViewerScreen(title: name, pdfUrl: url));
  }
}
