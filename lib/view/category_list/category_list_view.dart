import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../widget/custom_shimmer_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/empty_data_with_retry_widget.dart';
import 'category_list_view_controller.dart';

class CategoryListView extends GetView<CategoryListViewController> {
  const CategoryListView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(CategoryListViewController());

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: RefreshIndicator(
            color: AppColors.white,
            backgroundColor: AppColors.primaryColor,
            onRefresh: controller.refreshCategoryList,
            child: Obx(() {
              final dynamicAppLocalizations = DynamicAppLocalizations.of(
                Get.context!,
              );
              if (controller.isShimmerLoading.value) {
                return const ShimmerGrid();
              } else if (controller.apiController.categoryListData.isEmpty) {
                return EmptyDataWithRetry(
                  messageLabel: dynamicAppLocalizations.t(
                    'no_categories_found',
                  ),
                  buttonText: dynamicAppLocalizations.t('retry'),
                  onRetry: controller.refreshCategoryList,
                  icon: Icons.category_outlined,
                );
              } else {
                return GridView.builder(
                  primary: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.apiController.categoryListData.length,
                  itemBuilder: (_, index) {
                    final categoryObj =
                        controller.apiController.categoryListData[index];
                    final categoryNameKey = categoryObj.categoryName.toString();
                    final categoryName = dynamicAppLocalizations.t(
                      categoryNameKey,
                    );
                    final mediaDetails = controller.getMediaDetails(
                      categoryObj.categoryType.toString(),
                    );
                    return CategoryGridItem(
                      categoryObj: categoryObj,
                      categoryName: categoryName,
                      mediaDetails: mediaDetails,
                    );
                  },
                );
              }
            }),
          ),
        ),
      ),
    );
  }
}

class CategoryGridItem extends StatelessWidget {
  final dynamic categoryObj;
  final String categoryName;
  final Map<String, dynamic> mediaDetails;

  const CategoryGridItem({
    super.key,
    required this.categoryObj,
    required this.categoryName,
    required this.mediaDetails,
  });

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.subCategoryview,
          arguments: {"categoryObj": categoryObj, 'title': categoryName},
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: AppColors.grey.withValues(alpha: 0.2)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (mediaDetails['color'] as Color).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                child: Icon(
                  mediaDetails['icon'] as IconData,
                  size: 36,
                  color: mediaDetails['color'] as Color,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: CustomTextWidget(
                  fontColor: AppColors.black,
                  textString: categoryName,
                  isFontBold: true,
                  textSize: FontSize().regular,
                  textCenter: true,
                  numberOfLines: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
