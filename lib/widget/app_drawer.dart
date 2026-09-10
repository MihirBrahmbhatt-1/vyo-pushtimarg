import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../const/app_color.dart';
import '../../widget/custom_text_widget.dart';
import '../const/app_assets.dart';
import '../const/app_constant.dart';
import '../const/logger.dart';
import '../controller/api_controller.dart';
import '../controller/home_controller.dart';
import '../localization/dynamic_app_localizations.dart';
import '../navigation/pages.dart';
import '../utility/common_functions.dart';
import '../view/dashboard/dashboard_view_controller.dart';
import 'custom_alert_widget.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_icon_widget.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  Widget _buildDrawerItem({
    required Widget icon,
    required String titleKey,
    required VoidCallback onTap,
  }) {
    return ListTile(
      // leading: Icon(icon, color: AppColors.primaryColor),
      leading: icon,
      title: CustomTextWidget(
        textString: DynamicAppLocalizations.of(Get.context!).t(titleKey),
        textSize: FontSize().medium,
        fontColor: AppColors.primaryColor,
        isFontBold: false,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.put(HomeController());
    final DashboardViewController dashboardViewController =
        Get.find<DashboardViewController>();
    return SafeArea(
      top: false,
      child: Drawer(
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

            // DRAWER ITEMS
            _buildDrawerItem(
              icon: Icon(
                Icons.home,
                color: AppColors.primaryColor,
              ),
              titleKey: "home",
              onTap: () {
                Get.back();
              },
            ),

            _buildDrawerItem(
              icon: CustomImageAssetWidget(
                imagePath: AppIcons.sevaPranalikaImg,
                height: 40,
                width: 30,
              ),
              titleKey: "seva_pranalika_title",
              onTap: () async {
                await checkInternetStatus(
                  onConnected: () async {
                    Get.back();
                    dashboardViewController.displaySevaPranalikaAlert(false, false);
                  },
                  onNoConnection: () {
                    Get.back();
                    homeController.isDisplayInternetConnection.value = true;
                  },
                );
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.group,
                color: AppColors.primaryColor,
              ),
              titleKey: "about_vyo",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/about-us/');
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.person,
                color: AppColors.primaryColor,
              ),
              titleKey: "about_founder",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/founder/');
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.video_camera_back,
                color: AppColors.primaryColor,
              ),
              titleKey: "video_gallery",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/video-gallery/');
              },
            ),

            _buildDrawerItem(
              icon: FaIcon(
                FontAwesomeIcons.dollarSign,
                color: AppColors.primaryColor,
              ),
              titleKey: "donate",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/donations/');
              },
            ),

            _buildDrawerItem(
              icon: FaIcon(
                FontAwesomeIcons.bookOpen,
                color: AppColors.primaryColor,
              ),
              titleKey: "vyo_education",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/vyo-education/');
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.work_outline_outlined,
                color: AppColors.primaryColor,
              ),
              titleKey: "projects",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/projects/');
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.event,
                color: AppColors.primaryColor,
              ),
              titleKey: "upcoming_events",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/events/');
              },
            ),

            // _buildDrawerItem(
            //   icon: Icons.home,
            //   titleKey: "past_events",
            //   onTap: () {
            //     Get.back();
            //     _launchURL('https://vyoworld.org/events/');
            //   },
            // ),
            _buildDrawerItem(
              icon: Icon(
                Icons.person,
                color: AppColors.primaryColor,
              ),
              titleKey: "profile",
              onTap: () {
                Get.back();
                Get.toNamed(Routes.userprofile);
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.share,
                color: AppColors.primaryColor,
              ),
              titleKey: "share_app",
              onTap: () {
                Get.back();
                _shareApp();
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.contact_page,
                color: AppColors.primaryColor,
              ),
              titleKey: "contact_us",
              onTap: () {
                Get.back();
                _launchURL('https://vyoworld.org/contact-us/');
              },
            ),

            _buildDrawerItem(
              icon: Icon(
                Icons.logout,
                color: AppColors.primaryColor,
              ),
              titleKey: "logout",
              onTap: () async {
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
                    await _performLogout(homeController);
                  },
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _performLogout(HomeController homeController) async {
    ApiController apiController = Get.put(ApiController());
    try {
      apiController.logoutUser(
        deviceId: homeController.userDeviceIdString.value,
        jwtToken: homeController.jwtToken.value,
      );
    } catch (e) {
      talker.error('Error in _perforLogout func: ${e.toString()}');
    }
  }

  void _launchURL(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      debugPrint('Could not launch URL: $url');
    }
  }

  _shareApp() async {
    final String androidAppUrl =
        "https://play.google.com/store/apps/details?id=com.vyo.pushtimarg";
    final String iOSAppUrl =
        "https://apps.apple.com/us/app/vyo-world-app/id6788855655";
    final String message =
        "Download VYO World App Now And Share with Your Family | Friends.\n\nFor Android:\n$androidAppUrl\n\nFor iOS:\n$iOSAppUrl";

    await SharePlus.instance.share(
      ShareParams(text: message),
    );
  }
}
