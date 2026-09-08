import 'package:get/get.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../model/language_model.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/common_functions.dart';
import '../../widget/common_widget.dart';
import '../../widget/custom_alert_widget.dart';
import '../home/home_view.dart';

class PreferredLanguageSettingsViewController extends GetxController {
  late ApiController apiController;
  late HomeController homeController;

  RxList<LanguageModel> languageListData = <LanguageModel>[].obs;
  RxBool isLoading = false.obs;
  RxString selectedLanguageId = ''.obs;

  RxString displayInternetConnection = "".obs;


  @override
  void onInit() {
    super.onInit();
    apiController = Get.find<ApiController>();
    homeController = Get.find<HomeController>();
    selectedLanguageId.value = homeController.selectedLanguageId.value;
    fetchLanguage();
    fetchInternetStatus();
  }

  showMessage(String message) {
    displayInternetConnection.value = message.toString();
  }

  fetchInternetStatus() async {
    await checkInternetStatus(
      checkInternet: ApiServiceInterceptor.checkInternetFunction,
      showMessage: showMessage,
      onConnected: () async {
        homeController.isDisplayInternetConnection.value = false;
        // isLoading.value = true;
        fetchLanguage();
      },
      onNoConnection: () {
        // isLoading.value = false;
        homeController.isDisplayInternetConnection.value = true;
      },
    );
  }

  Future<void> fetchLanguage() async {
    isLoading.value = true;
    try {
      dynamic apiResponse = await apiController.fetchLanguageList();
      if (apiResponse['languageList'] != null) {
        if (apiResponse['success'] == true) {
          languageListData = apiResponse['languageList'];
        }
        isLoading.value = false;
      }
    } catch (e) {
      showCustomSnackBar('Error', 'Failed to fetch languages', false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<dynamic> updateLanguage(String languageId) async {
    try {
      isLoading.value = true;
      dynamic apiResponse = await apiController.changeLanguage(
        userId: homeController.customerIdString.value,
        languageId: languageId,
      );

      if (apiResponse['responseMessage'] != '') {
        if (apiResponse['success'] == true) {
          selectedLanguageId.value = languageId;
          homeController.selectedLanguageId.value = languageId;
          isLoading.value = false;
          CustomAlertWidget().infoAlertDialog(
              displayText: apiResponse['responseMessage'].toString(),
              buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
              statusType: true,
              onButtonTap: () {
                Get.offAll(() => const HomeView());
                homeController.selectedIndex.value = 3;
              });
          return true;
        }
        isLoading.value = false;
      } else {
        isLoading.value = false;
        return false;
      }
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }
}
