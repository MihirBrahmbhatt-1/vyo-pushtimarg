import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../utility/common_functions.dart';
import '../../widget/custom_alert_widget.dart';
import '../../widget/custom_no_internet_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'preferred_language_settings_view_controller.dart';

class PreferredLanguageSettingsView extends StatelessWidget {
  const PreferredLanguageSettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PreferredLanguageSettingsViewController>(
      init: PreferredLanguageSettingsViewController(),
      builder: (controller) {
        return SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primaryColor,
              centerTitle: true,
              title: CustomTextWidget(
                textString:
                    DynamicAppLocalizations.of(Get.context!).t("change_language"),
                textSize: FontSize().appBar,
                fontColor: AppColors.white,
                isFontBold: false,
              ),
            ),
            body: Obx(
              () => controller.homeController.isDisplayInternetConnection.value ?
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: CustomNoInternetWidget(
                        displayMessage: controller.displayInternetConnection.isEmpty
                        ? ""
                        : controller.displayInternetConnection.value,
                          onPressed: () async {
                            await checkInternetStatus(
                              onConnected: () async {
                                controller.homeController.isDisplayInternetConnection.value = false;
                                controller.fetchLanguage();
                              },
                              onNoConnection: () {
                                controller.homeController.isDisplayInternetConnection.value = true;
                              },
                            );
                          },
                        ),
                    ),
                  )
                   : controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : controller.languageListData.isEmpty
                      ? Center(
                          child: CustomTextWidget(
                            textString: DynamicAppLocalizations.of(Get.context!)
                                .t("no_languages_available"),
                            textSize: FontSize().regular,
                            fontColor: AppColors.grey200,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 10.0),
                          itemCount: controller.languageListData.length,
                          itemBuilder: (context, index) {
                            final language = controller.languageListData[index];
                            final isSelected =
                                controller.selectedLanguageId.value ==
                                    language.id.toString();
          
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 5.0),
                              child: Card(
                                elevation: isSelected ? 2 : 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(borderRadius),
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppColors.primaryColor
                                        : Colors.transparent,
                                    width: 2,
                                  ),
                                ),
                                child: ListTile(
                                  onTap: () {
                                    if (!isSelected) {
                                      _showConfirmationDialog(
                                          context,
                                          controller,
                                          language.id.toString(),
                                          language.languageName ?? '');
                                    }
                                  },
                                  title: CustomTextWidget(
                                    textString: language.languageName ?? '',
                                    textSize: FontSize().regular,
                                    fontColor: isSelected
                                        ? AppColors.primaryColor
                                        : AppColors.black,
                                    isFontBold: isSelected,
                                  ),
                                  trailing: isSelected
                                      ? const Icon(
                                          Icons.check_circle,
                                          color: AppColors.primaryColor,
                                          size: 24,
                                        )
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ),
        );
      },
    );
  }

  void _showConfirmationDialog(
      BuildContext context,
      PreferredLanguageSettingsViewController controller,
      String languageId,
      String languageName) {
        CustomAlertWidget().infoAlertDialog(
      displayText: DynamicAppLocalizations.of(Get.context!).t("change_language"),
      displaySubText: DynamicAppLocalizations.of(Get.context!).t(
            "change_language_to",
            params: {'newLanguage': languageName},
          ),
      buttonText: DynamicAppLocalizations.of(Get.context!).t("yes"),
      cancelButtonText: DynamicAppLocalizations.of(Get.context!).t("cancel"),
      statusType: false,
      showCancelButton: true,
      onButtonTap: () async {
          await controller.updateLanguage(languageId);
      },
    );
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: CustomTextWidget(
    //       textString:
    //           DynamicAppLocalizations.of(Get.context!).t("change_language"),
    //       textSize: FontSize().medium,
    //       fontColor: AppColors.primaryColor,
    //       isFontBold: true,
    //     ),
    //     content: CustomTextWidget(
    //       textString:
    //           // '${DynamicAppLocalizations.of(Get.context!).t("change_language_to")} $languageName?',
    //           DynamicAppLocalizations.of(Get.context!).t(
    //         "change_language_to",
    //         params: {'newLanguage': languageName},
    //       ),
    //       textSize: FontSize().regular,
    //       fontColor: AppColors.primaryColor,
    //       numberOfLines: 10,
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: CustomTextWidget(
    //           textString: DynamicAppLocalizations.of(Get.context!).t("cancel"),
    //           textSize: FontSize().regular,
    //           fontColor: AppColors.primaryColor,
    //         ),
    //       ),
    //       TextButton(
    //         onPressed: () async {
    //           Navigator.pop(context);
    //           await controller.updateLanguage(languageId);
    //         },
    //         child: CustomTextWidget(
    //           textString: DynamicAppLocalizations.of(Get.context!).t("ok"),
    //           textSize: FontSize().regular,
    //           fontColor: AppColors.primaryColor,
    //           isFontBold: true,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
