import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../const/constant.dart';
import '../../const/logger.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/validators.dart';
import '../../widget/country_phone_input.dart';
import '../../widget/custom_elevated_button_widget.dart';
import '../../widget/custom_icon_widget.dart';
import '../../widget/custom_no_internet_widget.dart';
import '../../widget/custom_text_field_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'login_view_controller.dart';

class LoginView extends GetView<LoginViewController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Avoid calling Get.put inside build → done in binding or main
    final ctrl = Get.put(LoginViewController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Obx(
        () => SafeArea(
          top: false,
          child: Scaffold(
            body: controller.homeController.isDisplayInternetConnection.value ?
                Center(
                  child: CustomNoInternetWidget(
                      onPressed: () async {
                        if (await ApiServiceInterceptor.checkInternet()) {
                          controller.homeController.isDisplayInternetConnection
                              .value = false;
                          controller.isLoading.value = true;
                          await controller.apiController.fetchVersionsList(
                            isUserLoggedIn: false,
                            jwtToken: '',
                          );
                          controller.isLoading.value = false;
                        } else {
                          controller.homeController.isDisplayInternetConnection
                              .value = true;
                        }
                      },
                    ),
                )
                 :  SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Form(
                key: ctrl.formKey.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),

                    /// ---------- LOGO + APP NAME ----------
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
                          DynamicAppLocalizations.of(context).t("login_title"),
                      textSize: FontSize().appBar,
                      numberOfLines: 5,
                      isFontBold: false,
                      isFontUnderline: false,
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
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
                          isValidPhoneNumber: (isValid) {
                            talker.info("Valid phone: $isValid");
                            controller.isValidePhoneNumber.value = isValid;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormFieldWidget(
                          controller: controller.passwordController,
                          isOutlineBorder: true,
                          contentPadding: const EdgeInsets.all(15.0),
                          keyboardType: TextInputType.text,
                          cursorColor: AppColors.primaryColor,
                          // filled: true,
                          // fillColor: AppColors.blue,
                          hintText: DynamicAppLocalizations.of(Get.context!)
                              .t("enter_password"),
                          label: DynamicAppLocalizations.of(Get.context!)
                              .t("password"),
                          enabled: controller.isLoading.value ? false : true,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          obscure: controller.isPasswordVisible.value,
                          style: Get.textTheme.displayMedium,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [
                            FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                          ],
                          validator: (value) => Validators().validatePassword(
                              value,
                              DynamicAppLocalizations.of(Get.context!)
                                  .t("password")),
                          suffixIcon: controller.isPasswordVisible.value
                              ? CustomIconWidget(
                                  icon: AppIcons.lockIcon,
                                  iconColor: AppColors.primaryColor,
                                )
                              : CustomIconWidget(
                                  icon: AppIcons.lockOpenIcon,
                                  iconColor: AppColors.primaryColor,
                                ),
                          onSuffixIconPressed: () {
                            controller.isPasswordVisible.value =
                                !controller.isPasswordVisible.value;
                            controller.update();
                          },
                        ),
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              Get.toNamed(Routes.forgotpassword);
                            },
                            child: CustomTextWidget(
                              textString:
                                  "${DynamicAppLocalizations.of(Get.context!).t("forgot_password")} ?",
                              textSize: FontSize().regular,
                              fontColor: AppColors.black,
                              isFontUnderline: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 48,
                          width: 200,
                          child: CustomElevatedButtonWidget(
                            buttonKey: const Key('btn-login-button'),
                            isLoading: ctrl.isLoading.value,
                            buttonText: DynamicAppLocalizations.of(Get.context!)
                                .t("login"),
                            onPressed: () async {
                              controller.validatePhone();

                              if (!ctrl.isLoading.value &&
                                  ctrl.formKey.value.currentState!.validate() &&
                                  ctrl.isValidePhoneNumber.value) {
                                ctrl.homeController.reload();
                                controller.userLogin();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CustomTextWidget(
                              textString: DynamicAppLocalizations.of(
                                Get.context!,
                              ).t("dont_have_an_account"),
                              textSize: FontSize().regular,
                              fontColor: AppColors.black,
                              isFontBold: false,
                            ),
                            const SizedBox(width: 12),
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.signup);
                              },
                              child: CustomTextWidget(
                                textString: DynamicAppLocalizations.of(
                                  Get.context!,
                                ).t("click_here"),
                                textSize: FontSize().regular,
                                fontColor: AppColors.primaryColor,
                                isFontBold: false,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: controller.homeController.isDisplayInternetConnection
                              .value ? const SizedBox() : SizedBox(
              height: 40,
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: DynamicAppLocalizations.of(context)
                            .t("issues_and_support_login"),
                        style: TextStyle(color: AppColors.primaryColor),
                        children: <TextSpan>[
                          TextSpan(text: ' '),
                          TextSpan(
                            text: DynamicAppLocalizations.of(context)
                                .t("click_here"),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                await controller.handleSpecificTap();
                              },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
