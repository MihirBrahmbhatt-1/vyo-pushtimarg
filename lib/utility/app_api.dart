

import 'package:get/get.dart';

import '../const/constant.dart';
import '../controller/home_controller.dart';

class GetApiEnv {
  getApiEnvironment() {
    HomeController homeController = Get.put(HomeController());
    bool isAccountForReview = homeController.isAccountReview.value;
    if (isAccountForReview) {
      return 'MProduction';
    } else {
      if (appIsLive) {
        return 'prod';
      } else {
        return 'dev';
      }
      // return 'prod'; // dev / uat / prod
    }
  }
}

class AppApi {
  // late String baseUrl =
  //     "https://u4qgts939l.execute-api.ap-south-1.amazonaws.com/${GetApiEnv().getApiEnvironment()}/api/v1/";
  late String baseUrl =
      "https://p26blnl8d0.execute-api.ap-south-1.amazonaws.com/${GetApiEnv().getApiEnvironment()}/api/v1/";

      late String languageListApiUrl = '${baseUrl}common/language';
      late String languageLabelApiUrl = '${baseUrl}common/labels';
      late String sendOtpApiUrl = '${baseUrl}auth/sendotp';
      late String countryListApiUrl = '${baseUrl}common/countries';
      late String stateListApiUrl = '${baseUrl}common/statesbycountry';
      late String cityListApiUrl = '${baseUrl}common/citybystate';
      late String commonVersionsApiUrl = '${baseUrl}common/versions';
      late String loginApiUrl = '${baseUrl}auth/login';
      late String changePasswordApiUrl = '${baseUrl}common/changepassword';
      late String forgotPasswordApiUrl = '${baseUrl}auth/forgotpassword';
      late String resetPasswordApiUrl = '${baseUrl}auth/resetpassword';
      late String userHabitListApiUrl = '${baseUrl}common/contact_details';
      late String dailySevaPranalikaApiUrl = '${baseUrl}common/sevapranalika';
      late String userProfileApiUrl = '${baseUrl}users/profile';
      late String categoryListApiUrl = '${baseUrl}media/categories';
      late String mediaListApiUrl = '${baseUrl}media/subcategory';
      late String surveyQuestionListApiUrl = '${baseUrl}survey/surveydetail';
      late String userSurveyCompleteApiUrl = '${baseUrl}survey/surveycomplete';
      late String dashboardHtmlSectionApiUrl = '${baseUrl}dashboard/sections';
      late String dashboardImageSlidersApiUrl = '${baseUrl}dashboard/sliders';
      late String validateOtpApiUrl = '${baseUrl}auth/validateotp';
      late String deviceInfoApiUrl = '${baseUrl}common/deviceinfo';
      late String queryTypeListApiUrl = '${baseUrl}common/querytypelist';
      late String submitContactUsApiUrl = '${baseUrl}common/contactus';
      late String logoutApiUrl = '${baseUrl}auth/logout';
      late String pushtiPracticesApiUrl = '${baseUrl}practice/pushtipractices';
      late String appVersionApiUrl = '${baseUrl}common/app-version';
      late String changeLanguageApiUrl = '${baseUrl}users/changelanguage';
      late String deleteUserApiUrl = '${baseUrl}users/delete-me';
      late String countryCodesApiUrl = '${baseUrl}common/country-codes';
}

