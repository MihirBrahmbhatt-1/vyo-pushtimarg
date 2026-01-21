import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../widget/custom_alert_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'settings_view_controller.dart';

class SettingsView extends GetView<SettingsViewController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SettingsViewController());

    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          
          ListView(
            padding: const EdgeInsets.symmetric(vertical: 20),
            children: [
          
              // PROFILE
              ListTile(
                leading: const Icon(Icons.person, color: AppColors.primaryColor),
                title: CustomTextWidget(
                    textString: DynamicAppLocalizations.of(Get.context!).t("profile"),
                    textSize: FontSize().regular,
                    fontColor: AppColors.primaryColor,
                    isFontBold: false,
                  ),
                onTap: () {
                  Get.toNamed(Routes.userprofile);
                },
              ),
          
              const Divider(indent: 10.0, endIndent: 10.0,),
          
              ListTile(
                leading: const Icon(Icons.lock, color: AppColors.primaryColor),
                title: CustomTextWidget(
                    textString: DynamicAppLocalizations.of(Get.context!).t("change_password"),
                    textSize: FontSize().regular,
                    fontColor: AppColors.primaryColor,
                    isFontBold: false,
                  ),
                onTap: () {
                  Get.toNamed(Routes.changepassword);
                },
              ),
          
              const Divider(indent: 10.0, endIndent: 10.0,),
          
              ListTile(
                leading: const Icon(Icons.logout, color: AppColors.red),
                title: CustomTextWidget(
                    textString: DynamicAppLocalizations.of(Get.context!).t("logout"),
                    textSize: FontSize().regular,
                    fontColor: AppColors.red,
                    isFontBold: false,
                  ),
                textColor: AppColors.red,
                onTap: () {
                  CustomAlertWidget().infoAlertDialog(
                    displayText: DynamicAppLocalizations.of(Get.context!).t("logout_title"), 
                    displaySubText: DynamicAppLocalizations.of(Get.context!).t("logout_description"),
                    buttonText: DynamicAppLocalizations.of(Get.context!).t("yes"),
                    cancelButtonText: DynamicAppLocalizations.of(Get.context!).t("cancel"),
                    statusType: false,
                    showCancelButton: true,
                    onButtonTap: () {
                      controller.logoutUser();
                    },
                  );
                },
              ),
            ],
          ),
        controller.isLoading.value ? CircularProgressIndicator(color: AppColors.primaryColor,) : const SizedBox(),
        ],
      ),
    );
  }
}
