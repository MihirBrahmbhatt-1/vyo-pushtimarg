import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/app_assets.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../utility/local_db.dart';
import '../../widget/custom_button_widget.dart';
import '../../widget/custom_icon_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../dashboard/dashboard_view_controller.dart';
import 'otp_view_controller.dart';

class VerifyOtpView extends GetView<OtpViewController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(OtpViewController());
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Obx(
        () => PopScope(
          canPop: true,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.primaryColor,
              foregroundColor: AppColors.white,
            ),
            body: SingleChildScrollView(
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 60),
                            Center(
                              child: CustomTextWidget(
                                textString: DynamicAppLocalizations.of(Get.context!).t("otp_verification"),
                                textSize: FontSize().xmedium,
                                isFontBold: true,
                                fontColor: AppColors.black,
                                isFontUnderline: false,
                                numberOfLines: 1,
                                textCenter: false,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: CustomImageAssetWidget(
                                imagePath: AppIcons.mobileOtpIcon,
                                height: 100,
                                width: 100,
                                imageColor: AppColors.shadowPrimaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: CustomTextWidget(
                                textString: DynamicAppLocalizations.of(Get.context!).t("enter_otp"),
                                textSize: FontSize().regular,
                                isFontBold: true,
                                fontColor: AppColors.black,
                                isFontUnderline: false,
                                numberOfLines: 1,
                                textCenter: false,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: CustomTextWidget(
                                textString: DynamicAppLocalizations.of(Get.context!).t("sent_otp_description"),
                                textSize: FontSize().small,
                                isFontBold: false,
                                fontColor: AppColors.grey400,
                                isFontUnderline: false,
                                numberOfLines: 8,
                                textCenter: true,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: List.generate(
                                      controller.otpTextLength.value,
                                      (index) {
                                        return controller.buildOtpField(index);
                                      },
                                    ),
                                  ),
                                  controller.isOtpInvalidMessageDisplay.value ==
                                          true
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8.0,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: CustomTextWidget(
                                              textString: DynamicAppLocalizations.of(Get.context!).t("invalid_otp"),
                                              textSize: FontSize().small,
                                              isFontBold: false,
                                              fontColor: AppColors.red,
                                              isFontUnderline: false,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  // controller.remainingSendingOtpAttempts
                                  //                 .value ==
                                  //             1 ||
                                  //         controller.remainingSendingOtpAttempts
                                  //                 .value ==
                                  //             2 ||
                                  //         controller.remainingSendingOtpAttempts
                                  //                 .value ==
                                  //             0
                                  //     ? Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(top: 8.0),
                                  //         child: Align(
                                  //           alignment: Alignment.center,
                                  //           child: CustomTextWidget(
                                  //             textString: AppLocalizations.of(
                                  //                     Get.context!)!
                                  //                 .userOtpRemainingAttemptsString(
                                  //                     controller
                                  //                         .remainingSendingOtpAttempts
                                  //                         .value),
                                  //             textSize: FontSize().small,
                                  //             isFontBold: false,
                                  //             fontColor: AppColors.red,
                                  //             isFontUnderline: false,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : const ColoredBox(
                                  //         color: AppColors.transparent),
                                  // if (!controller
                                  //     .isDisplayedResendOtpButton.value)
                                  //   Padding(
                                  //     padding: const EdgeInsets.only(top: 6.0),
                                  //     child: Center(
                                  //       child: CustomTextWidget(
                                  //         textString:
                                  //             AppLocalizations.of(Get.context!)!
                                  //                 .didNotReceiveOtpString(
                                  //           controller.formattedTime(
                                  //               timeInSecond: controller
                                  //                   .remainingSeconds.value),
                                  //         ),
                                  //         textSize: FontSize().small,
                                  //         isFontBold: false,
                                  //         fontColor: AppColors.grey200,
                                  //         isFontUnderline: false,
                                  //       ),
                                  //     ),
                                  //   ),
                                  // controller.isSendingOtp.value == true
                                  //     ? Padding(
                                  //         padding: const EdgeInsets.all(8.0),
                                  //         child: Center(
                                  //           child: CommonWidget.shimmerEffect(
                                  //             height: 20,
                                  //             width: 100,
                                  //             shimmerAlignment:
                                  //                 Alignment.center,
                                  //           ),
                                  //         ),
                                  //       )
                                  //     : CustomTextButton(
                                  //         title:
                                  //             "Resend OTP",
                                  //             backgroundColor: AppColors.transparent,
                                  //         textColor: controller
                                  //                 .isDisplayedResendOtpButton
                                  //                 .value
                                  //             ? AppColors.black
                                  //             : AppColors.grey,
                                  //         // isEnable: controller
                                  //         //         .isDisplayedResendOtpButton
                                  //         //         .value
                                  //         //     ? true
                                  //         //     : false,
                                  //         onPressed: () async {
                                  //           // controller
                                  //           //     .sendUserVerificationOtp();
                                  //         },
                                  //       ),
                                  const SizedBox(height: 50),
                                  SizedBox(
                                    height: 48,
                                    width: 200,
                                    child: CustomElevatedButton(
                                      title: DynamicAppLocalizations.of(Get.context!).t("verify_otp"),
                                      // width: 200,
                                      isLoading: controller.isLoading.value,
                                      backgroundColor:
                                          !controller.allFilled.value
                                          ? AppColors.grey
                                          : AppColors.primaryColor,
                                      textColor: AppColors.white,
                                      onPressed: () async {
                                        if (controller.allFilled.value ==
                                            false) {
                                        } else {
                                          if (controller.fetchOtpString.value
                                                  .toString() !=
                                              controller.userEnteredOtp.value) {
                                          } else {
                                            controller.isLoading.value = true;
                                            Future.delayed(
                                              Duration(seconds: 3),
                                            ).then((value) async {
                                              await LocalDB().setIsLoggedIn(
                                                true,
                                              );
                                              await LocalDB()
                                                  .reloadSharedPref();
                                              controller
                                                      .homeController
                                                      .selectedIndex
                                                      .value =
                                                  0;
                                              controller.homeController
                                                  .update();
                                              
                                              Get.put(
                                                DashboardViewController(),
                                              );
                                              Get.offAllNamed(Routes.home);
                                              controller.isLoading.value =
                                                  false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          ],
                        ),
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
