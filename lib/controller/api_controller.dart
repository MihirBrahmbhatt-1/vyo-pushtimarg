import 'dart:convert';

import 'package:get/get.dart';

import '../const/logger.dart';
import '../localization/dynamic_app_localizations.dart';
import '../model/category_list_response_model.dart';
import '../model/city_list_response_model.dart';
import '../model/country_list_response_model.dart';
import '../model/daily_seva_pranalika_response_model.dart';
import '../model/dashboard_html_content_response_model.dart';
import '../model/dashboard_image_slider_response_model.dart';
import '../model/dynamic_label.dart';
import '../model/language_model.dart';
import '../model/login_response_model.dart';
import '../model/media_list_response_model.dart';
import '../model/send_otp_response_model.dart';
import '../model/state_list_response_model.dart';
import '../model/survey_question_list_response_model.dart';
import '../model/user_habit_list_response_model.dart';
import '../model/user_profile_details_response_model.dart';
import '../model/version_list_response_model.dart';
import '../navigation/pages.dart';
import '../utility/api_base_response.dart';
import '../utility/api_service_interceptor.dart';
import '../utility/app_api.dart';
import '../utility/local_db.dart';
import '../widget/common_widget.dart';
import 'dynamic_locale_controller.dart';
import 'home_controller.dart';

class ApiController extends GetxController {
  HomeController homeController = Get.put(HomeController());

  final languageModel = Rxn<LanguageModel>();
  final sendOtpResponseModel = Rxn<SendOtpResponseModel>();
  final forgotPasswordsendOtpResponseModel =
      Rxn<ForgotPasswordSendOtpResponseModel>();
  final loginResponseModel = Rxn<LoginResponseModel>();
  final userDetailsResponseModel = Rxn<UserProfileDetailsResponseModel>();
  final dailySevaPranalikaResponseModel =
      Rxn<DailySevaPranalikaResponseModel>();
  RxList<LanguageModel> languageListData = <LanguageModel>[].obs;
  RxList<CountryListData> countryListData = <CountryListData>[].obs;
  RxList<StateListData> stateListData = <StateListData>[].obs;
  RxList<CityListData> cityListData = <CityListData>[].obs;
  RxList<CategoryListResponseModel> categoryListData =
      <CategoryListResponseModel>[].obs;
  RxList<MediaModel> mediaListData = <MediaModel>[].obs;
  RxList<VersionListResponseModel> versionListData =
      <VersionListResponseModel>[].obs;
  RxList<SurveyQuestionListResponseModel> surveyQuestionListResponseModel =
      <SurveyQuestionListResponseModel>[].obs;
  RxList<DashboardHtmlContentResponseModel> dashboardHtmlResponseModel =
      <DashboardHtmlContentResponseModel>[].obs;
  RxList<DashboardImageSliderResponseModel> dashboardImageSliderResponseModel =
      <DashboardImageSliderResponseModel>[].obs;
  RxList<UserHabitListResponseModel> userHabitListResponseModel =
      <UserHabitListResponseModel>[].obs;

  Future<dynamic> sendPhoneNumberOtp(
    String phoneNumber,
    String countryCode,
  ) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, String> body = <String, String>{};
        body['mobile_number'] = phoneNumber.toString();
        body['country_code'] = countryCode.toString();

        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.postDecryptLambdaCall(
          url: AppApi().sendOtpApiUrl,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            sendOtpResponseModel.value = SendOtpResponseModel.fromJson(
              apiBaseResponse.data,
            );
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in sendPhoneNumberOTP API: $e');
    }
  }

  fetchVersionsList({
    required bool isUserLoggedIn,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        Map<String, String> header;
        header = {'authorization': ""};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().commonVersionsApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209 &&
              apiBaseResponse.data != null) {
            Map<String, dynamic> customObj = {"Data": apiBaseResponse.data};
            var convertedObjString = jsonEncode(customObj);
            versionListData.value =
                (json.decode(convertedObjString)["Data"] as List)
                    .map((data) => VersionListResponseModel.fromJson(data))
                    .toList();
            if (versionListData.isEmpty) return;

            await _checkForLabelVersionUpdate();

            if (isUserLoggedIn) {
              talker.info(
                'User is logged in. Checking dashboard and slider versions.',
              );
              await _checkForDashboardVersionUpdate();
              await _checkForDashboardSliderVersionUpdate();
            } else {
              talker.info(
                'User is NOT logged in. Skipping dashboard and slider version checks.',
              );
            }
          } else {
            versionListData.value = [];
          }
        } else {
          versionListData.value = [];
        }
      }
    } catch (e) {
      talker.error('Exception in fetchVersionList API: $e');
    }
  }

  fetchLanguageList() async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        Map<String, String> header;
        header = {'authorization': ""};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().languageListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            Map<String, dynamic> customObj = {"Data": apiBaseResponse.data};
            var convertedObjString = jsonEncode(customObj);
            languageListData.value =
                (json.decode(convertedObjString)["Data"] as List)
                    .map((data) => LanguageModel.fromJson(data))
                    .toList();
            dynamic result = {
              "langualgeList": languageListData,
              "success": true,
            };
            return result;
          } else {
            dynamic result = {"langualgeList": [], "success": false};
            return result;
          }
        } else {
          dynamic result = {"langualgeList": [], "success": false};
          return result;
        }
      } else {
        dynamic result = {"langualgeList": [], "success": false};
        return result;
      }
    } catch (e) {
      dynamic result = {"langualgeList": [], "success": false};
      talker.error('Exception in fetchLanguageList API: $e');
      return result;
    }
  }

  getLanguageLabels(String languageId) async {
    try {
      final cachedJson = await LocalDB().getLanguageLabelsCache();
      if (cachedJson != null && cachedJson.isNotEmpty) {
        final List<dynamic> cachedList = json.decode(cachedJson);
        final List<DynamicLabel> cachedLabels = cachedList
            .map<DynamicLabel>((e) => DynamicLabel.fromJson(e))
            .toList();

        final dynamicCtrl = Get.put(DynamicLocaleController());

        dynamicCtrl.setLabels(cachedLabels, isFromCache: true);
      }
    } catch (e) {
      talker.error('Exception loading language labels from cache: $e');
    }
    try {
      var request = <String, String>{};
      request["language_id"] = languageId;

      Map<String, String> header = {'authorization': ""};

      var response = await ApiServiceInterceptor.getDecryptLambdaCall(
        url: AppApi().languageLabelApiUrl,
        request: request,
        headers: header,
      );

      if (homeController.statusCode.value == 200) {
        final convertedResponse = json.decode(response);

        ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
          convertedResponse,
        );

        if (apiBaseResponse.statusCode == 209) {
          final List<DynamicLabel> list = apiBaseResponse.data
              .map<DynamicLabel>((e) => DynamicLabel.fromJson(e))
              .toList();
          RxString versionString = ''.obs;
          for (var item in list) {
            if (item.key == "@@labels_version@@") {
              versionString.value = item.value;
              break;
            }
          }

          final labelsJsonToCache = json.encode(apiBaseResponse.data);
          await LocalDB().setLanguageLabelsCache(labelsJsonToCache);

          final dynamicCtrl = Get.put(DynamicLocaleController());
          dynamicCtrl.setLabels(list);
          talker.debug('----Label Language list updated------');
          await LocalDB().setLabelLanguageVersion(versionString.value);
        }
      }
    } catch (e) {
      talker.error('Exception in getLanguageLabels API: $e');
    }
  }

  fetchCountryList() async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().countryListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            countryListData.value = (apiBaseResponse.data as List)
                .map((data) => CountryListData.fromJson(data))
                .toList();
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchCountryList API: $e');
    }
  }

  fetchStateListByCountry(String countryId) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["country_id"] = countryId;
        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().stateListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            stateListData.value = (apiBaseResponse.data as List)
                .map((data) => StateListData.fromJson(data))
                .toList();
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchStateListByCountry API: $e');
    }
  }

  fetchCityListByState(String stateId) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["state_id"] = stateId;
        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().cityListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            cityListData.value = (apiBaseResponse.data as List)
                .map((data) => CityListData.fromJson(data))
                .toList();
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchCityListByState API: $e');
    }
  }

  Future<dynamic> addUserProfile({
    required name,
    required email,
    required phoneNumber,
    required countryCode,
    required languageId,
    required countryId,
    required stateId,
    required cityId,
    required gender,
    required birthDate,
    required password,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, dynamic> body = <String, dynamic>{};
        body['name'] = name.toString();
        body['mobile_no'] = phoneNumber.toString();
        body['mobile_country_code'] = countryCode.toString();
        body['email'] = email.toString();
        body['password'] = password.toString();
        body['gender'] = gender;
        body['birthdate'] = birthDate.toString();
        body['city_id'] = cityId;
        body['country_id'] = countryId;
        body['state_id'] = stateId;
        body['preferred_language_id'] = languageId.toString();
        body['is_survey_completed'] = false;
        body['is_profile_completed'] = true;
        body['created_by'] = null;
        body['user_type'] = 1; // Admin = 0 ; User = 1; Data Entry = 3

        Map<String, dynamic> header = {};
        dynamic response = await ApiServiceInterceptor.postDecryptLambdaCall(
          url: AppApi().userProfileApiUrl,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            dynamic result = {
              "message": apiBaseResponse.message.toString(),
              "success": true,
            };
            if (apiBaseResponse.data != null) {
              userDetailsResponseModel.value =
                  UserProfileDetailsResponseModel.fromJson(
                    apiBaseResponse.data,
                  );
              homeController.jwtToken.value = userDetailsResponseModel
                  .value!
                  .jwtToken
                  .toString();

              await LocalDB().setJwtToken(
                userDetailsResponseModel.value!.jwtToken.toString(),
              );
              await LocalDB().reloadSharedPref();
              await homeController.reload();
              talker.debug('---------- Executed Add User Api Call ----------');
              talker.debug(
                '---------- JWT Token ---------- : ${homeController.jwtToken.toString()}',
              );
              talker.debug('---------- Executed Add User Api Call ----------');
            }

            await getUserProfileByPhoneNumber(
              phoneNumber: phoneNumber,
              jwtToken: userDetailsResponseModel
                  .value!
                  .jwtToken.toString(),
            );
            return result;
          } else {
            dynamic result = {
              "message": apiBaseResponse.message.toString(),
              "success": false,
            };
            return result;
          }
        } else {
          dynamic result = {"message": '', "success": false};
          return result;
        }
      }
    } catch (e) {
      talker.error('Exception in addUserProfile API: $e');
    }
  }

  Future<dynamic> updateUserProfile({
    required userId,
    required name,
    required email,
    required phoneNumber,
    required countryCode,
    required languageId,
    required countryId,
    required stateId,
    required cityId,
    required gender,
    required birthDate,
    required jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["user_id"] = userId.toString();

        Map<String, dynamic> body = <String, dynamic>{};
        body['id'] = userId.toString();
        body['name'] = name.toString();
        body['mobile_no'] = phoneNumber.toString();
        body['mobile_country_code'] = countryCode.toString();
        body['email'] = email.toString();
        body['gender'] = gender;
        body['birthdate'] = birthDate.toString();
        body['city_id'] = cityId;
        body['country_id'] = countryId;
        body['state_id'] = stateId;
        body['preferred_language_id'] = languageId.toString();
        body['modified_by'] = userId.toString();

        Map<String, dynamic> header = {'authorization': jwtToken};
        dynamic response = await ApiServiceInterceptor.putDecryptLamdaCall(
          url: AppApi().userProfileApiUrl,
          request: request,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            dynamic result = {
              "message": apiBaseResponse.message.toString(),
              "success": true,
            };
            await getUserProfileByPhoneNumber(
              phoneNumber: phoneNumber,
              jwtToken: homeController.jwtToken.value,
            );
            return result;
          } else {
            dynamic result = {
              "message": apiBaseResponse.message.toString(),
              "success": false,
            };
            return result;
          }
        } else {
          dynamic result = {"message": '', "success": false};
          return result;
        }
      }
    } catch (e) {
      talker.error('Exception in updateUserProfile API: $e');
    }
  }

  getUserProfileByPhoneNumber({
    required String phoneNumber,
    required String jwtToken,
  }) async {
    try {
      var request = <String, String>{};
      request["mobile_no"] = phoneNumber;

      Map<String, String> header = {'authorization': jwtToken};

      var response = await ApiServiceInterceptor.getDecryptLambdaCall(
        url: AppApi().userProfileApiUrl,
        request: request,
        headers: header,
      );

      if (homeController.statusCode.value == 200) {
        final convertedResponse = json.decode(response);

        ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
          convertedResponse,
        );

        if (apiBaseResponse.statusCode == 209) {
          if (apiBaseResponse.data != null) {
            userDetailsResponseModel.value =
                UserProfileDetailsResponseModel.fromJson(apiBaseResponse.data);

            homeController.customerIdString.value = userDetailsResponseModel
                .value!
                .id
                .toString();

            homeController.isUserProfileCompleted.value =
                userDetailsResponseModel.value!.isProfileCompleted!;

            homeController.userNameString.value = userDetailsResponseModel
                .value!
                .name
                .toString();

            homeController.userEmailString.value =
                userDetailsResponseModel.value!.email == null
                ? ''
                : userDetailsResponseModel.value!.email.toString();
            homeController.userPhoneNumber.value = userDetailsResponseModel
                .value!
                .mobileNo
                .toString();
            homeController.countryCode.value = userDetailsResponseModel
                .value!
                .mobileCountryCode
                .toString();
            homeController.selectedLanguageId.value = userDetailsResponseModel
                .value!
                .preferredLanguageId
                .toString();
            homeController.userCityId.value = userDetailsResponseModel
                .value!
                .cityId
                .toString();
            homeController.userCountryId.value = userDetailsResponseModel
                .value!
                .countryId
                .toString();
            homeController.userStateId.value = userDetailsResponseModel
                .value!
                .stateId
                .toString();
            homeController.userGenderId.value =
                userDetailsResponseModel.value!.gender == null
                ? ''
                : userDetailsResponseModel.value!.gender.toString();
            homeController.userDOB.value =
                userDetailsResponseModel.value!.birthdate == null
                ? ''
                : userDetailsResponseModel.value!.birthdate.toString();

            homeController.userCountryName.value = userDetailsResponseModel
                .value!
                .countryName
                .toString();
            homeController.userStateName.value = userDetailsResponseModel
                .value!
                .stateName
                .toString();
            homeController.userCityName.value = userDetailsResponseModel
                .value!
                .cityName
                .toString();
            homeController.isUserSurveyCompleted.value = userDetailsResponseModel
                .value!
                .isSurveyCompleted!;

            await LocalDB().setCustomerId(userDetailsResponseModel.value!.id!);
            await LocalDB().setIsUserProfileCompleted(
              userDetailsResponseModel.value!.isProfileCompleted!,
            );
            await LocalDB().setIsUserSurveyCompleted(
              userDetailsResponseModel.value!.isSurveyCompleted!,
            );
            await LocalDB().setUserFullName(
              userDetailsResponseModel.value!.name.toString(),
            );
            await LocalDB().setUserPhoneNumber(
              userDetailsResponseModel.value!.mobileNo.toString(),
            );
            await LocalDB().setCountryCode(
              userDetailsResponseModel.value!.mobileCountryCode.toString(),
            );
            await LocalDB().setLanguageId(
              userDetailsResponseModel.value!.preferredLanguageId.toString(),
            );
            await LocalDB().setUserCountryId(
              userDetailsResponseModel.value!.countryId.toString(),
            );
            await LocalDB().setUserCountryName(
              userDetailsResponseModel.value!.countryName.toString(),
            );
            await LocalDB().setUserStateId(
              userDetailsResponseModel.value!.stateId.toString(),
            );
            await LocalDB().setUserStateName(
              userDetailsResponseModel.value!.stateName.toString(),
            );
            await LocalDB().setUserCityId(
              userDetailsResponseModel.value!.cityId.toString(),
            );
            await LocalDB().setUserCityName(
              userDetailsResponseModel.value!.cityName.toString(),
            );
            await LocalDB().setUserGenderId(
              userDetailsResponseModel.value!.gender == null
                  ? ''
                  : userDetailsResponseModel.value!.gender.toString(),
            );
            await LocalDB().setUserDOB(
              userDetailsResponseModel.value!.birthdate == null
                  ? ''
                  : userDetailsResponseModel.value!.birthdate.toString(),
            );
            await LocalDB().setUserEmail(
              userDetailsResponseModel.value!.email == null
                  ? ''
                  : userDetailsResponseModel.value!.email.toString(),
            );
            await LocalDB().reloadSharedPref();
            await homeController.reload();
            talker.debug(
              '---------- Executed UserDetails Get API Call ----------',
            );
            return true;
          } else {
            return false;
          }
        }
      } else if (homeController.statusCode.value == 401 ||
          homeController.statusCode.value == 403) {
        bool isSuccess = await userLoginApi(
          phoneNumber: homeController.userPhoneNumber.value,
          password: homeController.passwordString.value,
        );
        if (!isSuccess) {
          await LocalDB().setIsLoggedIn(false);
          await LocalDB().setIsUserExists(false);
          await LocalDB().setIsUserProfileCompleted(false);
          await LocalDB().setJwtToken('');
          await LocalDB().setDashboardVersion('');
          await LocalDB().setDashboardSliderVersion('');
          await LocalDB().setDashboardHtmlCache('');
          await LocalDB().setDashboardImageSliderCache('');
          await LocalDB().removeJwtToken();
          homeController.jwtToken.value = '';
          homeController.isLoggedIn.value = false;
          homeController.selectedIndex.value = 0;
          Get.offAllNamed(Routes.signin);
          return false;
        } else {
          return true;
        }
      }
    } catch (e) {
      talker.error('Exception in getUserProfileByPhoneNumber API: $e');
    }
  }

  fetchCategoryList({
    required String languageId,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["language_id"] = languageId;
        Map<String, String> header = {};
        header = {'authorization': jwtToken};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().categoryListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            categoryListData.value = (apiBaseResponse.data as List)
                .map((data) => CategoryListResponseModel.fromJson(data))
                .toList();
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchCategoryList API: $e');
    }
  }

  fetchMediaList({
    required String languageId,
    required String id,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["language_id"] = languageId;
        request["id"] = id;
        Map<String, String> header = {'authorization': jwtToken};

        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().mediaListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            if (apiBaseResponse.data != null) {
              mediaListData.value = (apiBaseResponse.data as List)
                  .map((data) => MediaModel.fromJson(data))
                  .toList();
            } else {
              mediaListData.value = [];
            }
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchMediaList API: $e');
    }
  }

  userLoginApi({required phoneNumber, required password}) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, String> body = <String, String>{};
        body['mobile_no'] = phoneNumber.toString();
        body['password'] = password.toString();
        body['language_id'] = homeController.selectedLanguageId.value.toString();

        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.postDecryptLambdaCall(
          url: AppApi().loginApiUrl,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );

          if (apiBaseResponse.statusCode == 209) {
            if (apiBaseResponse.data != null) {
              loginResponseModel.value = LoginResponseModel.fromJson(
                apiBaseResponse.data,
              );

              homeController.isUserProfileCompleted.value =
                  loginResponseModel.value!.isProfileCompleted!;
              homeController.jwtToken.value = loginResponseModel.value!.jwtToken
                  .toString();
              homeController.userNameString.value = loginResponseModel
                  .value!
                  .name
                  .toString();
              homeController.userEmailString.value =
                  loginResponseModel.value!.email == null
                  ? ''
                  : loginResponseModel.value!.email.toString();
              homeController.userPhoneNumber.value = loginResponseModel
                  .value!
                  .mobileNo
                  .toString();
              homeController.countryCode.value = loginResponseModel
                  .value!
                  .mobileCountryCode
                  .toString();
              homeController.selectedLanguageId.value = loginResponseModel
                  .value!
                  .preferredLanguageId
                  .toString();
              homeController.userCityId.value = loginResponseModel.value!.cityId
                  .toString();
              homeController.userCountryId.value = loginResponseModel
                  .value!
                  .countryId
                  .toString();
              homeController.userStateId.value = loginResponseModel
                  .value!
                  .stateId
                  .toString();
              homeController.userGenderId.value =
                  loginResponseModel.value!.gender == null
                  ? ''
                  : loginResponseModel.value!.gender.toString();
              homeController.userDOB.value =
                  loginResponseModel.value!.birthdate == null
                  ? ''
                  : loginResponseModel.value!.birthdate.toString();
              homeController.isUserSurveyCompleted.value = loginResponseModel.value!.isSurveyCompleted!;
              homeController.isUserExists.value = true;
              homeController.passwordString.value = password;
              await LocalDB().setIsUserProfileCompleted(
                loginResponseModel.value!.isProfileCompleted!,
              );
              await LocalDB().setIsUserSurveyCompleted(
                loginResponseModel.value!.isSurveyCompleted!,
              );
              await LocalDB().setUserFullName(
                loginResponseModel.value!.name.toString(),
              );
              await LocalDB().setJwtToken(
                loginResponseModel.value!.jwtToken.toString(),
              );
              await LocalDB().setUserPhoneNumber(
                loginResponseModel.value!.mobileNo.toString(),
              );
              await LocalDB().setUserPassword(
                password.toString(),
              );
              await LocalDB().setCountryCode(
                loginResponseModel.value!.mobileCountryCode.toString(),
              );
              await LocalDB().setLanguageId(
                loginResponseModel.value!.preferredLanguageId.toString(),
              );
              await LocalDB().setUserCountryId(
                loginResponseModel.value!.countryId.toString(),
              );
              await LocalDB().setUserStateId(
                loginResponseModel.value!.stateId.toString(),
              );
              await LocalDB().setUserCityId(
                loginResponseModel.value!.cityId.toString(),
              );
              await LocalDB().setUserGenderId(
                loginResponseModel.value!.gender == null
                    ? ''
                    : loginResponseModel.value!.gender.toString(),
              );
              await LocalDB().setIsUserExists(true);
              await LocalDB().setUserPassword(password);
              await LocalDB().setUserDOB(
                loginResponseModel.value!.birthdate == null
                    ? ''
                    : loginResponseModel.value!.birthdate.toString(),
              );
              await LocalDB().setUserEmail(
                loginResponseModel.value!.email == null
                    ? ''
                    : loginResponseModel.value!.email.toString(),
              );
              await LocalDB().setIsLoggedIn(true);
              await LocalDB().reloadSharedPref();
              await homeController.reload();
              talker.debug('---------- Executed Login Api API Call ----------');
              return true;
            } else {
              return false;
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in userLoginApi API: $e');
      return false;
    }
  }

  Future<dynamic> changePassword({
    required userId,
    required currentPassword,
    required oldPassword,
    required newPassword,
    required jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["user_id"] = userId.toString();

        Map<String, dynamic> body = <String, dynamic>{};
        body['user_id'] = userId.toString();
        body['existing_password'] = '';
        body['old_password'] = oldPassword.toString();
        body['new_password'] = newPassword.toString();
        body['modified_by'] = userId.toString();

        Map<String, dynamic> header = {'authorization': jwtToken};
        dynamic response = await ApiServiceInterceptor.putDecryptLamdaCall(
          url: AppApi().changePasswordApiUrl,
          request: request,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            showCustomSnackBar(
              DynamicAppLocalizations.of(Get.context!).t("info"),
              DynamicAppLocalizations.of(
                Get.context!,
              ).t(apiBaseResponse.message.toString()),
              true,
            );
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in changePassword API: $e');
    }
  }

  Future<dynamic> sendForgotPasswordOtp(
    String phoneNumber,
    String countryCode,
  ) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, String> request = <String, String>{};
        request['mobile_no'] = phoneNumber.toString();
        request['mobile_country_code'] = countryCode.toString();

        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().forgotPasswordApiUrl,
          headers: header,
          request: request,
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            forgotPasswordsendOtpResponseModel.value =
                ForgotPasswordSendOtpResponseModel.fromJson(
                  apiBaseResponse.data,
                );
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in sendForgotPasswordOtp API: $e');
    }
  }

  Future<dynamic> resetPasswordApi({
    required String phoneNumber,
    required String countryCode,
    required String password,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, String> body = <String, String>{};
        body['mobile_no'] = phoneNumber.toString();
        body['mobile_country_code'] = countryCode.toString();
        body['password'] = password.toString();

        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.postDecryptLambdaCall(
          url: AppApi().resetPasswordApiUrl,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            //password_reset_successful
            showCustomSnackBar(
              DynamicAppLocalizations.of(Get.context!).t("info"),
              DynamicAppLocalizations.of(
                Get.context!,
              ).t(apiBaseResponse.message.toString()),
              true,
            );
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in resetPasswordApi API: $e');
    }
  }

  fetchSurveyQuestionListApi({
    required String languageId,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["language_id"] = languageId;
        Map<String, String> header = {'authorization': jwtToken};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().surveyQuestionListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            if (apiBaseResponse.data != null) {
              return surveyQuestionListResponseModel
                  .value = (apiBaseResponse.data as List)
                  .map((data) => SurveyQuestionListResponseModel.fromJson(data))
                  .toList();
            }
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchSurveyQuestionListApi API: $e');
    }
  }

  Future<dynamic> submitUserSurvey({
    required String userId,
    required List<Map<String, dynamic>> answer,
    required List<Map<String, dynamic>> answerOption,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, dynamic> body = <String, dynamic>{};
        body['user_id'] = userId.toString();
        body['answers'] = answer;
        body['answerOptions'] = answerOption;

        Map<String, String> header = {
          'authorization': jwtToken,
          'Content-Type': 'application/json',
        };
        var response = await ApiServiceInterceptor.postDecryptLambdaCall(
          url: AppApi().userSurveyCompleteApiUrl,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in submitUserSurvey API: $e');
    }
  }

  fetchDashboardHtmlContentApi({
    required String languageId,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["language_id"] = languageId;
        Map<String, String> header = {'authorization': jwtToken};

        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().dashboardHtmlSectionApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            talker.debug('------Executed APIcall');
            if (apiBaseResponse.data != null) {
              dashboardHtmlResponseModel.value = (apiBaseResponse.data as List)
                  .map(
                    (data) => DashboardHtmlContentResponseModel.fromJson(data),
                  )
                  .toList();
              final List<Map<String, dynamic>> jsonList =
                  dashboardHtmlResponseModel.map((e) => e.toJson()).toList();
              final String jsonString = jsonEncode(jsonList);
              await LocalDB().setDashboardHtmlCache(jsonString);
            } else {
              dashboardHtmlResponseModel.value = [];
            }
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchDashboardHtmlContent API: $e');
    }
  }

  fetchDashboardImageSliderApi({
    required String languageId,
    required String jwtToken,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["language_id"] = languageId;
        Map<String, String> header = {'authorization': jwtToken};

        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().dashboardImageSlidersApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            if (apiBaseResponse.data != null) {
              dashboardImageSliderResponseModel.value =
                  (apiBaseResponse.data as List)
                      .map(
                        (data) =>
                            DashboardImageSliderResponseModel.fromJson(data),
                      )
                      .toList();
              final List<Map<String, dynamic>> jsonList =
                  dashboardImageSliderResponseModel
                      .map((e) => e.toJson())
                      .toList();
              final String jsonString = jsonEncode(jsonList);
              await LocalDB().setDashboardImageSliderCache(jsonString);
            } else {
              dashboardImageSliderResponseModel.value = [];
            }
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchDashboardImageSlider API: $e');
    }
  }

  fetchUserHabits({
    required String jwtToken,
    required String languageId,
  }) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["language_id"] = languageId;
        Map<String, String> header = {'authorization': jwtToken};

        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().userHabitListApiUrl,
          request: request,
          headers: header,
        );
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );

          if (apiBaseResponse.statusCode == 209) {
            if (apiBaseResponse.data != null) {
              userHabitListResponseModel.value = (apiBaseResponse.data as List)
                  .map((data) => UserHabitListResponseModel.fromJson(data))
                  .toList();
            } else {
              userHabitListResponseModel.value = [];
            }
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchUserHabits API: $e');
    }
  }

  fetchDashboardSevaPranalika({required String date, required String jwtToken}) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        var request = <String, String>{};
        request["date"] = date;
        Map<String, String> header = {'authorization': jwtToken};
        var response = await ApiServiceInterceptor.getDecryptLambdaCall(
          url: AppApi().dailySevaPranalikaApiUrl,
          request: request,
          headers: header,
        );
        //dailySevaPranalikaResponseModel
        if (homeController.statusCode.value == 200) {
          var decodeString = jsonDecode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            decodeString,
          );
          if (apiBaseResponse.statusCode == 209) {
            if (apiBaseResponse.data != null) {
              dailySevaPranalikaResponseModel.value =
                  DailySevaPranalikaResponseModel.fromJson(
                    apiBaseResponse.data,
                  );
            } else {
              dailySevaPranalikaResponseModel.value = null;
            }
          }
        }
      }
    } catch (e) {
      talker.error('Exception in fetchDashboardSevaPranalika API: $e');
    }
  }

  Future<dynamic> validateUserOtp(
  {required String phoneNumber,
  required String countryCode,
  required String verificationId,
  required String userEnteredOtp}
  ) async {
    try {
      if (await ApiServiceInterceptor.checkInternet()) {
        Map<String, String> body = <String, String>{};
        body['mobile_number'] = phoneNumber.toString();
        body['country_code'] = countryCode.toString();
        body['verification_id'] = verificationId.toString();
        body['otp_code'] = userEnteredOtp.toString();

        Map<String, String> header = {};
        var response = await ApiServiceInterceptor.postDecryptLambdaCall(
          url: AppApi().validateOtpApiUrl,
          header: header,
          body: json.encode(body),
        );
        if (homeController.statusCode.value == 200) {
          var convertedResponse = json.decode(response);
          ApiBaseResponse apiBaseResponse = ApiBaseResponse.fromJson(
            convertedResponse,
          );
          if (apiBaseResponse.statusCode == 209) {
            // sendOtpResponseModel.value = SendOtpResponseModel.fromJson(
            //   apiBaseResponse.data,
            // );
            return true;
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    } catch (e) {
      talker.error('Exception in sendPhoneNumberOTP API: $e');
    }
  }

  // HELPERS
  // ... inside ApiController class ...

  // Helper function to find a version string by type name
  String _getVersionString(String versionTypeName) {
    for (var item in versionListData) {
      if (item.versionTypeName == versionTypeName) {
        return item.lastUpdatedDate.toString();
      }
    }
    return ''; // Return empty string if not found
  }

  // -------------------------------------------------------------
  // 1. Labels Version Logic (Extracted)
  // -------------------------------------------------------------
  Future<void> _checkForLabelVersionUpdate() async {
    final versionString = _getVersionString("@@labels_version@@");

    if (versionString.isEmpty) return;

    String? storedVersion = await LocalDB().getLabelLanguageVersion() ?? '';
    bool shouldUpdate = false;
    if (storedVersion.isEmpty) {
      shouldUpdate = true;
    } else {
      try {
        final apiDate = DateTime.parse(versionString);
        final localDate = DateTime.parse(storedVersion);
        if (apiDate.isAfter(localDate)) {
          shouldUpdate = true;
        }
      } catch (e) {
        // Handle parsing error (e.g., corrupted stored version)
        shouldUpdate = true;
      }
    }

    if (shouldUpdate) {
      talker.info('Label version mismatch/new. Updating labels.');

      if (homeController.selectedLanguageId.value.isNotEmpty) {
        await getLanguageLabels(homeController.selectedLanguageId.value);
      }

      await LocalDB().setLabelLanguageVersion(versionString);
    } else {
      try {
        final cachedJson = await LocalDB().getLanguageLabelsCache();
        if (cachedJson != null && cachedJson.isNotEmpty) {
          final List<dynamic> cachedList = json.decode(cachedJson);
          final List<DynamicLabel> cachedLabels = cachedList
              .map<DynamicLabel>((e) => DynamicLabel.fromJson(e))
              .toList();

          final dynamicCtrl = Get.put(DynamicLocaleController());

          dynamicCtrl.setLabels(cachedLabels, isFromCache: true);
        }
      } catch (e) {
        talker.error('Exception loading language labels from cache: $e');
      }
    }
  }

  // -------------------------------------------------------------
  // 2. Dashboard HTML Version Logic (Extracted)
  // -------------------------------------------------------------
  Future<void> _checkForDashboardVersionUpdate() async {
    final versionString = _getVersionString("@@dashboard_version@@");

    if (versionString.isEmpty) return;

    String? storedVersion = await LocalDB().getDashboardVersion() ?? '';
    bool shouldUpdate = false;

    if (storedVersion.isEmpty) {
      shouldUpdate = true;
    } else {
      try {
        final apiDate = DateTime.parse(versionString);
        final localDate = DateTime.parse(storedVersion);
        if (apiDate.isAfter(localDate)) {
          shouldUpdate = true;
        }
      } catch (e) {
        shouldUpdate = true;
      }
    }

    if (shouldUpdate) {
      talker.info('Dashboard HTML version mismatch/new. Updating content.');
      await LocalDB().setDashboardVersion(versionString);
      await fetchDashboardHtmlContentApi(
        languageId: homeController.selectedLanguageId.value,
        jwtToken: homeController.jwtToken.value,
      );
    }
  }

  // -------------------------------------------------------------
  // 3. Dashboard Slider Version Logic (Extracted)
  // -------------------------------------------------------------
  Future<void> _checkForDashboardSliderVersionUpdate() async {
    final versionString = _getVersionString("@@dashboard_slider_version@@");

    if (versionString.isEmpty) return;

    String? storedVersion = await LocalDB().getDashboardSliderVersion() ?? '';
    bool shouldUpdate = false;

    if (storedVersion.isEmpty) {
      shouldUpdate = true;
    } else {
      try {
        final apiDate = DateTime.parse(versionString);
        final localDate = DateTime.parse(storedVersion);
        if (apiDate.isAfter(localDate)) {
          shouldUpdate = true;
        }
      } catch (e) {
        shouldUpdate = true;
      }
    }

    if (shouldUpdate) {
      talker.info(
        'Dashboard Slider version mismatch/new. Updating slider images.',
      );
      await LocalDB().setDashboardSliderVersion(versionString);
      await fetchDashboardImageSliderApi(
        languageId: homeController.selectedLanguageId.value,
        jwtToken: homeController.jwtToken.value,
      );
    }
  }
}
