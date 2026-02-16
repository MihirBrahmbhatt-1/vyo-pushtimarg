import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../const/logger.dart';
import '../controller/home_controller.dart';
import '../localization/dynamic_app_localizations.dart';
import '../model/daily_seva_pranalika_response_model.dart';
import '../view/login/login_view.dart';
import '../widget/custom_alert_widget.dart';
import 'api_service_interceptor.dart';
import 'local_db.dart';

clearAppDataAndLogout() async {
  // HomeController homeController = Get.put(HomeController());
  ApiServiceInterceptor.isLoggingOut = true;
  ApiServiceInterceptor.cancelRequest();
  await LocalDB().setIsLoggedIn(false);
  await LocalDB().setIsUserExists(false);
  await LocalDB().setIsUserProfileCompleted(false);
  await LocalDB().setIsUserSurveyCompleted(false);
  await LocalDB().setJwtToken('');
  await LocalDB().setDashboardVersion('');
  await LocalDB().setDashboardSliderVersion('');
  await LocalDB().setDashboardHtmlCache('');
  await LocalDB().setDashboardImageSliderCache('');
  await LocalDB().setLabelLanguageVersion('');
  await LocalDB().setLanguageLabelsCache('');
  await LocalDB().setCustomerId('');
  await LocalDB().setUserPassword('');
  await LocalDB().removeJwtToken();
  await LocalDB().removeCustomerId();
  await LocalDB().reloadSharedPref();
  // homeController.jwtToken.value = '';
  // homeController.isLoggedIn.value = false;
  // homeController.selectedIndex.value = 0;
  // Get.offAllNamed(Routes.signin);
  Get.offAll(() => LoginView());

  // Get.lazyPut(()=>LoginViewController());
  ApiServiceInterceptor.isLoggingOut = false;
}

Future<bool> checkInternetStatus({
  Future<Map<String, dynamic>> Function()? checkInternet,
  Function(String)? showMessage,
  Future<void> Function()? onConnected,
  VoidCallback? onNoConnection,
  bool showConnectedMessage = false,
}) async {
  final checkFn = checkInternet ?? ApiServiceInterceptor.checkInternetFunction;
  final result = await checkFn();
  final status = result['status'] as InternetStatus;

  // helpers
  String localized(String key, String fallback) {
    try {
      final res = DynamicAppLocalizations.of(Get.context!).t(key);
      if (res == key || res.trim().isEmpty) return fallback;
      return res;
    } catch (e) {
      return fallback;
    }
  }

  // Default message handlers if none provided
  void defaultShowMessage(String msg) {
    try {
      // CustomAlertWidget().infoAlertDialog(
      //   displayText: msg,
      //   buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
      //   statusType: false,
      // );
    } catch (e) {
      // fallback to no-op if context is not available
    }
  }

  noConnectionHandler() {
    try {
      // allow caller to override; otherwise set a default display flag
      HomeController homeController = Get.put(HomeController());
      homeController.isDisplayInternetConnection.value = true;
    } catch (e) {
      // ignore
    }
  }

  if (status == InternetStatus.noNetwork) {
    final msg = showMessage != null
        ? localized("no_network_connection",
            "No network connection. Please enable Wi-Fi or mobile data.")
        : localized("no_network_connection",
            "No network connection. Please enable Wi-Fi or mobile data.");
    if (showMessage != null) {
      showMessage(msg);
    } else {
      defaultShowMessage(msg);
    }
    if (onNoConnection != null) {
      onNoConnection();
    } else {
      noConnectionHandler();
    }
    return false;
  }

  if (status == InternetStatus.noInternet) {
    final msg = showMessage != null
        ? localized("no_internet_connection",
            "Network connected, but no internet accessible. Please check your data plan.")
        : localized("no_internet_connection",
            "Network connected, but no internet accessible. Please check your data plan.");
    if (showMessage != null) {
      showMessage(msg);
    } else {
      defaultShowMessage(msg);
    }
    if (onNoConnection != null) {
      onNoConnection();
    } else {
      noConnectionHandler();
    }
    return false;
  }

  if (status == InternetStatus.connected) {
    if (showConnectedMessage) {
      final msg = localized("youre_online", "You're online.");
      if (showMessage != null) {
        showMessage(msg);
      } else {
        try {
          CustomAlertWidget().infoAlertDialog(
            displayText: msg,
            buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
            statusType: true,
          );
        } catch (e) {}
      }
    }

    if (onConnected != null) {
      await onConnected();
    }

    return true;
  }

  // Fallback
  if (onNoConnection != null) {
    onNoConnection();
  } else {
    noConnectionHandler();
  }
  return false;
}


Future<void> checkDeviceConfig() async {
  final deviceInfo = DeviceInfoPlugin();
  final HomeController homeController = Get.put(HomeController());
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  talker.info('------ device Version:${packageInfo.version.toString()}');
  homeController.userAppInstalledVersionName.value = packageInfo.version;
  if (Platform.isAndroid) {
    const androidIdPlugin = AndroidId();
    final androidInfo = await deviceInfo.androidInfo;
    homeController.userDeviceIdString.value =
        (await androidIdPlugin.getId()) ?? '';
    homeController.userDeviceNameString.value =
        '${androidInfo.manufacturer.toString()} - ${androidInfo.model.toString()}';
    homeController.userDeviceOsTypeString.value = "0";
    homeController.userDeviceOsVersionString.value =
        androidInfo.version.release.toString();
    homeController.userDeviceModelNumberString.value =
        androidInfo.id.toString();
  } else {
    final iosInfo = await deviceInfo.iosInfo;
    homeController.userDeviceIdString.value =
        iosInfo.identifierForVendor.toString();
    homeController.userDeviceNameString.value =
        '${iosInfo.systemName.toString()} - ${iosInfo.modelName.toString()}';
    homeController.userDeviceOsVersionString.value =
        iosInfo.systemVersion.toString();
    homeController.userDeviceOsTypeString.value = "1";
    homeController.userDeviceModelNumberString.value = iosInfo.model.toString();
  }
}

getPlatformUpdate(List<AppUpdates> updates) {
  if (Platform.isIOS) {
    return updates.firstWhereOrNull((e) => e.appOsType == "1");
  } else if (Platform.isAndroid) {
    return updates.firstWhereOrNull((e) => e.appOsType == "0");
  } else {
    return null;
  }
}

int getExtendedVersionNumber(String version) {
  List versionCells = version.split('.');
  versionCells = versionCells.map((i) => int.parse(i)).toList();
  int convertingVersionCells =
      versionCells[0] * 100000 + versionCells[1] * 1000 + versionCells[2];
  return convertingVersionCells;
}

showForceUpdateDialog(AppUpdates update) {
  if (Platform.isIOS) {
    return Get.dialog(
      PopScope(
        canPop: update.forceUpdate == true ? false : true,
        // showCancelButton: update.forceUpdate == true ? false : true,
        child: CupertinoAlertDialog(
          title: Text(
              DynamicAppLocalizations.of(Get.context!).t("update_required")),
          content: Text(
            DynamicAppLocalizations.of(Get.context!)
                .t("update_required_description"),
          ),
          actions: [
            update.forceUpdate == false
                ? CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () {
                      Get.back(result: 'cancel');
                    },
                    child: Text(
                        DynamicAppLocalizations.of(Get.context!).t("cancel")),
                  )
                : const SizedBox(),
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => launchUrl(
                Uri.parse(update.url.toString()),
                mode: LaunchMode.externalApplication,
              ),
              child: Text(
                  DynamicAppLocalizations.of(Get.context!).t("app_update")),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  } else {
    return CustomAlertWidget().simpleAlertDialog(
        title: DynamicAppLocalizations.of(Get.context!).t("update_required"),
        description: DynamicAppLocalizations.of(Get.context!)
            .t("update_required_description"),
        canPop: update.forceUpdate == true ? false : true,
        showCancelButton: update.forceUpdate == true ? false : true,
        buttonText: DynamicAppLocalizations.of(Get.context!).t("app_update"),
        onButtonTap: () {
          launchUrl(
            Uri.parse(update.url.toString()),
            mode: LaunchMode.externalApplication,
          );
        });
  }
}

clearVersionList() async {
  await LocalDB().setLanguageLabelsCache('');
  await LocalDB().setPushtiPracticesVersion('');
  await LocalDB().setDashboardVersion('');
  await LocalDB().setLanguageLabelsCache('');
}
