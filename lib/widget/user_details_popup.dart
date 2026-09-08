import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../const/app_color.dart';
import '../const/app_constant.dart';
import '../localization/dynamic_app_localizations.dart';
import '../utility/validators.dart';
// import 'common_widget.dart';
import 'common_widget.dart';
import 'custom_elevated_button_widget.dart';
import 'custom_text_field_widget.dart';
import 'custom_text_widget.dart';
import 'custom_shimmer_widget.dart';
import 'user_popup_controller.dart';

void showUserDetailsDialog(BuildContext context) {
  final controller = Get.put(UserPopupController());

  Widget stepIndicator(UserPopupController controller) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: controller.currentStep.value >= 0
                        ? AppColors.primaryColor
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: controller.currentStep.value == 1
                        ? AppColors.primaryColor
                        : AppColors.grey200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // CustomTextWidget(
          //       textString: DynamicAppLocalizations.of(Get.context!).t("step_one_of_two"),
          //       textSize: FontSize().regular,
          //       fontColor: AppColors.black,
          //       isFontBold: false,
          //     ),
        ],
      ),
    );
  }

  Widget buildRule(String text, RxBool isValid) {
    return Obx(
      () => Row(
        children: [
          Icon(
            isValid.value ? Icons.check_circle : Icons.cancel,
            size: 18,
            color: isValid.value ? AppColors.green : AppColors.red,
          ),
          const SizedBox(width: 8),
          CustomTextWidget(
            textString: text,
            textSize: FontSize().small,
            fontColor: isValid.value ? AppColors.green : AppColors.red,
            isFontBold: false,
          ),
        ],
      ),
    );
  }

  Widget stepOne(UserPopupController controller) {
    return Column(
      children: [
        SizedBox(height: 16),
        CustomTextFormFieldWidget(
          controller: controller.nameController.value,
          isOutlineBorder: true,
          label: DynamicAppLocalizations.of(Get.context!).t("name"),
          validator: (v) => v!.isEmpty
              ? DynamicAppLocalizations.of(Get.context!).t("name_is_required")
              : null,
        ),
        SizedBox(height: 16),
        CustomTextFormFieldWidget(
          controller: controller.emailTextController.value,
          isOutlineBorder: true,
          label:
              "${DynamicAppLocalizations.of(context).t("email")} ${DynamicAppLocalizations.of(context).t("optional")}",
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"[ ]"))],
          validator: (v) {
            if (v == null || v.trim().isEmpty) return null; // Optional
            if (!GetUtils.isEmail(v.trim())) {
              return DynamicAppLocalizations.of(
                Get.context!,
              ).t("enter_valid_email");
            }
            return null;
          },
        ),
        SizedBox(height: 16),
        CustomTextFormFieldWidget(
          controller: controller.phoneController,
          label: DynamicAppLocalizations.of(Get.context!).t("phone_number"),
          readOnly: true,
          enabled: false,
          isOutlineBorder: true,
        ),
        SizedBox(height: 16),
        Obx(
          () => CustomTextFormFieldWidget(
            controller: controller.newPasswordTextController.value,
            isOutlineBorder: true,
            label: DynamicAppLocalizations.of(Get.context!).t("password"),
            obscure: true,
            inputFormatters: [FilteringTextInputFormatter.deny(' ')],
            validator: (value) {
              if (controller.newPasswordTextController.value.text.isEmpty) {
                return Validators().validatePassword(
                  value,
                  DynamicAppLocalizations.of(Get.context!).t("password"),
                );
              }
              return null;
            },
            onChanged: (value) async {
              controller.validateNewPassword(value);
              controller.checkForm();
            },
          ),
        ),
        buildRule(
          DynamicAppLocalizations.of(context).t("minimum_eight_characters"),
          controller.hasMinLength,
        ),
        SizedBox(height: 16),
        CustomTextFormFieldWidget(
          controller: controller.confirmPasswordTextController.value,
          isOutlineBorder: true,
          contentPadding: const EdgeInsets.all(10.0),
          label: DynamicAppLocalizations.of(Get.context!).t("confirm_password"),
          autoValidateMode: AutovalidateMode.onUserInteraction,
          obscure: true,
          style: TextStyle(),
          inputFormatters: [FilteringTextInputFormatter.deny(' ')],
          validator: (value) {
            if (Validators().validatePassword(
                  value,
                  DynamicAppLocalizations.of(
                    Get.context!,
                  ).t("confirm_password"),
                ) !=
                null) {
              return Validators().validatePassword(
                value,
                DynamicAppLocalizations.of(Get.context!).t("confirm_password"),
              );
            } else if (!controller.isConfirmPasswordValid.value) {
              return DynamicAppLocalizations.of(
                Get.context!,
              ).t("password_do_not_match");
            }
            return null;
          },
          onChanged: (value) {
            controller.validateConfirmPassword(
              value,
              controller.newPasswordTextController.value.text,
            );
            controller.checkForm();
          },
        ),
      ],
    );
  }

  Widget stepTwo(UserPopupController controller) {
    Widget loadingFieldShimmer() {
      return SizedBox(
        height: 56,
        child: ShimmerList(
          itemCount: 1,
          itemWidget: Container(
            height: 56,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.grey,
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        CommonWidget().customSearchableDropdown(
          selectedValue: controller.selectedCountryName,
          items: controller.countryNames,
          labelText: DynamicAppLocalizations.of(Get.context!).t("country"),
          hintText: DynamicAppLocalizations.of(
            Get.context!,
          ).t("select_country"),
          validatorMessage: DynamicAppLocalizations.of(
            Get.context!,
          ).t("country"),
          onChanged: (value) {
            controller.selectedCountryName.value = value;
            controller.selectedCountryId.value =
                controller.countryNameToId[value] ?? "";
            controller.fetchStates(controller.selectedCountryId.value);
          },
          setStateUpdate: () => controller.update(),
        ),
        SizedBox(height: 16),
        controller.isStateLoading.value
            ? loadingFieldShimmer()
            : CommonWidget().customSearchableDropdown(
                selectedValue: controller.selectedStateName,
                items: controller.stateNames,
                labelText: DynamicAppLocalizations.of(Get.context!).t("state"),
                hintText:
                    DynamicAppLocalizations.of(Get.context!).t("select_state"),
                validatorMessage: DynamicAppLocalizations.of(
                  Get.context!,
                ).t("state"),
                onChanged: (value) {
                  controller.selectedStateName.value = value;
                  controller.selectedStateId.value =
                      controller.stateNameToId[value] ?? "";
                  controller.fetchCities(controller.selectedStateId.value);
                },
                setStateUpdate: () => controller.update(),
              ),
        SizedBox(height: 16),
        controller.isCityLoading.value
            ? loadingFieldShimmer()
            : CommonWidget().customSearchableDropdown(
                selectedValue: controller.selectedCityName,
                items: controller.cityNames,
                labelText: DynamicAppLocalizations.of(Get.context!).t("city"),
                hintText:
                    DynamicAppLocalizations.of(Get.context!).t("select_city"),
                validatorMessage: DynamicAppLocalizations.of(
                  Get.context!,
                ).t("city"),
                onChanged: (value) {
                  controller.selectedCityName.value = value;
                  controller.selectedCityId.value =
                      controller.cityNameToId[value] ?? "";
                },
                setStateUpdate: () => controller.update(),
              ),
        SizedBox(height: 16),
        CustomTextWidget(
          textString: DynamicAppLocalizations.of(Get.context!).t("gender"),
          textSize: FontSize().regular,
          fontColor: AppColors.primaryColor,
        ),
        SizedBox(height: 8),
        Row(
          spacing: 6,
          children: [
            Expanded(
              child: Obx(
                () => genderOption(
                    label: DynamicAppLocalizations.of(Get.context!).t("male"),
                    value: 0,
                    gender: controller.gender,
                    onChanged: controller.setGenderInt,
                    icon: Icons.person),
              ),
            ),
            Expanded(
              child: Obx(
                () => genderOption(
                    label: DynamicAppLocalizations.of(Get.context!).t("female"),
                    value: 1,
                    gender: controller.gender,
                    onChanged: controller.setGenderInt,
                    icon: Icons.female),
              ),
            ),
            Expanded(
              child: Obx(
                () => genderOption(
                    label: DynamicAppLocalizations.of(Get.context!).t("other"),
                    value: 2,
                    gender: controller.gender,
                    onChanged: controller.setGenderInt,
                    icon: Icons.visibility_off_outlined),
              ),
            ),
          ],
        ),
        if (controller.isSubmitButtonClicked.value &&
            controller.gender.value == -1)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: CustomTextWidget(
              textString:
                  '${DynamicAppLocalizations.of(Get.context!).t("gender")} is required',
              textSize: FontSize().small,
              fontColor: AppColors.red,
              isFontBold: false,
            ),
          ),
        SizedBox(height: 16),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () => controller.pickDob(Get.context!),
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: controller.dobString.isEmpty &&
                                controller.isSubmitButtonClicked.value == true
                            ? AppColors.red
                            : AppColors.primaryColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_month, color: AppColors.primaryColor),
                      SizedBox(width: 10),
                      Expanded(
                        child: CustomTextWidget(
                          textString: controller.formattedDob,
                          fontColor: controller.dob.value == null
                              ? AppColors.grey
                              : AppColors.primaryColor,
                          textSize: FontSize().regular,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 3),
              if (controller.dobString.isEmpty &&
                  controller.isSubmitButtonClicked.value == true) ...[
                CustomTextWidget(
                  textString: DynamicAppLocalizations.of(Get.context!)
                      .t("select_date_of_birth"),
                  textSize: FontSize().small,
                  fontColor: AppColors.red,
                ),
              ]
            ],
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      controller.dialogContext = dialogContext;
      return PopScope(
        canPop: false,
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                stepIndicator(controller),
                const SizedBox(height: 10),
                CustomTextWidget(
                  textString: controller.currentStep.value == 0
                      ? DynamicAppLocalizations.of(
                          Get.context!,
                        ).t("user_information")
                      : DynamicAppLocalizations.of(
                          Get.context!,
                        ).t("additional_details"),
                  textSize: FontSize().regular,
                  fontColor: AppColors.primaryColor,
                  isFontBold: false,
                ),
                SizedBox(height: 4),
                CustomTextWidget(
                  textString: controller.currentStep.value == 0
                      ? DynamicAppLocalizations.of(
                          Get.context!,
                        ).t("please_fill_your_basic_details")
                      : DynamicAppLocalizations.of(
                          Get.context!,
                        ).t("please_complete_remaining_details"),
                  textSize: FontSize().regular,
                  fontColor: AppColors.primaryColor,
                  isFontBold: false,
                ),
              ],
            ),
          ),
          content: Obx(() {
            return SizedBox(
              width: Get.width * 0.75,
              child: SingleChildScrollView(
                child: Form(
                  key: controller.formKey.value,
                  child: controller.currentStep.value == 0
                      ? stepOne(controller)
                      : stepTwo(controller),
                ),
              ),
            );
          }),
          actions: [
            Obx(() {
              return SizedBox(
                width: Get.width * 0.90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.currentStep.value == 1
                        ? Expanded(
                            child: SizedBox(
                              height: 48,
                              child: CustomElevatedButtonWidget(
                                // isLoading: controller.isLoading.value,
                                buttonText: DynamicAppLocalizations.of(
                                  Get.context!,
                                ).t("back"),
                                onPressed: () {
                                  if (controller.currentStep.value == 1) {
                                    if (!controller.isLoading.value) {
                                      controller.goTopreviousStep();
                                    }
                                  }
                                },
                                buttonKey: null,
                              ),
                            ),
                          )
                        : SizedBox(),
                    SizedBox(width: controller.currentStep.value == 0 ? 0 : 12),
                    Expanded(
                      child: SizedBox(
                        height: 48,
                        child: CustomElevatedButtonWidget(
                          isLoading: controller.isLoading.value,
                          buttonText: controller.currentStep.value == 0
                              ? DynamicAppLocalizations.of(Get.context!)
                                  .t("next")
                              : DynamicAppLocalizations.of(
                                  Get.context!,
                                ).t("submit"),
                          onPressed: () {
                            if (controller.currentStep.value == 1) {
                              controller.isSubmitButtonClicked.value = true;
                            }
                            final isGenderSelected =
                                controller.gender.value != -1;
                            if (controller.formKey.value.currentState!
                                    .validate() &&
                                controller.hasMinLength.value) {
                              if (controller.currentStep.value == 0) {
                                controller.goToNextStep();
                              } else {
                                if (isGenderSelected) {
                                  controller.registerNewUser();
                                }
                              }
                            }
                          },
                          buttonKey: null,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      );
    },
  );
}
