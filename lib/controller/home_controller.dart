import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utility/local_db.dart';

class HomeController extends GetxController {

  RxString userEmailString = "".obs;
  RxString userNameString = "".obs;
  RxString jwtToken = "".obs;
  RxString customerIdString = "".obs;
  RxString deviceIdString = "".obs;
  RxString deviceIdNameString = "".obs;
  RxString fcmTokenString = ''.obs;
  RxString deviceOsTypeString = "".obs;
  RxString passwordString = "".obs;
  RxString deviceOsVersionString = "".obs;
  RxString deviceModelNumberString = "".obs;
  RxString userPhoneNumber = "".obs;
  RxString countryCode = "".obs;
  RxString selectedLanguageId = "".obs;
  RxString labelLanguageVersion= "".obs;
  RxString userCountryId = "".obs;
  RxString userCountryName = "".obs;
  RxString userStateId = "".obs;
  RxString userStateName = "".obs;
  RxString userCityId = "".obs;
  RxString userCityName = "".obs;
  RxString userGenderId = "".obs;
  RxString userDOB = "".obs;

  RxList<String> fcmNotificationUniqueIdString = <String>[].obs;

  RxBool isLogout = false.obs;
  RxBool isScrollDown = false.obs;

  RxBool isChecked = false.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isAccountReview = false.obs;
  RxBool isUserExists= false.obs;
  RxBool isUserProfileCompleted= false.obs;

  // RxBool isNoInternetDialogOpen = false.obs;
  // RxBool isInternetOff = false.obs;
  // RxBool isInternetLoading = false.obs;
  // RxBool isConnected = false.obs;
  RxBool isNoInternetLottieLoading = false.obs;
  RxBool isMailExist = false.obs;
  RxBool isDialogShowing = false.obs;
  RxBool isFirstTimeFCMOpen = false.obs;


  RxInt otp = 0.obs;
  RxInt statusCode = 0.obs;
  RxInt selectedIndex = 0.obs;
  RxInt loginType = 5.obs;

  final scrollController = ScrollController().obs;


  final packageInfo =
      PackageInfo(appName: "", packageName: "", version: "", buildNumber: "")
          .obs;

  @override
  void onInit() {
    super.onInit();
    reload();
    initPackageInfo();
  }

  Future<void> initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo.value = info;
    update();
  }


  reload() async {
    await LocalDB().getDeviceOsType().then((value) {
      deviceOsTypeString.value = value.toString();
    });

    await LocalDB().getUserPassword().then((value) {
      passwordString.value = value.toString();
    });

    await LocalDB().getUserFullName().then((value) {
      if (value != null) {
        userNameString.value = value.toString();
      } else {
        userNameString.value = '';
      }
    });

    await LocalDB().getDeviceID().then((value) {
      if (value != null) {
        deviceIdString.value = value.toString();
      } else {
        deviceIdString.value = '';
      }
    });

    await LocalDB().getDeviceName().then((value) {
      deviceIdNameString.value = value.toString();
    });


    await LocalDB().getUserEmail().then((value) {
      userEmailString.value = value.toString();
    });

    await LocalDB().getCustomerId().then((value) {
      if (value != null) {
        customerIdString.value = value.toString();
      } else {
        customerIdString.value = '';
      }
    });

    await LocalDB().getTokenFirebase().then((value) {
      fcmTokenString.value = (value.toString());
    });

    await LocalDB().getIsLoggedIn().then((value) {
      isLoggedIn.value = value ?? false;
    });

    await LocalDB().getIsUserProfileCompleted().then((value) {
      isUserProfileCompleted.value = value ?? false;
    });

    await LocalDB().getJwtToken().then((value) {
      if (value != null) {
        jwtToken.value = (value.toString());
      } else {
        jwtToken.value = '';
      }
    });


    await LocalDB().getIsUserExists().then((value) {
      isUserExists.value = value ?? false;
    });


    await LocalDB().getUserPhoneNumber().then((value) {
      userPhoneNumber.value = value ?? '';
    });

    await LocalDB().getLabelLanguageVersion().then((value) {
      labelLanguageVersion.value = value ?? '';
    });

    await LocalDB().getCountryCode().then((value) {
      countryCode.value = value ?? '';
    });

    await LocalDB().getUserCountryId().then((value) {
      userCountryId.value = value ?? '';
    });

    await LocalDB().getUserCountryName().then((value) {
      userCountryName.value = value ?? '';
    });

    await LocalDB().getUserStateId().then((value) {
      userStateId.value = value ?? '';
    });

    await LocalDB().getUserStateName().then((value) {
      userStateName.value = value ?? '';
    });

    await LocalDB().getUserCityId().then((value) {
      userCityId.value = value ?? '';
    });

    await LocalDB().getUserCityName().then((value) {
      userCityName.value = value ?? '';
    });

    await LocalDB().getUserDOB().then((value) {
      userDOB.value = value ?? '';
    });

    await LocalDB().getLanguageId().then((value) {
      selectedLanguageId.value = value ?? '';
    });

    await LocalDB().getUserGenderId().then((value) {
      userGenderId.value = value ?? '';
    });

    await LocalDB().getUserDeviceOsVersion().then((value) {
      if (value != null) {
        deviceOsVersionString.value = value.toString();
      } else {
        deviceOsVersionString.value = '';
      }
    });
    await LocalDB().getUserDeviceModelNumber().then((value) {
      if (value != null) {
        deviceModelNumberString.value =
            value.toString();
      } else {
        deviceModelNumberString.value = '';
      }
    });
  }


}
