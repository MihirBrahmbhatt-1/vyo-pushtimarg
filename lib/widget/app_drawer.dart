import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../widget/custom_text_widget.dart';
import '../const/app_assets.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryColor.withValues(alpha: 0.6),
                ],
              ),
            ),
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child: Center(
              child: Hero(
                tag: "vyoAppLogo",
                child: Column(
                  children: [
                    Image.asset(AppIcons.appLogo, height: 120, width: 120),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),

          // ITEMS
          ListTile(
            leading: Icon(Icons.home, color: AppColors.primaryColor,),
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
            leading: Icon(Icons.person, color: AppColors.primaryColor,),
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
            leading: Icon(Icons.settings, color: AppColors.primaryColor,),
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
            leading: Icon(Icons.logout, color: AppColors.primaryColor,),
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
                  await LocalDB().setLanguageLabelsCache('');
                  await LocalDB().setUserPassword('');
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
