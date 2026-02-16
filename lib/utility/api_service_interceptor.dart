import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../const/logger.dart';
import '../controller/home_controller.dart';
import '../localization/dynamic_app_localizations.dart';
import '../utility/encrypt_decrypt.dart';
import '../widget/common_widget.dart';
import '../widget/custom_alert_widget.dart';
import 'api_base_response.dart';

enum InternetStatus { noNetwork, noInternet, connected }

class ApiServiceInterceptor {
  static Dio dio = Dio();
  static CancelToken cancelToken = CancelToken();
  static HomeController homeController = Get.put(HomeController());
  static bool isLoggingOut = false;

  static checkInternet() async {
    try {
      late List<ConnectivityResult> connectivityResult;
      connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        return false;
      } else {
        homeController.isDisplayInternetConnection.value = false;
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  static Future<Map<String, dynamic>> checkInternetFunction() async{
    try {
      final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult.contains(ConnectivityResult.none)) {
        return {
          "status": InternetStatus.noNetwork,
          "isConnected": false,
        };
      }

      final bool hasInternet = await InternetConnection().hasInternetAccess;
      if(!hasInternet) {
        return {
          "status": InternetStatus.noInternet,
          "isConnected": false,
        };
      }

      return {
          "status": InternetStatus.connected,
          "isConnected": true,
        };


    } catch (e) {
      return {
          "status": InternetStatus.noInternet,
          "isConnected": false,
        };
    }
  }

  static void cancelRequest() {
    cancelToken.cancel("Request cancelled");
    cancelToken = CancelToken();
  }

  static void addInterceptors() {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (ApiServiceInterceptor.isLoggingOut) {
            return handler.reject(
              DioException(
                requestOptions: options,
                error: 'Request blocked during logout',
                type: DioExceptionType.cancel,
              ),
            );
          }
          talker.info("Options Data : ${options.uri} | ${options.data}");
          // bool isConnected = await checkInternet();
          // bool isToken = homeController.jwtTokenString.value.isEmpty;
          talker.info('Api Url : ${options.uri}');
          // if (!isConnected) {
          //   return handler.reject(
          //     DioException(
          //       requestOptions: options,
          //       type: DioExceptionType.unknown,
          //       error: AppLocalizations.of(Get.context!)!.noInternetConnection,
          //     ),
          //   );
          // }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          talker
              .info('onResponse : ${response.realUri} ${response.statusCode}');
          homeController.statusCode.value = response.statusCode ?? 0;
          if (response.statusCode == 200) {
            response.data = decryptApiResponse(response.data);
            if (response.data.toString().contains('{"StatusCode')) {
              var jsonString = json.decode(response.data);
              ApiBaseResponse apiBaseResponse =
                  ApiBaseResponse.fromJson(jsonString);
              if (apiBaseResponse.statusCode == 210) {
                if (apiBaseResponse.message!.length > 27) {
                  CustomAlertWidget().infoAlertDialog(
                      displayText: apiBaseResponse.message.toString(),
                      buttonText:
                          DynamicAppLocalizations.of(Get.context!).t("ok"),
                      statusType: false);
                } else {
                  showCustomSnackBar(
                      DynamicAppLocalizations.of(Get.context!).t("info"),
                      apiBaseResponse.message,
                      false);
                }
              } else if (apiBaseResponse.statusCode == 211 ||
                  apiBaseResponse.statusCode == 212) {
                // if (apiBaseResponse.message!.length > 27) {
                //   CustomAlertWidget().errorAlertDialog(
                //       displayText: "",
                //       displaySubText: apiBaseResponse.message.toString(),
                //       buttonText: AppLocalizations.of(Get.context!)!.ok,
                //       statusType: false);
                // } else {
                //   showCustomSnackBar(DynamicAppLocalizations.of(Get.context!).t("info"),
                //       apiBaseResponse.message.toString(), false);
                // }
                showCustomSnackBar(
                    DynamicAppLocalizations.of(Get.context!).t("info"),
                    apiBaseResponse.message.toString(),
                    false);
              } else if (apiBaseResponse.statusCode == 213 ||
                  apiBaseResponse.statusCode == 214) {
                if (apiBaseResponse.message!.length > 27) {
                  CustomAlertWidget().infoAlertDialog(
                      displayText: apiBaseResponse.message.toString(),
                      buttonText:
                          DynamicAppLocalizations.of(Get.context!).t("ok"),
                      statusType: false);
                } else {
                  showCustomSnackBar(
                      DynamicAppLocalizations.of(Get.context!).t("info"),
                      apiBaseResponse.message,
                      false);
                }
              }
            }
            talker.info("Api Response : ${response.data} ${response.realUri}");
          } else if (response.statusCode == 227) {
            response.data = decryptApiResponse(response.data);
          } else if (response.statusCode == 400) {
            response.data = decryptApiResponse(response.data);
          } else if (response.statusCode == 401 || response.statusCode == 403) {
            response.data = jsonDecode(response.data);
          } else if (response.statusCode == 500) {
            showCustomSnackBar(
                DynamicAppLocalizations.of(Get.context!).t("alert"),
                DynamicAppLocalizations.of(Get.context!)
                    .t("something_went_wrong"),
                false);
            response.data = response.data;
          } else if (response.statusCode == 504) {
            CustomAlertWidget().infoAlertDialog(
                displayText: DynamicAppLocalizations.of(Get.context!)
                    .t("try_again_after_sometime"),
                buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
                statusType: false);
            response.data = response.data;
          }
          return handler.next(response);
        },
        onError: (e, handler) {
          if (ApiServiceInterceptor.isLoggingOut) {
            return handler.reject(e);
          }

          talker.error(
              "onError response: ${e.response!.statusCode} : ${e.response!.realUri} : ${e.response!.data} }");
          if (CancelToken.isCancel(e)) {
            e.response?.data = -1;
            return handler.reject(e);
          } else if (e.type == DioExceptionType.receiveTimeout ||
              e.type == DioExceptionType.connectionTimeout) {
            homeController.statusCode.value = 504;
            homeController.update();
            showCustomSnackBar(
                DynamicAppLocalizations.of(Get.context!).t("info"),
                DynamicAppLocalizations.of(Get.context!).t("timeout"),
                false);
            e.response?.data = null;
          } else if (e.type == DioExceptionType.badResponse) {
            if (e.message.toString().contains('403')) {
              homeController.statusCode.value = 403;
              return handler.reject(e);
            } else if (e.message.toString().contains('401')) {
              homeController.statusCode.value = 401;
              talker.error(
                  '${e.response?.realUri.toString()} || ${e.response?.statusCode} || ${e.response?.data}');
              return handler.reject(e);
            } else if (e.message.toString().contains('500')) {
              talker.critical(
                  '${e.response?.realUri.toString()} || ${e.response?.statusCode} || ${e.response?.data}');
              homeController.statusCode.value = 500;
              showCustomSnackBar(
                  DynamicAppLocalizations.of(Get.context!).t("alert"),
                  DynamicAppLocalizations.of(Get.context!)
                      .t("something_went_wrong"),
                  false);
            } else if (e.message.toString().contains('400')) {
              homeController.statusCode.value = 400;
              talker.critical(
                  '${e.response?.realUri.toString()} || ${e.response?.statusCode} || ${e.response?.data}');
              dynamic getServiceErrorMessage = e.response?.data;
              if (getServiceErrorMessage.toString().contains("message")) {
                var jsonString = json.decode(getServiceErrorMessage);
                getServiceErrorMessage = jsonString['message'];
              } else {
                getServiceErrorMessage = e.response?.data.toString();
              }
              showCustomSnackBar(
                  DynamicAppLocalizations.of(Get.context!).t("alert"),
                  getServiceErrorMessage,
                  false);
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Future<dynamic> getDecryptLambdaCall({
    required String url,
    Map<String, String>? request,
    required Map<String, String> headers,
  }) async {
    addInterceptors();
    try {
      final response = await dio
          .get(
            url,
            queryParameters: request,
            options:
                Options(responseType: ResponseType.plain, headers: headers),
            cancelToken: cancelToken,
          )
          .timeout(
            Duration(seconds: 30),
          );
      return response.data;
    } catch (e) {
      talker.error('Get Decrypt Lambda call exception : $e $url');
      return null;
    }
  }

  static Future<dynamic> postDecryptLambdaCall({
    required String url,
    var header,
    var body,
  }) async {
    addInterceptors();
    try {
      final response = await dio
          .post(
            url,
            data: body,
            options: Options(responseType: ResponseType.plain, headers: header),
            cancelToken: cancelToken,
          )
          .timeout(Duration(seconds: 30));
      return response.data;
    } catch (e) {
      talker.error('Post Decrypt Lambda call exception : $e');
      return null;
    }
  }

  static Future<dynamic> putDecryptLamdaCall(
      {String? url, var request, var header, var body}) async {
    addInterceptors();

    try {
      var uri = Uri.parse(url!);
      uri = uri.replace(queryParameters: request);

      final response = await dio.put(
        uri.toString(),
        data: body,
        options: Options(
          responseType: ResponseType.plain,
          headers: header,
        ),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      talker.error('Put Decrypt Lambda call exception : $e');
    }
  }

  static putDecryptLamdaUrlEncodedCall(
      {String? url, var request, var header, var body}) async {
    try {
      var uri = Uri.parse(url!);
      uri = uri.replace(queryParameters: body);

      final response = await dio.put(
        uri.toString(),
        data: body,
        options: Options(
          responseType: ResponseType.plain,
          headers: header,
        ),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      talker.error('Put Decrypt Lambda call exception : $e');
    }
  }

  static deleteDecryptLambdaCall(
      {required String url,
      Map<String, String>? request,
      required Map<String, String> headers}) async {
    addInterceptors();
    try {
      var uri = Uri.parse(url);
      uri = uri.replace(queryParameters: request);
      final response = await dio
          .delete(
            uri.toString(),
            options: Options(
              responseType: ResponseType.plain,
              headers: headers,
            ),
            cancelToken: cancelToken,
          )
          .timeout(Duration(seconds: 30));
      return response.data;
    } catch (e) {
      talker.error('Delete Decrypt Lambda call exception : $e');
    }
  }
}
