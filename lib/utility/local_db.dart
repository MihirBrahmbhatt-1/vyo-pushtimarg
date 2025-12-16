import 'package:shared_preferences/shared_preferences.dart';

class LocalDB {
  final jwtTokenKey = "jwtToken";
  final customerId = "customerId";
  final userFullName = "userFullName";
  final deviceId = "mobileDeviceId";
  final deviceName = "mobileDeviceName";
  final rememberMe = "rememberMe";
  final userEmail = "username";
  final pass = "password";
  final fcmToken = "deviceNotificationToken";
  final deviceOsTypeKey = "deviceOsType";
  final isLoggedIn = "isLoggedIn";
  final isFirstTimeAppOpen = "isFirstTimeAppOpen";
  final userDeviceOSVersionKey = "userDeviceOSVersionKey";
  final userDeviceModelNumberKey = "userDeviceModelNumberKey";
  final isAccountDeletedKey = "isAccountDeletedKey";
  final inactiveAccountKey = "inactiveAccountKey";
  final isInitialLanguageSelected = "isInitialLanguageSelected";
  final userPhoneNumberKey = "userPhoneNumberKey";
  final countryCodeKey = "countryCodeKey";
  final selectedLanguageIdKey = "selectedLanguageIdKey";
  final isUserExistsKey = "isUserExistsKey";
  final labelLanguageVersionKey = "labelLanguageVersionKey";
  final labelLanguageVersionCacheKey = "labelLanguageVersionCacheKey";
  final dashboardVersionKey = "dashboardVersionKey";
  final dashboardSliderVersionKey = "dashboardSliderVersionKey";
  final isUserProfileCompletedKey = "isUserProfileCompletedKey";
  final userCountryIdKey = 'userCountryIdKey';
  final userCountryNameKey = 'userCountryNameKey';
  final userStateIdKey = 'userStateIdKey';
  final userStateNameKey = 'userStateNameKey';
  final userCityIdKey = 'userCityIdKey';
  final userCityNameKey = 'userCityNameKey';
  final userGenderIdKey = 'userGenderIdKey';
  final userDOBKey = 'userDOBKey';
  final dashboardHtmlCacheKey = 'dashboardHtmlCacheKey';
  final dashboardimageSliderCacheKey = 'dashboardimageSliderCacheKey';
  final forgotPasswordOtpResendAttemptsKey = 'forgotPasswordOtpResendAttemptsKey';
  final forgotPasswordOtpNextResendTimeKey = 'forgotPasswordOtpNextResendTimeKey';
  final isUserSurveyCompletedKey = "isUserSurveyCompletedKey";


  Future<bool> setIsLanguageSelected(bool isLanguageSelected) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isInitialLanguageSelected, isLanguageSelected);
  }

  Future<bool?> getIsLanguageSelected() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isInitialLanguageSelected);
  }

  Future<bool> setIsUserProfileCompleted(bool isUserProfileCompleted) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isUserProfileCompletedKey, isUserProfileCompleted);
  }

  Future<bool?> getIsUserProfileCompleted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isUserProfileCompletedKey);
  }


  Future<bool> setIsUserSurveyCompleted(bool isUserSurveyCompleted) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isUserSurveyCompletedKey, isUserSurveyCompleted);
  }

  Future<bool?> getIsUserSurveyCompleted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isUserSurveyCompletedKey);
  }


  Future<bool> setDeviceOsType(String deviceOsTypeValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        deviceOsTypeKey, deviceOsTypeValue);
  }

  Future<String?> getDeviceOsType() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(deviceOsTypeKey);
  }

  Future<bool> setDeviceID(String deviceIdValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(deviceId, deviceIdValue);
  }

  Future<String?> getDeviceID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(deviceId);
  }

  Future<bool> removeDeviceID() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(deviceId);
  }

  Future<bool> setDeviceName(String deviceIDvalue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(deviceName, deviceIDvalue);
  }

  Future<String?> getDeviceName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(deviceName);
  }

  Future<bool> setIsLoggedIn(bool firstTime) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isLoggedIn, firstTime);
  }

  Future<bool?> getIsLoggedIn() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isLoggedIn);
  }

  Future<bool> setTokenFirebase(String tokenValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(fcmToken, tokenValue);
  }

  Future<String?> getTokenFirebase() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(fcmToken);
  }

  Future<bool> removeTokenFirebase() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(fcmToken);
  }


  Future<bool> setLabelLanguageVersion(String labelLanguageVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(labelLanguageVersionKey, labelLanguageVersion);
  }

  Future<String?> getLabelLanguageVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(labelLanguageVersionKey);
  }

  Future<bool> setLanguageLabelsCache(String labelLanguageVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(labelLanguageVersionCacheKey, labelLanguageVersion);
  }

  Future<String?> getLanguageLabelsCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(labelLanguageVersionCacheKey);
  }


  Future<bool> setForgotPasswordOtpAttempts(int forgotPasswordOtpAttempts) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setInt(forgotPasswordOtpResendAttemptsKey, forgotPasswordOtpAttempts);
  }

  Future<int?> getForgotPasswordOtpAttempts() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(forgotPasswordOtpResendAttemptsKey);
  }

  Future<bool> setForgotPasswordOtpNextResendTime(String forgotPasswordOtpAttempts) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(forgotPasswordOtpNextResendTimeKey, forgotPasswordOtpAttempts);
  }

  Future<String?> getForgotPasswordOtpNextResendTime() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(forgotPasswordOtpNextResendTimeKey);
  }


  Future<bool> setDashboardVersion(String dashboardVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(dashboardVersionKey, dashboardVersion);
  }

  Future<String?> getDashboardVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(dashboardVersionKey);
  }

  Future<bool> setDashboardSliderVersion(String dashboardSliderVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(dashboardSliderVersionKey, dashboardSliderVersion);
  }

  Future<String?> getDashboardSliderVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(dashboardSliderVersionKey);
  }
  Future<bool> setUserPhoneNumber(String userPhoneNumber) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userPhoneNumberKey, userPhoneNumber);
  }

  Future<String?> getUserPhoneNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userPhoneNumberKey);
  }

  Future<bool> removeUserPhoneNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userPhoneNumberKey);
  }

  Future<bool> setCountryCode(String countryCode) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(countryCodeKey, countryCode);
  }

  Future<String?> getCountryCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(countryCodeKey);
  }

  Future<bool> removeCountryCode() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(countryCodeKey);
  }

  Future<bool> setLanguageId(String languageId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(selectedLanguageIdKey, languageId);
  }

  Future<String?> getLanguageId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(selectedLanguageIdKey);
  }

  Future<bool> removeLanguageId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(selectedLanguageIdKey);
  }

  Future<bool> setIsUserExists(bool isUserExist) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(isUserExistsKey, isUserExist);
  }

  Future<bool?> getIsUserExists() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isUserExistsKey);
  }

  Future<bool> removeIsUserExists() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(isUserExistsKey);
  }

  Future<bool> setJwtToken(String jwtTokenValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(jwtTokenKey, jwtTokenValue);
  }

  Future<String?> getJwtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(jwtTokenKey);
  }

  Future<bool> removeJwtToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(jwtTokenKey);
  }

  Future<bool> setCustomerId(String customerValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(customerId, customerValue);
  }

  Future<String?> getCustomerId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(customerId);
  }

  Future<bool> removeCustomerId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(customerId);
  }

  Future<bool> setUserFullName(String userFullNameValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userFullName, userFullNameValue);
  }

  Future<String?> getUserFullName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userFullName);
  }

  Future<bool> removeUserFullName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userFullName);
  }

  Future<bool> setUserGenderId(String userGenderId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userGenderIdKey, userGenderId);
  }

  Future<String?> getUserGenderId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userGenderIdKey);
  }

  Future<bool> removeUserGenderId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userGenderIdKey);
  }

  Future<bool> setUserEmail(String emailValue) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userEmail, emailValue);
  }

  Future<String?> getUserEmail() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userEmail);
  }

  Future<bool> setUserPassword(String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return await sharedPreferences.setString(pass, password);
  }

  Future<String?> getUserPassword() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    return sharedPreferences.getString(pass);
  }

  // isAccountDeletedKey
  Future<bool> setIsAccountDeleted(bool isAccountDeleted) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(isAccountDeletedKey, isAccountDeleted);
  }

  Future<bool?> getIsAccountDeleted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(isAccountDeletedKey);
  }

  Future<bool> removeIsAccountDeleted() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(isAccountDeletedKey);
  }

  // inactiveAccountKey
  Future<bool> setInactiveAccount(bool inactiveAccount) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.setBool(inactiveAccountKey, inactiveAccount);
  }

  Future<bool?> getInactiveAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getBool(inactiveAccountKey);
  }

  Future<bool> removeInactiveAccount() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(inactiveAccountKey);
  }

  // ! User Device OS Version
  Future<bool> setUserDeviceOsVersion(userDeviceOsVersion) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userDeviceOSVersionKey, userDeviceOsVersion);
  }

  Future<String?> getUserDeviceOsVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDeviceOSVersionKey);
  }

  Future<bool> removeUserDeviceOsVersion() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userDeviceOSVersionKey);
  }

  // ! User Device Model Number String
  Future<bool> setUserDeviceModelNumber(userDeviceModelNumber) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userDeviceModelNumberKey, userDeviceModelNumber);
  }

  Future<String?> getUserDeviceModelNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDeviceModelNumberKey);
  }

  Future<bool> removeUserDeviceModelNumber() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userDeviceModelNumberKey);
  }

  
  Future<bool> setUserCountryId(userCountryId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userCountryIdKey, userCountryId);
  }

  Future<String?> getUserCountryId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userCountryIdKey);
  }

  Future<bool> removeUserCountryId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userCountryIdKey);
  }
  
  
  Future<bool> setUserCountryName(userCountrName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userCountryNameKey, userCountrName);
  }

  Future<String?> getUserCountryName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userCountryNameKey);
  }

  Future<bool> removeUserCountryName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userCountryNameKey);
  }
  
  Future<bool> setUserStateId(userStateId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userStateIdKey, userStateId);
  }

  Future<String?> getUserStateId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userStateIdKey);
  }

  Future<bool> removeUserStateId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userStateIdKey);
  }
  
  Future<bool> setUserStateName(userStateName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userStateNameKey, userStateName);
  }

  Future<String?> getUserStateName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userStateNameKey);
  }

  Future<bool> removeUserStateName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userStateNameKey);
  }

  Future<bool> setUserCityId(userCityId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userCityIdKey, userCityId);
  }

  Future<String?> getUserCityId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userCityIdKey);
  }

  Future<bool> removeUserCityId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userCityIdKey);
  }

  Future<bool> setUserCityName(userCityName) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userCityNameKey, userCityName);
  }

  Future<String?> getUserCityName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userCityNameKey);
  }

  Future<bool> removeUserCityName() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userCityNameKey);
  }

  Future<bool> setUserDOB(userDOB) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(
        userDOBKey, userDOB);
  }

  Future<String?> getUserDOB() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(userDOBKey);
  }

  // 🎯 Saves the raw JSON string
  Future<void> setDashboardHtmlCache(String jsonString) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(dashboardHtmlCacheKey, jsonString);
  }

  // 🎯 Retrieves the raw JSON string
  Future<String?> getDashboardHtmlCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(dashboardHtmlCacheKey);
  }

  // 🎯 Saves the raw JSON string
  Future<void> setDashboardImageSliderCache(String jsonString) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString(dashboardimageSliderCacheKey, jsonString);
  }

  // 🎯 Retrieves the raw JSON string
  Future<String?> getDashboardImageSliderCache() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(dashboardimageSliderCacheKey);
  }

  Future<bool> removeUserDOB() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.remove(userDOBKey);
  }

  reloadSharedPref() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.reload();
  }
}
