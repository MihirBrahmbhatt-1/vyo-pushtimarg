import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../utility/common_functions.dart';
import '../../widget/custom_no_internet_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'sub_category_view_controller.dart';

class SubCategoryView extends GetView<SubCategoryViewController> {
  const SubCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SubCategoryViewController());

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Obx(
        () => SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
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
            body: controller.homeController.isDisplayInternetConnection.value ?
                Center(
                  child: CustomNoInternetWidget(
                      displayMessage: controller.displayInternetConnection.isEmpty
                      ? ""
                      : controller.displayInternetConnection.value,
                      onPressed: () async {
                        await checkInternetStatus(
                          onConnected: () async {
                            controller.homeController.isDisplayInternetConnection.value = false;
                            // controller.fetchUserDetails();
                          },
                          onNoConnection: () {
                            controller.homeController.isDisplayInternetConnection.value = true;
                          },
                        );
                      },
                    ),
                )
                 :SingleChildScrollView(
              child: SizedBox(
                height: Get.height * 0.90,
                child: controller.subCategory.isEmpty
                    ? Center(
                        child: CustomTextWidget(
                          textString: DynamicAppLocalizations.of(
                            context,
                          ).t('no_sub_category_found'),
                          textSize: FontSize().appBar,
                          isFontBold: false,
                          fontColor: AppColors.red,
                          isFontUnderline: false,
                          fontStyle: FontStyle.normal,
                        ),
                      )
                    : ListView.builder(
                        itemCount: controller.subCategory.length,
                        itemBuilder: (_, index) {
                          final categoryObj = controller.subCategory[index];
          
                          final String? thumbnailUrl =
                              categoryObj.subCategoryThumbnailUrl;
                          final bool hasThumbnail =
                              thumbnailUrl != null && thumbnailUrl.isNotEmpty;
                          return Card(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            child: GestureDetector(
                              onTap: () async {
                                final categoryType = controller
                                    .categoryList
                                    .categoryType
                                    .toString();
                                final subCategoryId = categoryObj.subCategoryId
                                    .toString();
                                final title = categoryObj.subCategoryName
                                    .toString();
          
                                String? routeName;
                                if (categoryType == '2') {
                                  routeName = Routes.videolist;
                                } else if (categoryType == '1') {
                                  routeName = Routes.imagelist;
                                } else if (categoryType == '3') {
                                  routeName = Routes.pdflist;
                                } else if (categoryType == '4') {
                                  routeName = Routes.audiolist;
                                }
          
                                if (routeName != null) {
                                  Get.toNamed(
                                    routeName,
                                    arguments: {
                                      'subCategoryId': subCategoryId,
                                      'title': title,
                                    },
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        borderRadius,
                                      ),
                                      child: hasThumbnail
                                          ? Image.network(
                                              thumbnailUrl,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                    return Container(
                                                      width: 60,
                                                      height: 60,
                                                      color: AppColors.grey
                                                          .withValues(alpha: 0.3),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.broken_image,
                                                          size: 30,
                                                          color:
                                                              AppColors.grey800,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                            )
                                          : Container(
                                              width: 60,
                                              height: 60,
                                              color: AppColors.grey.withValues(
                                                alpha: 0.1,
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.collections,
                                                  size: 35,
                                                  color: AppColors.grey800,
                                                ),
                                              ),
                                            ),
                                    ),
          
                                    const SizedBox(width: 16.0),
          
                                    Expanded(
                                      child: CustomTextWidget(
                                        fontColor: AppColors.black,
                                        textString:
                                            DynamicAppLocalizations.of(
                                              Get.context!,
                                            ).t(
                                              categoryObj.subCategoryName
                                                  .toString(),
                                            ),
                                        isFontBold: false,
                                        isFontUnderline: false,
                                        textSize: FontSize().regular,
                                        fontStyle: FontStyle.normal,
                                        numberOfLines: 2,
                                      ),
                                    ),
          
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 16,
                                      color: AppColors.grey800,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
