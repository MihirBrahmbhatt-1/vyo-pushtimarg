import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../widget/custom_elevated_button_widget.dart';
import '../../widget/custom_text_field_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'user_details_view_controller.dart';

class UserDetailsView extends GetView<UserDetailsViewController> {
  const UserDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(UserDetailsViewController());
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primaryColor,
              centerTitle: true,
              title: CustomTextWidget(
                textString: DynamicAppLocalizations.of(Get.context!).t("profile"),
                textSize: FontSize().appBar,
                isFontBold: false,
                fontColor: AppColors.white,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: controller.isFetchingData.value
                    ? _buildShimmerLayout()
                    : Form(
                        key: controller.formKey.value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            CustomTextFormFieldWidget(
                              controller: controller.nameController.value,
                              isOutlineBorder: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              label: DynamicAppLocalizations.of(context).t("name"),
                              style: TextStyle(),
                              enabledColor: AppColors.primaryColor,
                              cursorColor: AppColors.primaryColor,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return DynamicAppLocalizations.of(context).t("name_is_required");
                                }
                                return null;
                              },
                              onChanged: (val) {},
                              inputFormatters: [],
                            ),
                            const SizedBox(height: 16),
                            CustomTextFormFieldWidget(
                              controller: controller.emailTextController.value,
                              isOutlineBorder: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              label: "${DynamicAppLocalizations.of(context).t("email")} ${DynamicAppLocalizations.of(context).t("optional")}",
                              style: TextStyle(),
                              enabledColor: AppColors.primaryColor,
                              cursorColor: AppColors.primaryColor,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return null;
                                }
                                if (!GetUtils.isEmail(v.trim())) {
                                  return DynamicAppLocalizations.of(context).t("enter_valid_email");
                                }
                                return null;
                              },
                              onChanged: (val) {},
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"[ ]")),
                              ],
                            ),
                            SizedBox(height: 14),
                            // PHONE (READ ONLY)
                            CustomTextFormFieldWidget(
                              controller: controller.phoneController,
                              isOutlineBorder: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              label: DynamicAppLocalizations.of(context).t("phone_number"),
                              style: TextStyle(),
                              readOnly: true,
                              filled: false,
                              enabled: false,
                              enabledColor: AppColors.grey,
                              cursorColor: AppColors.grey,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // validator: (value) {},
                              onChanged: (val) {},
                              inputFormatters: [],
                            ),
                            const SizedBox(height: 14),
                            CustomTextWidget(
                              textString: DynamicAppLocalizations.of(
                                Get.context!,
                              ).t("address"),
                              textSize: FontSize().regular,
                              isFontBold: false,
                              fontColor: AppColors.primaryColor,
                              isFontUnderline: false,
                              textCenter: false,
                              fontStyle: FontStyle.normal,
                            ),
                            const SizedBox(height: 4),
                            CustomTextWidget(
                              textString:
                                  '${controller.homeController.userCityName.toString()}, ${controller.homeController.userStateName.toString()}, ${controller.homeController.userCountryName.toString()}',
                              textSize: FontSize().regular,
                              isFontBold: false,
                              fontColor: AppColors.black,
                              isFontUnderline: false,
                              textCenter: false,
                              fontStyle: FontStyle.normal,
                            ),
                            const SizedBox(height: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomTextWidget(
                                  textString: DynamicAppLocalizations.of(
                                    Get.context!,
                                  ).t("gender"),
                                  textSize: FontSize().regular,
                                  isFontBold: false,
                                  fontColor: AppColors.primaryColor,
                                  isFontUnderline: false,
                                  textCenter: false,
                                  fontStyle: FontStyle.normal,
                                ),
                                Wrap(
                                  spacing: 10,
                                  children: [
                                    ChoiceChip(
                                      label: CustomTextWidget(
                                        textString: DynamicAppLocalizations.of(
                                          Get.context!,
                                        ).t("male"),
                                        textSize: FontSize().regular,
                                        fontColor: AppColors.white,
                                        isFontBold: false,
                                        
                                      ),
                                      selected: controller.gender.value == 0,
                                      onSelected: (_) =>
                                          controller.isGenderLocked.value
                                          ? null
                                          : controller.setGenderInt(0),
                                      selectedColor: AppColors.primaryColor,
                                      backgroundColor: AppColors.grey400,
                                    
                                    ),
                                    ChoiceChip(
                                      label: CustomTextWidget(
                                        textString: DynamicAppLocalizations.of(
                                          Get.context!,
                                        ).t("female"),
                                        textSize: FontSize().regular,
                                        fontColor: AppColors.white,
                                        isFontBold: false,
                                      ),
                                      selected: controller.gender.value == 1,
                                      onSelected: (_) =>
                                          controller.isGenderLocked.value
                                          ? null
                                          : controller.setGenderInt(1),
                                      selectedColor: AppColors.primaryColor,
                                      backgroundColor: AppColors.grey400,
                                    ),
                                    ChoiceChip(
                                      label: CustomTextWidget(
                                        textString: DynamicAppLocalizations.of(
                                          Get.context!,
                                        ).t("other"),
                                        textSize: FontSize().regular,
                                        fontColor: AppColors.white,
                                        isFontBold: false,
                                      ),
                                      selected: controller.gender.value == 2,
                                      onSelected: (_) =>
                                          controller.isGenderLocked.value
                                          ? null
                                          : controller.setGenderInt(2),
                                      selectedColor: AppColors.primaryColor,
                                      backgroundColor: AppColors.grey400,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 14),
                            
                            CustomTextWidget(
                              textString: DynamicAppLocalizations.of(
                                Get.context!,
                              ).t("date_of_birth"),
                              textSize: FontSize().regular,
                              isFontBold: false,
                              fontColor: AppColors.primaryColor,
                              isFontUnderline: false,
                              textCenter: false,
                              fontStyle: FontStyle.normal,
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.primaryColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: AppColors.primaryColor,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomTextWidget(
                                      textString: controller.formattedDob,
                                      textSize: FontSize().regular,
                                      isFontBold: false,
                                      fontColor: controller.dob.value == null
                                          ? AppColors.grey
                                          : AppColors.shadowPrimaryColor,
                                      isFontUnderline: false,
                                      textCenter: false,
                                      fontStyle: FontStyle.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              height: 48,
                              width: Get.width,
                              child: CustomElevatedButtonWidget(
                                buttonKey: const Key('btn-login-button'),
                                isLoading: controller.isLoading.value,
                                buttonText: DynamicAppLocalizations.of(context).t("update"),
                                onPressed: () {
                                  if (!controller.isLoading.value &&
                                      controller.formKey.value.currentState!
                                          .validate()) {
                                    controller.updateUserDetails();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerLayout() {
    return Shimmer.fromColors(
      baseColor: AppColors.grey200,
      highlightColor: AppColors.grey400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildShimmerBlock(height: 50, width: double.infinity),
          const SizedBox(height: 16),
          _buildShimmerBlock(height: 50, width: double.infinity),
          const SizedBox(height: 16),
          _buildShimmerBlock(height: 50, width: double.infinity),
          const SizedBox(height: 16),
          _buildShimmerBlock(height: 14, width: 80),
          const SizedBox(height: 4),
          _buildShimmerBlock(height: 16, width: double.infinity),
          const SizedBox(height: 16),
          _buildShimmerBlock(height: 14, width: 80),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildShimmerBlock(height: 32, width: 60, radius: 20),
              const SizedBox(width: 10),
              _buildShimmerBlock(height: 32, width: 80, radius: 20),
              const SizedBox(width: 10),
              _buildShimmerBlock(height: 32, width: 70, radius: 20),
            ],
          ),
          const SizedBox(height: 16),
          _buildShimmerBlock(height: 14, width: 100),
          const SizedBox(height: 4),
          _buildShimmerBlock(height: 50, width: double.infinity),
          const SizedBox(height: 20),
          _buildShimmerBlock(height: 48, width: double.infinity),
        ],
      ),
    );
  }

  Widget _buildShimmerBlock({
    required double height,
    required double width,
    double radius = 4.0,
  }) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
