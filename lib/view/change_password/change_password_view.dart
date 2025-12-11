import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../widget/custom_alert_widget.dart';
import '../../widget/custom_button_widget.dart';
import '../../widget/custom_text_field_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'change_password_view_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ChangePasswordController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: AppColors.white,
          backgroundColor: AppColors.primaryColor,
          centerTitle: true,
          title: CustomTextWidget(
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t("change_password"),
            textSize: FontSize().appBar,
            isFontBold: false,
            fontColor: AppColors.white,
          ),
        ),
        body: Obx(
          () => SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  children: [
                    RepaintBoundary(
                      child: Lottie.asset(
                        'assets/lottie/lock.json',
                        delegates: LottieDelegates(
                          values: [
                            ValueDelegate.colorFilter(
                              const ['lock (1) Outlines', '**'],
                              value: ColorFilter.mode(
                                AppColors.primaryColor,
                                BlendMode.srcIn,
                              ),
                            ),
                          ],
                        ),
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const SizedBox(height: 20),

                    CustomTextWidget(
                      textString: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("change_password_title"),
                      textSize: FontSize().medium,
                      fontColor: AppColors.grey400,
                      numberOfLines: 20,
                      textCenter: true,
                    ),
                    const SizedBox(height: 30),

                    // Current Password
                    _passwordField(
                      label: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("current_password"),
                      controller: controller.currentController.value,
                      isVisible: controller.showCurrent,
                      validator: (val) => val!.trim().isEmpty
                          ? DynamicAppLocalizations.of(
                              Get.context!,
                            ).t("enter_current_password")
                          : null,
                      onChanged: (_) => controller.validateForm(),
                    ),
                    const SizedBox(height: 18),

                    // New Password
                    _passwordField(
                      label: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("new_password"),
                      controller: controller.newPasswordController,
                      isVisible: controller.showNew,
                      onChanged: (value) {
                        controller.validatePassword(value);
                        controller.validateForm();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return DynamicAppLocalizations.of(
                            Get.context!,
                          ).t("enter_new_password");
                        }
                        if (value == controller.currentController.value.text) {
                          return DynamicAppLocalizations.of(
                            Get.context!,
                          ).t("new_password_must_be_different");
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 6),
                    _passwordStrength(),
                    const SizedBox(height: 18),
                    _passwordField(
                      label: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("confirm_password"),
                      controller: controller.confirmPasswordController.value,
                      isVisible: controller.showConfirm,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return DynamicAppLocalizations.of(
                            Get.context!,
                          ).t("enter_confirm_password");
                        }
                        if (value != controller.newPasswordController.text) {
                          return DynamicAppLocalizations.of(
                            Get.context!,
                          ).t("password_do_not_match");
                        }
                        return null;
                      },
                      onChanged: (_) => controller.validateForm(),
                    ),
                    const SizedBox(height: 35),
                    CustomElevatedButton(
                      title: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("update"),
                      isLoading: controller.isBtnLoading.value,
                      backgroundColor: controller.isFormValid.value
                          ? AppColors.primaryColor
                          : AppColors.grey,
                      textColor: AppColors.white,
                      onPressed: () {
                        if (controller.isFormValid.value) {
                          _showConfirmAnimationDialog();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    required RxBool isVisible,
    required String? Function(String?) validator,
    required Function(String) onChanged,
  }) {
    return Obx(
      () => CustomTextFormFieldWidget(
        controller: controller,
        isOutlineBorder: true,
        label: label,
        obscure: !isVisible.value,
        inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"[ ]"))],
        style: TextStyle(),
        enabledColor: AppColors.primaryColor,
        cursorColor: AppColors.primaryColor,
        suffixIcon: IconButton(
          icon: Icon(
            isVisible.value ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primaryColor,
          ),
          onPressed: () => isVisible.value = !isVisible.value,
        ),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }

  Widget _passwordStrength() {
    return Obx(
      () => Column(
        children: [
          _rule(
            DynamicAppLocalizations.of(
              Get.context!,
            ).t("minimum_eight_characters"),
            controller.hasMinLength.value,
          ),
        ],
      ),
    );
  }

  Widget _rule(String text, bool passed) {
    return Row(
      children: [
        Icon(
          passed ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: passed ? AppColors.green : AppColors.grey,
        ),
        const SizedBox(width: 8),
        // Text(text),
        CustomTextWidget(
          textString: text,
          textSize: FontSize().small,
          fontColor: AppColors.shadowPrimaryColor,
        ),
      ],
    );
  }

  void _showConfirmAnimationDialog() {
    CustomAlertWidget().infoAlertDialog(
      displayText: DynamicAppLocalizations.of(Get.context!).t("confirm_change"),
      displaySubText: DynamicAppLocalizations.of(
        Get.context!,
      ).t("change_password_confirmation"),
      buttonText: DynamicAppLocalizations.of(Get.context!).t("yes"),
      cancelButtonText: DynamicAppLocalizations.of(Get.context!).t("cancel"),
      statusType: true, // success Lottie color
      showCancelButton: true,
      onButtonTap: () async {
        controller.submitChangePassword();
      },
    );
  }
}
