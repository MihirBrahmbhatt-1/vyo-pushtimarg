import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/constant.dart';
import '../../const/logger.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../utility/common_functions.dart';
import '../../widget/country_phone_input.dart';
import '../../widget/custom_elevated_button_widget.dart';
import '../../widget/custom_no_internet_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../login/login_view.dart';
import 'sign_up_view_controller.dart';

class SignUpView extends GetView<SignUpViewController> {
  const SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    // Avoid calling Get.put inside build → done in binding or main
    final ctrl = Get.put(SignUpViewController());

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        top: false,
        child: Obx(
          () => Scaffold(
            body: controller.homeController.isDisplayInternetConnection.value
                ? Center(
                    child: CustomNoInternetWidget(
                      onPressed: () async {
                        await checkInternetStatus(
                          onConnected: () async {
                            controller.homeController
                                .isDisplayInternetConnection.value = false;
                            controller.isLoading.value = true;
                            await controller.apiController.fetchVersionsList(
                              isUserLoggedIn: false,
                              jwtToken: '',
                            );
                            controller.isLoading.value = false;
                          },
                          onNoConnection: () {
                            controller.homeController
                                .isDisplayInternetConnection.value = true;
                          },
                        );
                      },
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Form(
                      key: ctrl.formKey.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 80),

                          /// ---------- LOGO ----------
                          Hero(
                            tag: "vyoAppLogo",
                            child: Column(
                              children: [
                                Image.asset(
                                  AppIcons.appLogo,
                                  height: 140,
                                  width: 140,
                                ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),

                          /// ---------- DESCRIPTION ----------
                          CustomTextWidget(
                            // key: ,
                            uiKey: const Key('phone-number-description'),
                            fontColor: AppColors.primaryColor,
                            // textString:
                            //     "Please enter your phone number to sign in. You will receive an OTP.",
                            textString: DynamicAppLocalizations.of(context)
                                .t("signup_title"),
                            textSize: FontSize().appBar,
                            numberOfLines: 5,
                            isFontBold: false,
                            isFontUnderline: false,
                          ),

                          const SizedBox(height: 30),

                          /// ---------- PHONE INPUT AREA ----------
                          Column(
                            children: [
                              PhoneNumberField(
                                  selectedCountry: controller.selectedCountry,
                                  phoneController:
                                      controller.phoneNumberTextController,
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
                                    controller.isValidePhoneNumber.value =
                                        isValid;
                                  }),
                              const SizedBox(height: 16),

                              /// ---------- SEND OTP BUTTON ----------
                              SizedBox(
                                height: 48,
                                width: 200,
                                child: CustomElevatedButtonWidget(
                                  buttonKey: const Key('btn-login-button'),
                                  isLoading: ctrl.isLoading.value,
                                  buttonText:
                                      DynamicAppLocalizations.of(context)
                                          .t("send_otp"),
                                  onPressed: () {
                                    bool isPhoneNumberValid =
                                        controller.validatePhone();

                                    if (isPhoneNumberValid) {
                                      if (!controller.isLoading.value &&
                                          controller.formKey.value.currentState!
                                              .validate() &&
                                          controller
                                              .isValidePhoneNumber.value) {
                                        controller.homeController.reload();
                                        controller.sendOtp();
                                      }
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
                                    ).t("already_have_an_account"),
                                    textSize: FontSize().regular,
                                    fontColor: AppColors.black,
                                    isFontBold: false,
                                  ),
                                  const SizedBox(width: 12),
                                  InkWell(
                                    onTap: () {
                                      Get.offAll(
                                        () => const LoginView(),
                                        transition: Transition.leftToRight,
                                        duration:
                                            const Duration(milliseconds: 400),
                                      );
                                    },
                                    child: CustomTextWidget(
                                      textString: DynamicAppLocalizations.of(
                                        Get.context!,
                                      ).t("click_here_to_login"),
                                      textSize: FontSize().regular,
                                      fontColor: AppColors.primaryColor,
                                      isFontBold: false,
                                      isFontUnderline: true,
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
          ),
        ),
      ),
    );
  }
}
