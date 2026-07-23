import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../navigation/pages.dart';
import '../../utility/api_service_interceptor.dart';
import '../../widget/countries.dart';

class ContactUsViewController extends GetxController
    with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final nameController = TextEditingController().obs;
  final contactUsFormKey = GlobalKey<FormState>().obs;
  final phoneNumberTextController = TextEditingController().obs;
  final emailTextController = TextEditingController().obs;
  final queryDescriptionTextController = TextEditingController().obs;


  RxBool showPhoneError = false.obs;
  RxBool isValidePhoneNumber = false.obs;
  RxBool isLoadingQueryList = false.obs;
  RxBool isLoading = false.obs;
  RxBool isFormSubmitted = false.obs;

  RxString phoneErrorMessage = "".obs;
  RxString selectedQueryName = "".obs;

  RxString selectedQueryId = "".obs;


  RxList<String> queryNames = <String>[].obs;

  Map<String, String> queryNameToId = {};



  final Rx<Country> selectedCountry = const Country(
    name: "Loading...",
    flag: "⏳",
    code: "",
    dialCode: "",
    minLength: 10,
    maxLength: 10,
  ).obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();

    fetchQueryType();

    ever(selectedCountry, (c) {
      talker.info("COUNTRY CHANGED → ${c.name} (+${c.dialCode})");
      talker.info("FULL PHONE → ${getFullPhone()}");
    });
    
    ever(apiController.countryCodeList, (list) {
      if (list.isNotEmpty && selectedCountry.value.code.isEmpty) {
        selectedCountry.value = list.firstWhere(
          (c) => c.code == "IN",
          orElse: () => list.first,
        );
      }
    });
    if (apiController.countryCodeList.isNotEmpty && selectedCountry.value.code.isEmpty) {
      selectedCountry.value = apiController.countryCodeList.firstWhere(
        (c) => c.code == "IN",
        orElse: () => apiController.countryCodeList.first,
      );
    }

    /// Listen to phone number change
    phoneNumberTextController.value.addListener(() {
      talker.info("PHONE UPDATED → ${phoneNumberTextController.value.text}");
      talker.info("FULL PHONE → ${getFullPhone()}");
    });
  checkForDeviceInternetConnectivity();
  }

  checkForDeviceInternetConnectivity() async {
    if (await ApiServiceInterceptor.checkInternet()) {
      homeController.isDisplayInternetConnection.value = false;
    } else {
      homeController.isDisplayInternetConnection.value = true;
    }
  }
  bool validatePhone() {
    if (phoneNumberTextController.value.text.isEmpty) {
      phoneErrorMessage.value = DynamicAppLocalizations.of(Get.context!)
          .t("phone_number_is_required");
      showPhoneError.value = true;
      return false;
    }
    if (!isValidePhoneNumber.value) {
      showPhoneError.value = true;
      return false;
    }
    showPhoneError.value = false;
    return true;
  }

  /// Get final combined number
  String getFullPhone() {
    return "+${selectedCountry.value.dialCode}${phoneNumberTextController.value.text}";
  }

  fetchQueryType() async {
    isLoadingQueryList.value = true;
    await apiController.queryTypeListApi(
      languageId: homeController.selectedLanguageId.value,
    );

    if (apiController.queryTypeListResponseModel.isNotEmpty) {
      apiController.queryTypeListResponseModel.sort((a, b) => a.id!.compareTo(b.id!));
    for (var item in apiController.queryTypeListResponseModel) {
        final name = item.name ?? "";
        final id = item.id.toString();

        queryNames.add(name);
        queryNameToId[name] = id;
      }
    }
    isLoadingQueryList.value = false;
  }

  submitContactUs() async {
    try {
      isLoading.value = true;
      bool result = await apiController.submitContactUsQuery(
        name: nameController.value.text,
        email: emailTextController.value.text,
        countryCode: selectedCountry.value.dialCode.toString(),
        mobileNumber: phoneNumberTextController.value.text,
        queryDescription: queryDescriptionTextController.value.text,
        queryType: selectedQueryId.value.toString(),
        queryName: selectedQueryName.value.toString(),
      );
      isLoading.value = false;
      if (result) {
        Get.offAllNamed(Routes.signin);
      }
    } catch (e) {
      talker.error('Error in submit contact us func: ${e.toString()}');
    }
  }
}
