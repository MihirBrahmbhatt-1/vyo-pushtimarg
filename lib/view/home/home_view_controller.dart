import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../controller/home_controller.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../widget/custom_alert_widget.dart';
import '../../widget/custom_text_widget.dart';

class HomeViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());

  RxBool isLoading = false.obs;
  RxBool canPop = false.obs;

  loadApi() async {
    isLoading.value = true;
    await homeController.reload();
    isLoading.value = false;
  }

  displayPhoneNumberInfo() {
    return CustomAlertWidget().simpleAlertDialog(
        // title: DynamicAppLocalizations.of(Get.context!).t("info"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomTextWidget(
              fontColor: AppColors.primaryColor,
              textString: DynamicAppLocalizations.of(Get.context!)
                  .t("contact_support_description"),
              textSize: FontSize().regular,
              numberOfLines: 20,
              isFontBold: false,
              isFontUnderline: false,
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              title: InkWell(
                onTap: () {
                  launchUrlFunction(
                    Get.context!,
                    '+919601353414',
                  );
                },
                child: CustomTextWidget(
                  fontColor: AppColors.primaryColor,
                  textString: '+91 9601353414',
                  textSize: FontSize().xmedium,
                  numberOfLines: 2,
                  isFontBold: true,
                  isFontUnderline: false,
                  textCenter: true,
                ),
              ),
            ),
          ],
        ),
        buttonText: DynamicAppLocalizations.of(Get.context!).t("call"),
        onButtonTap: () {
          launchUrlFunction(
            Get.context!,
            '+919601353414',
          );
        });
  }

  Future<void> launchUrlFunction(
    BuildContext context,
    String userPhoneNumber,
  ) async {
    final call = Uri(scheme: 'tel', path: userPhoneNumber);

    if (await canLaunchUrl(call)) {
      await launchUrl(call);
    } else {}
  }
}
