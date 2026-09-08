import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';
import '../controller/api_controller.dart';
import '../controller/home_controller.dart';
import '../localization/dynamic_app_localizations.dart';
import '../navigation/pages.dart';
import '../utility/local_db.dart';
import '../view/dashboard/dashboard_view_controller.dart';
import 'custom_alert_widget.dart';

class UserPopupController extends GetxController {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());
  // Text fields
  final nameController = TextEditingController().obs;
  final emailTextController = TextEditingController().obs;
  final phoneController = TextEditingController(); // read-only number
  final newPasswordTextController = TextEditingController().obs;
  final confirmPasswordTextController = TextEditingController().obs;

  final formKey = GlobalKey<FormState>().obs;

  // RxString gender = "".obs;
  Rx<DateTime?> dob = Rx<DateTime?>(null);

  RxInt gender = (-1).obs; // default = not selected
  RxInt currentStep = 0.obs;

  RxString dobString = "".obs;

  // API-driven dropdowns
  RxList<dynamic> countryList = <dynamic>[].obs;
  RxList<dynamic> stateList = <dynamic>[].obs;
  RxList<dynamic> cityList = <dynamic>[].obs;

  RxString selectedCountry = "".obs;
  RxString selectedState = "".obs;
  RxString selectedCity = "".obs;

  RxString selectedCountryId = "".obs;
  RxString selectedCountryName = "".obs;
  Map<String, String> countryNameToId = {};

  RxString selectedStateId = "".obs;
  RxString selectedStateName = "".obs;
  Map<String, String> stateNameToId = {};

  RxString selectedCityId = "".obs;
  RxString selectedCityName = "".obs;
  Map<String, String> cityNameToId = {};

  // Loading flags
  RxBool isStateLoading = false.obs;
  RxBool isCityLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool hasMinLength = false.obs;
  RxBool isConfirmPasswordValid = false.obs;
  RxBool isSubmitButtonClicked = false.obs;

  late BuildContext dialogContext;


  // UI list of string names
  RxList<String> countryNames = <String>[].obs;
  RxList<String> stateNames = <String>[].obs;
  RxList<String> cityNames = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.text =
        '${homeController.countryCode.value} ${homeController.userPhoneNumber.value}';
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    await Future.delayed(Duration(seconds: 1));
    await apiController.fetchCountryList();
    if (apiController.countryListData.isNotEmpty) {
      countryNames.clear();
      countryNameToId.clear();
      for (var item in apiController.countryListData) {
        final name = item.name ?? "";
        final id = item.id.toString();

        countryNames.add(name);
        countryNameToId[name] = id;
      }
    }
  }

  Future<void> fetchStates(String countryId) async {
    stateList.clear();
    cityList.clear();
    selectedState.value = "";
    selectedCity.value = "";
    isStateLoading.value = true;

    await apiController.fetchStateListByCountry(countryId);

    if (apiController.stateListData.isNotEmpty) {
      stateNames.clear();
      stateNameToId.clear();
      for (var item in apiController.stateListData) {
        final name = item.name ?? "";
        final id = item.id.toString();

        stateNames.add(name);
        stateNameToId[name] = id;
      }
    }

    isStateLoading.value = false;
  }

  Future<void> fetchCities(String stateId) async {
    cityList.clear();
    selectedCity.value = "";
    isCityLoading.value = true;

    await apiController.fetchCityListByState(stateId);
    if (apiController.cityListData.isNotEmpty) {
      cityNames.clear();
      cityNameToId.clear();
      for (var item in apiController.cityListData) {
        final name = item.name ?? "";
        final id = item.id.toString();

        cityNames.add(name);
        cityNameToId[name] = id;
      }
    }
    isCityLoading.value = false;
  }

  String get formattedDob {
    if (dob.value == null) {
      return DynamicAppLocalizations.of(Get.context!).t("select_date_of_birth");
    }
    return DateFormat("dd MMM yyyy").format(dob.value!);
  }

  Future<void> pickDob(context) async {
    final now = DateTime.now();

    final initial = dob.value ?? now;
    final first = DateTime(now.year - 100); // maximum 100-year-old DOB
    final last = DateTime(
      now.year,
      now.month,
      now.day,
    ); // TODAY ONLY — no future date
    final sel = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return PopScope(
          canPop: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.white,
                onSurface: AppColors.primaryColor,
              ),
              datePickerTheme: const DatePickerThemeData(
                backgroundColor: AppColors.white,
                headerBackgroundColor: AppColors.primaryColor,
                headerForegroundColor: AppColors.white,
                dividerColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (sel != null) {
      dob.value = sel;
      dobString.value = formatDob(sel);
      update();
    }
  }

  String formatDob(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  String convertDobToUtc(String dobString) {
    // dobString = "18/11/2025"
    final DateTime localDate = DateFormat(
      "dd/MM/yyyy",
    ).parse(dobString); // local date

    // Convert to UTC at midnight
    final DateTime utcDate = DateTime.utc(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    return utcDate.toIso8601String(); // "2025-11-18T00:00:00.000Z"
  }

  registerNewUser() async {
    String utcDob = convertDobToUtc(dobString.value);
    isLoading.value = true;
    dynamic apiResponse = await apiController.addUserProfile(
      name: nameController.value.text,
      email: emailTextController.value.text,
      phoneNumber: homeController.userPhoneNumber.value,
      countryCode: homeController.countryCode.value,
      countryId: int.parse(selectedCountryId.value),
      stateId: int.parse(selectedStateId.value),
      cityId: int.parse(selectedCityId.value),
      gender: gender.value,
      languageId: homeController.selectedLanguageId.value,
      birthDate: utcDob.toString(),
      password: confirmPasswordTextController.value.text,
    );
    if (apiResponse != null) {
      if (apiResponse['success'] == true) {
        // languageListData = apiResponse['languageList'];
        homeController.isUserExists.value = true;
        await LocalDB().setIsUserExists(true);
        await LocalDB().reloadSharedPref();
        await homeController.reload();

        await apiController.fetchVersionsList(
          isUserLoggedIn: true,
          jwtToken: homeController.jwtToken.value,
        );

        CustomAlertWidget().infoAlertDialog(
          displayText: apiResponse['message'],
          buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
          statusType: true,
        );
        
        homeController.selectedIndex.value = 0;
        homeController.update();

        Get.put(DashboardViewController());
        Get.offAllNamed(Routes.home);
        isLoading.value = false;

      } else {
        isLoading.value = false;
      }
    }
  }

  String get genderText {
    switch (gender.value) {
      case 0:
        return 'Male';
      case 1:
        return 'Female';
      case 2:
        return 'Other';
      default:
        return '';
    }
  }

  /// set by int
  void setGenderInt(int v) => gender.value = v;

  /// set by text (optional)
  void setGenderText(String txt) {
    switch (txt.toLowerCase()) {
      case 'male':
        gender.value = 0;
        break;
      case 'female':
        gender.value = 1;
        break;
      case 'other':
        gender.value = 2;
        break;
      default:
        gender.value = -1;
    }
  }

  /// validation helper
  bool validateSelected() => gender.value != -1;

  /// clear
  void clear() => gender.value = -1;

  validatePassword(String value) {
    update();
  }
}

extension DropdownMapper on UserPopupController {
  // COUNTRY
  String getCountryNameFromId(String id) {
    final obj = apiController.countryListData.firstWhereOrNull(
      (e) => e.id.toString() == id,
    );
    return obj?.name ?? "";
  }

  String getCountryIdFromName(String name) {
    final obj = apiController.countryListData.firstWhereOrNull(
      (e) => e.name == name,
    );
    return obj?.id?.toString() ?? "";
  }

  // STATE
  String getStateNameFromId(String id) {
    final obj = apiController.stateListData.firstWhereOrNull(
      (e) => e.id.toString() == id,
    );
    return obj?.name ?? "";
  }

  String getStateIdFromName(String name) {
    final obj = apiController.stateListData.firstWhereOrNull(
      (e) => e.name == name,
    );
    return obj?.id?.toString() ?? "";
  }

  // CITY
  String getCityNameFromId(String id) {
    final obj = apiController.cityListData.firstWhereOrNull(
      (e) => e.id.toString() == id,
    );
    return obj?.name ?? "";
  }

  String getCityIdFromName(String name) {
    final obj = apiController.cityListData.firstWhereOrNull(
      (e) => e.name == name,
    );
    return obj?.id?.toString() ?? "";
  }

  void goToNextStep() {
    currentStep.value = 1;
  }

  void goTopreviousStep() {
    currentStep.value = 0;
  }

  void validateNewPassword(String value) {
    hasMinLength.value = value.length >= 8;
    validateConfirmPassword(confirmPasswordTextController.value.text, value);
  }

  void validateConfirmPassword(String confirmValue, String newValue) {
    isConfirmPasswordValid.value = confirmValue == newValue;
  }

  bool checkForm() {
    return hasMinLength.value && isConfirmPasswordValid.value;
  }
}
