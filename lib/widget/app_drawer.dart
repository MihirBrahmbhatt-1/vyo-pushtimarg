import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../widget/custom_text_widget.dart';
import '../const/app_constant.dart';
import '../controller/home_controller.dart';
import '../localization/dynamic_app_localizations.dart';
import '../navigation/pages.dart';
import '../utility/local_db.dart';
import 'custom_alert_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    return Drawer(
      elevation: 0,
      backgroundColor: AppColors.white,

      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // HEADER
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primaryColor),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Center(
              child: CustomTextWidget(
                textString: DynamicAppLocalizations.of(Get.context!).t("menu"),
                textSize: 22,
                isFontBold: true,
                fontColor: AppColors.primaryColor,
                isFontUnderline: false,
              ),
            ),
          ),

          // ITEMS
          ListTile(
            leading: const Icon(Icons.home),
            title: CustomTextWidget(
              textString: DynamicAppLocalizations.of(Get.context!).t("home"),
              textSize: FontSize().regular,
              fontColor: AppColors.primaryColor,
              isFontBold: false,
            ),
            onTap: () {
              Get.back();
            },
          ),

          ListTile(
            leading: const Icon(Icons.person),
            title: CustomTextWidget(
              textString: DynamicAppLocalizations.of(Get.context!).t("profile"),
              textSize: FontSize().regular,
              fontColor: AppColors.primaryColor,
              isFontBold: false,
            ),
            onTap: () {
              Get.back();
              Get.toNamed(Routes.userprofile);
            },
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: CustomTextWidget(
              textString: DynamicAppLocalizations.of(Get.context!).t("menu"),
              textSize: FontSize().regular,
              fontColor: AppColors.primaryColor,
              isFontBold: false,
            ),
            onTap: () {
              Get.back();
              homeController.selectedIndex.value = 3;
            },
          ),

          ListTile(
            leading: const Icon(Icons.logout),
            title: CustomTextWidget(
              textString: DynamicAppLocalizations.of(Get.context!).t("logout"),
              textSize: FontSize().regular,
              fontColor: AppColors.primaryColor,
              isFontBold: false,
            ),
            onTap: () {
              Get.back();
              CustomAlertWidget().infoAlertDialog(
                displayText: DynamicAppLocalizations.of(
                  Get.context!,
                ).t("logout_title"),
                displaySubText: DynamicAppLocalizations.of(
                  Get.context!,
                ).t("logout_description"),
                buttonText: DynamicAppLocalizations.of(Get.context!).t("yes"),
                cancelButtonText: DynamicAppLocalizations.of(
                  Get.context!,
                ).t("cancel"),
                statusType: false,
                showCancelButton: true,
                onButtonTap: () async {
                  Get.back();
                  await LocalDB().setIsLoggedIn(false);
                  await LocalDB().setIsUserExists(false);
                  await LocalDB().setIsUserProfileCompleted(false);
                  await LocalDB().setJwtToken('');
                  await LocalDB().setDashboardVersion('');
                  await LocalDB().setDashboardSliderVersion('');
                  await LocalDB().setDashboardHtmlCache('');
                  await LocalDB().setDashboardImageSliderCache('');
                  await LocalDB().setLabelLanguageVersion('');
                  await LocalDB().removeJwtToken();
                  homeController.jwtToken.value = '';
                  homeController.isLoggedIn.value = false;
                  homeController.selectedIndex.value = 0;
                  Get.offAllNamed(Routes.signin);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
