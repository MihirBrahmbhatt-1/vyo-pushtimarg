import 'dart:io';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../const/logger.dart';
import '../controller/home_controller.dart';
import '../navigation/pages.dart';
import 'api_service_interceptor.dart';
import 'local_db.dart';

clearAppDataAndLogout() async {
  HomeController homeController = Get.put(HomeController());
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
  homeController.jwtToken.value = '';
  homeController.isLoggedIn.value = false;
  homeController.selectedIndex.value = 0;
  Get.offAllNamed(Routes.signin);
  ApiServiceInterceptor.isLoggingOut = false;
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
    homeController.userDeviceIdString.value = (await androidIdPlugin.getId()) ?? '';
    homeController.userDeviceNameString.value =
        '${androidInfo.manufacturer.toString()} - ${androidInfo.model.toString()}';
    homeController.userDeviceOsTypeString.value = "0";
    homeController.userDeviceOsVersionString.value =
        androidInfo.version.release.toString();
    homeController.userDeviceModelNumberString.value =
        androidInfo.id.toString();
  } else {
    final iosInfo = await deviceInfo.iosInfo;
    homeController.userDeviceIdString.value = iosInfo.identifierForVendor.toString();
    homeController.userDeviceNameString.value =
        '${iosInfo.systemName.toString()} - ${iosInfo.modelName.toString()}';
    homeController.userDeviceOsVersionString.value =
        iosInfo.systemVersion.toString();
    homeController.userDeviceOsTypeString.value = "1";
    homeController.userDeviceModelNumberString.value = iosInfo.model.toString();
  }
}
