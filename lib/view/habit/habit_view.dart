import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../widget/custom_shimmer_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/empty_data_with_retry_widget.dart';
import 'habit_view_controller.dart';

class HabitView extends GetView<HabitViewController> {
  const HabitView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HabitViewController());
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RefreshIndicator(
            color: AppColors.white,
            backgroundColor: AppColors.primaryColor,
            onRefresh: controller.refreshHabitsApi,
            child: Obx(() {
              if (controller.isShimmerLoading.value) {
                return const ShimmerList();
              } else if (controller.userHabitListResponseModel.isEmpty) {
                return EmptyDataWithRetry(
                  messageLabel: DynamicAppLocalizations.of(
                    context,
                  ).t('no_practice_found'),
                  buttonText: DynamicAppLocalizations.of(context).t('retry'),
                  onRetry: controller.refreshHabitsApi,
                  icon: Icons.search_off_outlined,
                );
              } else {
                return RefreshIndicator(
                  onRefresh: controller.refreshHabitsApi,
                  child: ListView(
                    controller: controller.scrollController,
                    children: controller.groupedHabits.entries.map((entry) {
                      final typeName = entry.key;
                      final items = entry.value;
                  
                      return Card(
                        color: AppColors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(borderRadius),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                  horizontal: 16,
                                ),
                                child: CustomTextWidget(
                                  textString: typeName,
                                  textSize: FontSize().medium,
                                  fontColor: AppColors.white,
                                  isFontBold: true,
                                  numberOfLines: 1,
                                ),
                              ),
                            ),
                  
                            ...items.asMap().entries.map((entry) {
                              final index = entry.key;
                              final user = entry.value;
                              final isLastItem = index == items.length - 1;
                  
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CustomTextWidget(
                                              textString: user.name ?? "",
                                              textSize: FontSize().regular,
                                              fontColor: AppColors.black,
                                              isFontBold: false,
                                            ),
                                            const SizedBox(height: 4),
                                            CustomTextWidget(
                                              textString: user.mobileNo ?? "",
                                              textSize: FontSize().small,
                                              fontColor: AppColors.black,
                                              isFontBold: false,
                                            ),
                                          ],
                                        ),
                  
                                        // RIGHT SIDE (Phone Icon)
                                        IconButton(
                                          icon: const Icon(Icons.phone),
                                          onPressed: () =>
                                              controller.launchUrlFunction(
                                                context,
                                                user.mobileNo.toString(),
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!isLastItem)
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 16.0,
                                      ),
                                      child: Divider(
                                        height: 1,
                                        thickness: 1,
                                        color: AppColors.grey200,
                                      ),
                                    ),
                                ],
                              );
                            }),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
            }),
          ),
        ),
      ),
    );
  }

}
