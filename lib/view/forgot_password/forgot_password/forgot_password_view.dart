import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../const/logger.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../widget/country_phone_input.dart';
import '../../../widget/custom_elevated_button_widget.dart';
import '../../../widget/custom_text_widget.dart';
import 'forgot_password_view_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordViewController> {
  const ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ForgotPasswordViewController());
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
            centerTitle: true,
            title: CustomTextWidget(
              textString: DynamicAppLocalizations.of(Get.context!).t("forgot_password"),
              textSize: FontSize().appBar,
              isFontBold: false,
              fontColor: AppColors.white,
              isFontUnderline: false,
              fontStyle: FontStyle.normal,
            ),
          ),
          body: 
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: controller.formKey.value,
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
                    const SizedBox(height: 40),
                    CustomTextWidget(
                      fontColor: AppColors.primaryColor,
                      textString:
                          DynamicAppLocalizations.of(context).t("forgot_password_description"),
                      textSize: FontSize().appBar,
                      numberOfLines: 5,
                      isFontBold: false,
                      isFontUnderline: false,
                    ),
                    const SizedBox(height: 20),
                    PhoneNumberField(
                      selectedCountry: controller.selectedCountry,
                      phoneController: controller.phoneNumberTextController,
                      showError: controller.showPhoneError,
                      errorText: controller.phoneErrorMessage,
                      onCountryChanged: (country) {
                        talker.info("Changed to: ${country.name}");
                      },
                      onPhoneChanged: (phone) {
                        talker.info("Updated phone: $phone");
                      },
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 48,
                      width: 200,
                      child: CustomElevatedButtonWidget(
                        buttonKey: const Key('btn-login-button'),
                        isLoading: controller.isLoading.value,
                        buttonText:  DynamicAppLocalizations.of(Get.context!).t("send_otp"),
                        onPressed: () async {
                          bool isPhoneNumberValid = controller.validatePhone();

                          if (isPhoneNumberValid) {
                            if (!controller.isLoading.value &&
                                controller.formKey.value.currentState!
                                    .validate()) {
                              controller.homeController.reload();
                              controller.sendForgotPasswordOtp();
                            }
                          }
                        },
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
