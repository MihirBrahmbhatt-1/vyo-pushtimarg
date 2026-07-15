import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../utility/common_functions.dart';
import '../../widget/custom_alert_widget.dart';
import '../../widget/custom_button_widget.dart';
import '../../widget/custom_no_internet_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'settings_view_controller.dart';

class SettingsView extends GetView<SettingsViewController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsViewController());

    return Obx(
      () => Scaffold(
        backgroundColor: AppColors.white,
        body: controller.homeController.isDisplayInternetConnection.value
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: CustomNoInternetWidget(
                  displayMessage: controller.displayInternetConnection.isEmpty
                      ? ""
                      : controller.displayInternetConnection.value,
                  onPressed: () async {
                    await checkInternetStatus(
                      onConnected: () async {
                        controller.homeController.isDisplayInternetConnection
                            .value = false;
                      },
                      onNoConnection: () {
                        controller.homeController.isDisplayInternetConnection
                            .value = true;
                      },
                    );
                  },
                ),
              )
            : controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    children: [
                      // PROFILE
                      ListTile(
                        leading: const Icon(Icons.person,
                            color: AppColors.primaryColor),
                        title: CustomTextWidget(
                          textString: DynamicAppLocalizations.of(Get.context!)
                              .t("profile"),
                          textSize: FontSize().regular,
                          fontColor: AppColors.primaryColor,
                          isFontBold: false,
                        ),
                        onTap: () {
                          Get.toNamed(Routes.userprofile);
                        },
                      ),

                      const Divider(
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      ListTile(
                        leading: const Icon(Icons.lock,
                            color: AppColors.primaryColor),
                        title: CustomTextWidget(
                          textString: DynamicAppLocalizations.of(Get.context!)
                              .t("change_password"),
                          textSize: FontSize().regular,
                          fontColor: AppColors.primaryColor,
                          isFontBold: false,
                        ),
                        onTap: () {
                          Get.toNamed(Routes.changepassword);
                        },
                      ),

                      const Divider(
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      ListTile(
                        leading: const Icon(Icons.language,
                            color: AppColors.primaryColor),
                        title: CustomTextWidget(
                          textString: DynamicAppLocalizations.of(Get.context!)
                              .t("change_language"),
                          textSize: FontSize().regular,
                          fontColor: AppColors.primaryColor,
                          isFontBold: false,
                        ),
                        onTap: () {
                          Get.toNamed(Routes.preferredlanguage);
                        },
                      ),

                      const Divider(
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      ListTile(
                        leading: const Icon(Icons.logout, color: AppColors.red),
                        title: CustomTextWidget(
                          textString: DynamicAppLocalizations.of(Get.context!)
                              .t("logout"),
                          textSize: FontSize().regular,
                          fontColor: AppColors.red,
                          isFontBold: false,
                        ),
                        textColor: AppColors.red,
                        onTap: () {
                          CustomAlertWidget().infoAlertDialog(
                            displayText:
                                DynamicAppLocalizations.of(Get.context!)
                                    .t("logout_title"),
                            displaySubText:
                                DynamicAppLocalizations.of(Get.context!)
                                    .t("logout_description"),
                            buttonText: DynamicAppLocalizations.of(Get.context!)
                                .t("yes"),
                            cancelButtonText:
                                DynamicAppLocalizations.of(Get.context!)
                                    .t("cancel"),
                            statusType: false,
                            showCancelButton: true,
                            onButtonTap: () {
                              controller.logoutUser();
                            },
                          );
                        },
                      ),

                      const Divider(
                        indent: 10.0,
                        endIndent: 10.0,
                      ),

                      ListTile(
                        leading: const Icon(Icons.delete_forever, color: AppColors.red),
                        title: CustomTextWidget(
                          textString: DynamicAppLocalizations.of(Get.context!)
                              .t("delete_account"),
                          textSize: FontSize().regular,
                          fontColor: AppColors.red,
                          isFontBold: false,
                        ),
                        textColor: AppColors.red,
                        onTap: () {
                          controller.deleteAccountController.clear();
                          controller.deleteAccountErrorText.value = '';
                          Get.defaultDialog(
                            title: "",
                            titleStyle: const TextStyle(fontSize: 0),
                            titlePadding: EdgeInsets.zero,
                            barrierDismissible: false,
                            radius: 10,
                            backgroundColor: AppColors.white,
                            contentPadding: const EdgeInsets.all(16),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomTextWidget(
                                  textString: DynamicAppLocalizations.of(Get.context!).t("user_delete_title"),
                                  textSize: FontSize().medium,
                                  isFontBold: true,
                                  fontColor: AppColors.black,
                                  textCenter: true,
                                  numberOfLines: 5,
                                ),
                                const SizedBox(height: 8),
                                CustomTextWidget(
                                  textString: DynamicAppLocalizations.of(Get.context!).t("user_delete_desc"),
                                  textSize: FontSize().regular,
                                  isFontBold: false,
                                  fontColor: AppColors.black,
                                  numberOfLines: 20,
                                  textCenter: true,
                                ),
                                const SizedBox(height: 12),
                                CustomTextWidget(
                                  textString: DynamicAppLocalizations.of(Get.context!).t("user_delete_confirmation"),
                                  textSize: FontSize().regular,
                                  isFontBold: false,
                                  fontColor: AppColors.black,
                                  numberOfLines: 20,
                                  textCenter: true,
                                ),
                                const SizedBox(height: 12),
                                Obx(() => TextField(
                                  controller: controller.deleteAccountController,
                                  decoration: InputDecoration(
                                    hintText: 'Type \'Delete Account\'',
                                    errorText: controller.deleteAccountErrorText.value.isEmpty ? null : controller.deleteAccountErrorText.value,
                                    border: const OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    if (controller.deleteAccountErrorText.value.isNotEmpty) {
                                      controller.deleteAccountErrorText.value = '';
                                    }
                                  }
                                )),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: CustomTextButton(
                                        title: DynamicAppLocalizations.of(Get.context!).t("cancel"),
                                        width: 110,
                                        textColor: AppColors.black,
                                        backgroundColor: AppColors.white,
                                        onPressed: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                    CustomElevatedButton(
                                      title: DynamicAppLocalizations.of(Get.context!).t("yes"),
                                      width: 120,
                                      textColor: AppColors.white,
                                      backgroundColor: AppColors.primaryColor,
                                      onPressed: () {
                                        if (controller.deleteAccountController.text == 'Delete Account') {
                                          Get.back();
                                          controller.deleteUser();
                                        } else {
                                          controller.deleteAccountErrorText.value = 'Please type exactly \'Delete Account\'';
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
      ),
    );
  }
}
