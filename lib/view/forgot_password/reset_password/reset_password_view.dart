import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../widget/custom_button_widget.dart';
import '../../../widget/custom_text_field_widget.dart';
import '../../../widget/custom_text_widget.dart';
import 'reset_password_view_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordViewController> {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ResetPasswordViewController());
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
              title: CustomTextWidget(
                textString: DynamicAppLocalizations.of(Get.context!).t("reset_password"),
                textSize: FontSize().appBar,
                isFontBold: false,
                fontColor: AppColors.white,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 12.0,
                ),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      Hero(
                        tag: "vyoAppLogo",
                        child: Column(
                          children: [
                            Image.asset(
                              AppIcons.appLogo,
                              height: 120,
                              width: 120,
                            ),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                      CustomTextWidget(
                        fontColor: AppColors.primaryColor,
                        textString:
                            DynamicAppLocalizations.of(context).t("please_create_secure_password"),
                        textSize: FontSize().appBar,
                        numberOfLines: 5,
                        isFontBold: false,
                        isFontUnderline: false,
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormFieldWidget(
                        controller: controller.newPasswordController,
                        label: DynamicAppLocalizations.of(context).t("new_password"),
                        isOutlineBorder: true,
                        cursorColor: AppColors.primaryColor,
                        style: const TextStyle(),
                        validator: (value) {
                          if (value!.isEmpty) return DynamicAppLocalizations.of(context).t("enter_new_password");
                          return null;
                        },
                        onChanged: (value) {
                          controller.validateNewPassword(value);
                          controller.validateConfirmPassword(
                            controller.confirmPasswordController.text,
                            value,
                          );
                          controller.checkForm();
                        },
                        inputFormatters: [],
                      ),
                      const SizedBox(height: 4),
                      _buildRule(DynamicAppLocalizations.of(context).t("minimum_eight_characters"), controller.hasMinLength),
                      const SizedBox(height: 25),
                      CustomTextFormFieldWidget(
                        controller: controller.confirmPasswordController,
                        label: DynamicAppLocalizations.of(context).t("confirm_password"),
                        isOutlineBorder: true,
                        cursorColor: AppColors.primaryColor,
                        style: const TextStyle(),
                        validator: (value) {
                          if (value!.isEmpty) return DynamicAppLocalizations.of(context).t("enter_confirm_password");
                          if (!controller.isConfirmPasswordValid.value) {
                            return DynamicAppLocalizations.of(context).t("password_do_not_match");
                          }
                          return null;
                        },
                        onChanged: (value) {
                          controller.validateConfirmPassword(
                            value,
                            controller.newPasswordController.text,
                          );
                          controller.checkForm();
                        },
                      ),
                      const SizedBox(height: 30),
          
                      /// Submit Button
                      CustomElevatedButton(
                        isLoading: controller.isLoading.value,
                        title: DynamicAppLocalizations.of(context).t("submit"),
                        width: Get.width * 0.5,
                        onPressed: controller.isButtonEnabled.value
                            ? () => controller.submitResetPassword()
                            : () {},
                        backgroundColor: controller.isButtonEnabled.value
                            ? AppColors.primaryColor
                            : AppColors.grey,
                        textColor: AppColors.white,
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

  /// Small rule widget
  Widget _buildRule(String text, RxBool isValid) {
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
            isFontBold: false,
            fontColor: isValid.value ? AppColors.green : AppColors.red,
            isFontUnderline: false,
            fontStyle: FontStyle.normal,
          ),
        ],
      ),
    );
  }
}
