import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../const/app_assets.dart';
import '../../../const/app_color.dart';
import '../../../const/app_constant.dart';
import '../../../localization/dynamic_app_localizations.dart';
import '../../../navigation/pages.dart';
import '../../../widget/custom_button_widget.dart';
import '../../../widget/custom_text_widget.dart';
import 'survey_success_view_controller.dart';

class SurveySuccessView extends GetView<SurveySuccessViewController> {
  const SurveySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SurveySuccessViewController());
    return PopScope(
      canPop: false,
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          body: Stack(
            children: [
              SingleChildScrollView(
                child: SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Center(
                          child: Image.asset(
                            AppIcons.appLogo,
                            height: 120,
                            width: 120,
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomTextWidget(
                          textString: DynamicAppLocalizations.of(context).t("survey_success_title"),
                          fontColor: AppColors.primaryColor,
                          textSize: FontSize().large,
                          fontStyle: FontStyle.normal,
                          isFontBold: true,
                          textCenter: true,
                          numberOfLines: 20,
                        ),
                        const SizedBox(height: 8),
                        CustomTextWidget(
                          textString: DynamicAppLocalizations.of(context).t("survey_success_subtitle"),
                          fontColor: AppColors.primaryColor,
                          textSize: FontSize().large,
                          fontStyle: FontStyle.normal,
                          isFontBold: false,
                          textCenter: true,
                          numberOfLines: 20,
                        ),
                        const SizedBox(height: 8),
                        Obx(() => 
                         controller.showButton.value ? Center(
                            child: CustomElevatedButton(
                              width: MediaQuery.of(Get.context!).size.width * 0.80,
                              title: DynamicAppLocalizations.of(
                                Get.context!,
                              ).t("ok"),
                              textColor: AppColors.white,
                              onPressed: () {
                                controller.homeController.selectedIndex.value = 2;
                                // Get.offAllNamed(Routes.home);
                                Get.offAllNamed(Routes.home, arguments: {"isInternalNavigation": true});

                              },
                              backgroundColor: AppColors.primaryColor,
                            ),
                          ) : const SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ConfettiWidget(
                confettiController: controller.confettiController!,
                blastDirectionality: BlastDirectionality.directional,
                blastDirection: 3.14159 / 6,
                shouldLoop: false,
                colors: [
                  AppColors.red,
                  AppColors.green,
                  AppColors.primaryColor,
                  AppColors.blue,
                ],
                numberOfParticles: 200,
                gravity: 0.9,
                maxBlastForce: 40,
                emissionFrequency: 0.6,

              ),
            ],
          ),
        ),
      ),
    );
  }
}
