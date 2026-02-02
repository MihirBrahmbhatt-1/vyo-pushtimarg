import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../utility/api_service_interceptor.dart';
import '../../widget/custom_alert_widget.dart';

class UserDetailsViewController extends GetxController
    with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final nameController = TextEditingController().obs;
  final emailTextController = TextEditingController().obs;
  final phoneController = TextEditingController();

  final formKey = GlobalKey<FormState>().obs;

  RxInt gender = (-1).obs;

  RxString selectedCountryId = "".obs;
  RxString selectedCountryName = "".obs;

  RxString selectedStateId = "".obs;
  RxString selectedStateName = "".obs;

  RxString selectedCityId = "".obs;
  RxString selectedCityName = "".obs;
  RxString dobString = "".obs;
  Rx<DateTime?> dob = Rx<DateTime?>(null);
  RxBool isStateLoading = false.obs;
  RxBool isCityLoading = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFetchingData = true.obs;

  RxBool isCountryLocked = false.obs;
  RxBool isStateLocked = false.obs;
  RxBool isCityLocked = false.obs;
  RxBool isGenderLocked = false.obs;
  RxBool isDobLocked = false.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    fetchUserDetails();
    super.onInit();
  }

  Future<void> fetchUserDetails() async {
    isFetchingData.value = true;
    bool isSuccess = await apiController.getUserProfileByPhoneNumber(
      phoneNumber: homeController.userPhoneNumber.value,
      jwtToken: homeController.jwtToken.value,
    );
    if (isSuccess) {
      if (homeController.isUserExists.value &&
          homeController.isUserProfileCompleted.value) {
        nameController.value.text = homeController.userNameString.value;
        emailTextController.value.text = homeController.userEmailString.value;
        phoneController.text =
            '${homeController.countryCode.value} ${homeController.userPhoneNumber.value}';
        selectedCountryId.value = homeController.userCountryId.value;
        selectedStateId.value = homeController.userStateId.value;
        selectedCityId.value = homeController.userCityId.value;
        String selectedGenderId = homeController.userGenderId.value;

        if (selectedGenderId.isNotEmpty) {
          gender.value = int.parse(selectedGenderId);
        }

        if (homeController.userDOB.value.isNotEmpty) {
          dob.value = DateTime.parse(homeController.userDOB.value);
          isDobLocked.value = true;
        }

        isCountryLocked.value = selectedCountryId.value.isNotEmpty;
        isStateLocked.value = selectedStateId.value.isNotEmpty;
        isCityLocked.value = selectedCityId.value.isNotEmpty;
        isGenderLocked.value = gender.value != -1;

        update();
      }
    }
    isFetchingData.value = false;
  }

  void setGenderInt(int value) {
    gender.value = value;
    update();
  }

  Future<void> pickDob(context) async {
    final now = DateTime.now();

    final initial = dob.value ?? now;
    final first = DateTime(now.year - 100);
    final last = DateTime(now.year - 1, now.month, now.day);
    final sel = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: last,
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
    final DateTime localDate = DateFormat("dd/MM/yyyy").parse(dobString);

    final DateTime utcDate = DateTime.utc(
      localDate.year,
      localDate.month,
      localDate.day,
    );

    return utcDate.toIso8601String();
  }

  String get formattedDob {
    if (dob.value == null) {
      return DynamicAppLocalizations.of(Get.context!).t("select_date_of_birth");
    }
    return DateFormat("dd MMM yyyy").format(dob.value!);
  }

  updateUserDetails() async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        homeController.isDisplayInternetConnection.value = false;

        isFetchingData.value = true;
        dynamic apiResponse = await apiController.updateUserProfile(
          userId: homeController.customerIdString.value,
          name: nameController.value.text,
          email: emailTextController.value.text,
          phoneNumber: homeController.userPhoneNumber.value,
          countryCode: homeController.countryCode.value,
          countryId: int.parse(selectedCountryId.value),
          stateId: int.parse(selectedStateId.value),
          cityId: int.parse(selectedCityId.value),
          gender: gender.value,
          languageId: homeController.selectedLanguageId.value,
          birthDate: homeController.userDOB.toString(),
          jwtToken: homeController.jwtToken.value,
        );
        if (apiResponse != null) {
          if (apiResponse['success'] == true) {
            CustomAlertWidget().infoAlertDialog(
              displayText: apiResponse['message'],
              buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
              statusType: true,
            );
            isFetchingData.value = false;
          } else {
            isFetchingData.value = false;
          }
        }
      } else {
        homeController.isDisplayInternetConnection.value = true;
      }
    } catch (e) {
      // CustomAlertWidget().simpleAlertDialog(title: DynamicAppLocalizations.of(Get.context!).t("no_internet_connection"), description: '',
      //     canPop: false,
      //     buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
      //     onButtonTap: () {
      //       Get.back();
      //     });
    }
  }
}
