import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:html/dom.dart' as dom;

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_vyo_demo/widget/custom_button_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// import '../../const/logger.dart';
import '../../const/app_assets.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../model/dashboard_html_content_response_model.dart';
import '../../model/dashboard_image_slider_response_model.dart';
import '../../utility/common_functions.dart';
import '../../utility/local_db.dart';
import '../../widget/custom_alert_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/user_details_popup.dart';

class DashboardViewController extends GetxController
    with WidgetsBindingObserver {
  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());
  ScrollController scrollController = ScrollController();
  ScrollController sevaPranalikaScroll = ScrollController();

  RxBool isLoading = true.obs;
  RxBool isImageSliderLoading = true.obs;
  RxBool isInternalNavigation = false.obs;

  RxString androidAppCurrentVersionString = "".obs;
  RxString iosAppCurrentVersionString = "".obs;
  RxBool isAndroidForceUpdate = false.obs;
  RxBool isAndroidDisplay = false.obs;
  RxBool isIosForceUpdate = false.obs;
  RxBool isiOSDisplay = false.obs;

  Rx<PackageInfo> packageInfo = PackageInfo(
    appName: "",
    packageName: "",
    version: "",
    buildNumber: "",
  ).obs;

  Future<ui.Image>? imageDimensionsFuture;

  int hexColorWithHash = 7;
  int hexColorWithAlpha = 9;
  int hexColorLength = 6;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    isInternalNavigation.value =
        (Get.arguments?['isInternalNavigation'] as bool?) ?? false;

    if (isInternalNavigation.value) {
      return;
    }

    if (homeController.isUserProfileCompleted.value == true) {
      fetchSevaPranalikaDetails();
      fetchDashboardDetails();
      fetchDashboardImageSlider();
    }
  }

  @override
  void onReady() {
    super.onReady();

    // Ensures screen is fully built & visible
    checkUserRegistration();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    scrollController.dispose();
    sevaPranalikaScroll.dispose();
    super.onClose();
  }

  checkUserRegistration() async {
    if (!homeController.isUserExists.value ||
        !homeController.isUserProfileCompleted.value) {
      showUserDetailsDialog(Get.context!);
    }
  }

  fetchDashboardDetails() async {
    final cachedJson = await LocalDB().getDashboardHtmlCache() ?? '';
    // talker.debug('------- Dashbaord cache html: $cachedJson');
    if (cachedJson.isEmpty) {
      isLoading.value = true;
      await apiController.fetchDashboardHtmlContentApi(
        languageId: homeController.selectedLanguageId.value,
        jwtToken: homeController.jwtToken.value,
      );
      isLoading.value = false;
    } else {
      final List<dynamic> jsonList = jsonDecode(cachedJson);
      apiController.dashboardHtmlResponseModel.value = jsonList
          .map((j) => DashboardHtmlContentResponseModel.fromJson(j))
          .toList();
    }

    isLoading.value = false;
  }

  fetchDashboardImageSlider() async {
    final cachedJson = await LocalDB().getDashboardImageSliderCache() ?? '';
    if (cachedJson.isEmpty) {
      isImageSliderLoading.value = true;

      await apiController.fetchDashboardImageSliderApi(
        languageId: homeController.selectedLanguageId.value,
        jwtToken: homeController.jwtToken.value,
      );
      isImageSliderLoading.value = false;
    } else {
      final List<dynamic> jsonList = jsonDecode(cachedJson);
      apiController.dashboardImageSliderResponseModel.value = jsonList
          .map((j) => DashboardImageSliderResponseModel.fromJson(j))
          .toList();
    }

    isImageSliderLoading.value = false;
  }

  Future<void> refreshDashboard() async {
    await apiController.fetchVersionsList(
      isUserLoggedIn: true,
      jwtToken: homeController.jwtToken.value,
    );
    await fetchDashboardDetails();
    await fetchDashboardImageSlider();
  }

  Future<ui.Image> getImageDimensions(String url) async {
    final Completer<ui.Image> completer = Completer();
    final Image image = Image.network(url);

    image.image.resolve(const ImageConfiguration()).addListener(
          ImageStreamListener(
            (ImageInfo info, bool _) {
              completer.complete(info.image);
            },
            onError: (error, stackTrace) {
              completer.completeError(error);
            },
          ),
        );

    return completer.future;
  }

  /// Fetch dimensions for multiple images in parallel.
  Future<List<ui.Image>> getImagesDimensions(List<String> urls) async {
    final futures = urls.map((u) => getImageDimensions(u)).toList();
    return Future.wait(futures);
  }

  fetchSevaPranalikaDetails() async {
    if (homeController.jwtToken.value.isNotEmpty) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
      bool isSuccess = await apiController.fetchDashboardSevaPranalika(
        date: formattedDate,
        jwtToken: homeController.jwtToken.value,
      );
      if (isSuccess) {
        fetchDashboardDetails();
        fetchDashboardImageSlider();
        if (apiController.dailySevaPranalikaResponseModel.value != null &&
            homeController.isUserProfileCompleted.value) {
          displaySevaPranalikaAlert(true, true);
        }
      }
    }
  }

  displaySevaPranalikaAlert(bool checkAppUpdate, bool isDisplayHtmlContent) {
    return Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      radius: borderRadius,
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.zero,
      content: PopScope(
        canPop: false,
        child: Builder(
          builder: (context) {
            double screenHeight = MediaQuery.of(context).size.height;
            double maxHeight = screenHeight * 0.60;
            double minHeight = screenHeight * 0.30;

            return SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(AppIcons.toran, fit: BoxFit.fitHeight),
                  const SizedBox(height: 20),
                  _buildSevaPranalikaTitle(),
                  SizedBox(height: 12),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: minHeight,
                      maxHeight: maxHeight,
                    ),
                    child: ScrollbarTheme(
                      data: ScrollbarThemeData(
                        thumbColor: WidgetStateProperty.all(
                          AppColors.primaryColor,
                        ),
                      ),
                      child: Scrollbar(
                        thumbVisibility: true,
                        controller: sevaPranalikaScroll,
                        child: SingleChildScrollView(
                          controller: sevaPranalikaScroll,
                          child: _buildDetailsCard(
                              checkAppUpdate, isDisplayHtmlContent),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSevaPranalikaTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.primaryColor, width: 2.0),
        ),
        child: Center(
          child: CustomTextWidget(
            fontColor: AppColors.primaryColor,
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t("seva_pranalika_title"),
            textSize: FontSize().large,
            numberOfLines: 2,
            isFontBold: false,
            isFontUnderline: false,
            fontStyle: FontStyle.normal,
            textCenter: true,
          ),
        ),
      ),
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    packageInfo.value = info;
  }

  Widget _buildDetailsCard(bool checkAppUpdate, bool isDisplayHtmlContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.15),
              spreadRadius: 0,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderImage(),
            const SizedBox(height: 16),
            _buildDetailRow(
              "🌹",
              apiController.dailySevaPranalikaResponseModel.value?.sevaDate ??
                  "",
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              "🌸",
              apiController.dailySevaPranalikaResponseModel.value?.miti ?? "",
            ),
            const SizedBox(height: 16),
            _buildConditionalRow(
              "vastra",
              apiController.dailySevaPranalikaResponseModel.value?.vastra,
            ),
            _buildConditionalRow(
              "mastak",
              apiController.dailySevaPranalikaResponseModel.value?.mastak,
            ),
            _buildConditionalRow(
              "aabharan",
              apiController.dailySevaPranalikaResponseModel.value?.aabharan,
            ),
            _buildSpecialVastraRow(),
            const SizedBox(height: 16),
            Center(
              child: CustomElevatedButton(
                width: MediaQuery.of(Get.context!).size.width * 0.40,
                title: DynamicAppLocalizations.of(Get.context!).t("ok"),
                textColor: AppColors.white,
                onPressed: () async {
                  print('on ok button');
                  print('on ok button : $checkAppUpdate');
                  print('on ok button : $isDisplayHtmlContent');
                  if (!checkAppUpdate) {
                    if (isDisplayHtmlContent) {
                      Get.back();
                      displayNotificationContent();
                    } else {
                      return Get.back();
                    }
                  } else {
                    if (apiController.dailySevaPranalikaResponseModel.value!
                            .appUpdates !=
                        null) {
                      final update = getPlatformUpdate(apiController
                          .dailySevaPranalikaResponseModel.value!.appUpdates!);
                      if (update != null && update.isDisplay == true) {
                        await _initPackageInfo();
                        // Get.back();
                        if (Platform.isAndroid) {
                          androidAppCurrentVersionString.value =
                              update.currentVersion.toString();
                          isAndroidForceUpdate.value = update.forceUpdate;
                          isAndroidDisplay.value = update.isDisplay;
                          if (getExtendedVersionNumber(
                                  packageInfo.value.version.toString()) ==
                              getExtendedVersionNumber(
                                  androidAppCurrentVersionString.value
                                      .toString())) {
                            Get.back();
                            displayNotificationContent();
                            return;
                          } else if (getExtendedVersionNumber(
                                  packageInfo.value.version.toString()) >
                              getExtendedVersionNumber(
                                  androidAppCurrentVersionString.value
                                      .toString())) {
                            Get.back();
                            displayNotificationContent();
                            return;
                          } else if (getExtendedVersionNumber(
                                  packageInfo.value.version.toString()) >
                              getExtendedVersionNumber(
                                  androidAppCurrentVersionString.value
                                      .toString())) {
                            Get.back();
                            displayNotificationContent();
                            return;
                          } else {
                            if (isAndroidDisplay.value == true) {
                              dynamic cancelResult =
                                  await showForceUpdateDialog(update);
                              if (cancelResult == 'cancel') {
                                Get.back();
                                Get.back();

                                if (isDisplayHtmlContent) {
                                  Get.back();

                                  displayNotificationContent();
                                }
                              }
                              return;
                            } else {
                              return;
                            }
                          }
                        } else if (Platform.isIOS) {
                          iosAppCurrentVersionString.value =
                              update.currentVersion;
                          isIosForceUpdate.value = update.forceUpdate;
                          isiOSDisplay.value = update.isDisplay;
                          if (getExtendedVersionNumber(
                                  packageInfo.value.version.toString()) ==
                              getExtendedVersionNumber(
                                  iosAppCurrentVersionString.value
                                      .toString())) {
                            Get.back();
                            displayNotificationContent();
                            return;
                          } else if (getExtendedVersionNumber(
                                  packageInfo.value.version.toString()) >
                              getExtendedVersionNumber(
                                  iosAppCurrentVersionString.value
                                      .toString())) {
                            Get.back();
                            displayNotificationContent();
                            return;
                          } else if (getExtendedVersionNumber(
                                  packageInfo.value.version.toString()) >
                              getExtendedVersionNumber(
                                  iosAppCurrentVersionString.value
                                      .toString())) {
                            Get.back();
                            displayNotificationContent();
                            return;
                          } else {
                            if (isiOSDisplay.value == true) {
                              dynamic cancelResult =
                                  await showForceUpdateDialog(update);
                              if (cancelResult == 'cancel') {
                                if (isDisplayHtmlContent) {
                                  Get.back();
                                  Get.back();

                                  displayNotificationContent();
                                }
                              }
                              return;
                            } else {
                              return;
                            }
                          }
                        }
                      } else {
                        if (isDisplayHtmlContent) {
                          Get.back();
                          displayNotificationContent();
                        }
                      }
                    } else {
                      if (isDisplayHtmlContent) {
                        Get.back();
                        displayNotificationContent();
                      }
                    }
                  }
                },
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  displayNotificationContent() {
    return apiController
            .dailySevaPranalikaResponseModel.value!.notificationDetail!.isEmpty
        ? const SizedBox()
        : CustomAlertWidget().simpleAlertDialog(
            title: '',
            content: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: Get.width,
                maxWidth: Get.width,
                maxHeight: Get.height * 0.70,
                minHeight: Get.height * 0.30
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: HtmlWidget(
                    apiController
                        .dailySevaPranalikaResponseModel.value!.notificationDetail
                        .toString(),
                    textStyle: const TextStyle(fontStyle: FontStyle.normal),
                    customWidgetBuilder: (dom.Element element) {
                      if (element.localName == 'div' &&
                          element.parent?.localName == 'a' &&
                          element.children.length == 2 &&
                          // element.children[0].localName == 'img' &&
                          element.children[1].localName == 'div') {
                        final style = element.attributes['style'] ?? '';
                
                        // Extract Background Color
                        Color? bgColor;
                        final bgColorMatch = RegExp(
                          r'background: *([^;]+)',
                        ).firstMatch(style);
                        if (bgColorMatch != null) {
                          bgColor = _parseColor(bgColorMatch.group(1)!.trim());
                        }
                
                        // Extract Padding
                        EdgeInsets padding = EdgeInsets.zero;
                        final paddingMatch = RegExp(
                          r'padding: *(\d+)(px)?',
                        ).firstMatch(style);
                        if (paddingMatch != null) {
                          double paddingValue =
                              double.tryParse(paddingMatch.group(1)!) ?? 0.0;
                          padding = EdgeInsets.all(paddingValue);
                        }
                
                        BoxDecoration decoration = BoxDecoration(
                          color: bgColor ?? AppColors.transparent,
                        );
                        if (style.contains('border:2px solid #D24F16')) {
                          decoration = decoration.copyWith(
                            border: Border.all(
                                color: AppColors.primaryColor, width: 2.0),
                          );
                        }
                
                        // --- 2. Build Children ---
                
                        // Recursively render the two child elements (img and div) using the context
                        // Note: HtmlWidget context provides a method to render children safely.
                        // Since we are creating a custom widget, we need to manually create the children
                        // to include them in our Row layout.
                
                        // We'll use the package's internal rendering engine to convert the children DOM
                        // nodes into Flutter widgets. We need a special builder context for this.
                        // Since HtmlWidget is designed to handle all rendering internally,
                        // the simplest way is to manually instantiate a sub-HtmlWidget for the children,
                        // or manually locate the Image and Text widgets if they are rendered by the core.
                
                        // The most reliable way with fwfh is to build the Row and use sub-widgets for the content:
                
                        // Convert the inner content HTML to strings for recursive rendering
                        final imgHtml = element.children[0].outerHtml;
                        final textDivHtml = element.children[1].outerHtml;
                
                        return Container(
                          padding: padding,
                          decoration: decoration,
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Icon (img)
                              HtmlWidget(
                                imgHtml,
                                onLoadingBuilder:
                                    (context, element, loadingProgress) =>
                                        const SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child:
                                        CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: HtmlWidget(
                                  textDivHtml,
                                  textStyle:
                                      const TextStyle(fontStyle: FontStyle.normal),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return null;
                    },
                    onTapUrl: (url) async {
                      final uri = Uri.tryParse(url);
                      if (uri != null && await canLaunchUrl(uri)) {
                        await launchUrl(uri);
                        return true;
                      } else {
                        debugPrint('Could not launch URL: $url');
                        return false;
                      }
                    },
                  ),
                ),
              ),
            ),
            canPop: false,
            buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
          );
  }

  Widget _buildHeaderImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
      child: Image.asset(
        AppIcons.dailyPranaliHeaderImage,
        fit: BoxFit.fitHeight,
      ),
    );
  }

  Color? _parseColor(String colorString) {
    if (colorString.startsWith('#') &&
        (colorString.length == 7 || colorString.length == 9)) {
      String hex = colorString.substring(1);
      if (hex.length == 6) {
        hex = 'FF$hex';
      }
      return Color(int.parse(hex, radix: 16));
    }
    switch (colorString.toLowerCase()) {
      case 'red':
        return AppColors.red;
      case 'blue':
        return AppColors.blue;
      case 'white':
        return AppColors.white;
      case 'black':
        return AppColors.black;
      case 'grey':
        return AppColors.grey;
      default:
        return null;
    }
  }

  Widget _buildDetailRow(String icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          fontColor: AppColors.primaryColor,
          textString: icon,
          textSize: FontSize().xmedium,
          numberOfLines: 2,
          isFontBold: false,
          isFontUnderline: false,
          fontStyle: FontStyle.normal,
        ),
        const SizedBox(
          width: 8,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: Get.width * 0.30,
            maxWidth: Get.width * 0.40,
          ),
          child: CustomTextWidget(
            fontColor: AppColors.primaryColor,
            textString: text,
            textSize: FontSize().xmedium,
            numberOfLines: 4,
            isFontBold: false,
            isFontUnderline: false,
            fontStyle: FontStyle.normal,
            textCenter: true,
          ),
        ),
        const SizedBox(
          width: 8,
        ),
        CustomTextWidget(
          fontColor: AppColors.primaryColor,
          textString: icon,
          textSize: FontSize().xmedium,
          numberOfLines: 2,
          isFontBold: false,
          isFontUnderline: false,
          fontStyle: FontStyle.normal,
        ),
      ],
    );
  }

  Widget _buildConditionalRow(String key, String? value) {
    if (value == null || value.isEmpty) return const SizedBox();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          fontColor: AppColors.black,
          textString: "${DynamicAppLocalizations.of(Get.context!).t(key)}  -  ",
          textSize: FontSize().regular,
          numberOfLines: 1,
          isFontBold: false,
          isFontUnderline: false,
          fontStyle: FontStyle.normal,
        ),
        Container(
          constraints: BoxConstraints(
            minWidth: Get.width * 0.30,
            maxWidth: Get.width * 0.40,
          ),
          child: CustomTextWidget(
            fontColor: AppColors.primaryColor,
            textString: value,
            textSize: FontSize().regular,
            numberOfLines: 10,
            isFontBold: false,
            isFontUnderline: false,
            fontStyle: FontStyle.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialVastraRow() {
    var specialVastra =
        apiController.dailySevaPranalikaResponseModel.value?.specialVastra;
    if (specialVastra == null || specialVastra.isEmpty) return const SizedBox();

    return Column(
      children: [
        Divider(
          thickness: 1,
          color: AppColors.grey200,
          endIndent: 20.0,
          indent: 20.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              fontColor: AppColors.black,
              textString:
                  "${DynamicAppLocalizations.of(Get.context!).t("special_vastra")}  -  ",
              textSize: FontSize().regular,
              numberOfLines: 1,
              isFontBold: false,
              isFontUnderline: false,
              fontStyle: FontStyle.normal,
            ),
            Container(
              constraints: BoxConstraints(
                minWidth: Get.width * 0.30,
                maxWidth: Get.width * 0.40,
              ),
              child: CustomTextWidget(
                fontColor: AppColors.primaryColor,
                textString: specialVastra,
                textSize: FontSize().regular,
                numberOfLines: 20,
                isFontBold: false,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  final String whatsappBaseUrl = 'https://wa.me/';
  final String phoneNumber =
      '9601353414'; // Replace with the actual phone number
  final String preWrittenMessage =
      'Hello, this is a message from VYO World.'; // The message you want to send
  Future<void> openWhatsApp() async {
    final String url =
        '$whatsappBaseUrl$phoneNumber?text=${Uri.encodeComponent(preWrittenMessage)}';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      // throw 'Could not launch $url';
      _showWhatsAppNotInstalled();
    }
  }

  void _showWhatsAppNotInstalled() {
    CustomAlertWidget().infoAlertDialog(
      displayText: DynamicAppLocalizations.of(
        Get.context!,
      ).t("whatsapp_not_installed"),
      displaySubText: DynamicAppLocalizations.of(
        Get.context!,
      ).t("whats_app_not_installed_sub_text"),
      buttonText: DynamicAppLocalizations.of(Get.context!).t("ok"),
      statusType: false,
    );
  }
}

class EmojiParser {
  static String parse(String input) {
    if (input.isEmpty) return input;

    if (_containsDirectEmoji(input)) {
      return input;
    }

    // Step 1: Normalize \U0001F600 → \u{1F600}
    String normalized = input.replaceAllMapped(
      RegExp(r'\\U([0-9A-Fa-f]{4,8})'),
      (match) => "\\u{${match.group(1)}}",
    );

    // Step 2: Convert \u{1F600} → actual emoji
    return normalized.replaceAllMapped(RegExp(r'\\u\{([0-9A-Fa-f]+)\}'), (
      match,
    ) {
      final hex = match.group(1)!;
      final codePoint = int.tryParse(hex, radix: 16);

      if (codePoint == null) return match.group(0)!; // fallback
      return String.fromCharCode(codePoint);
    });
  }

  /// Checks if string already contains emoji
  static bool _containsDirectEmoji(String input) {
    final emojiRegex = RegExp(
      r'[\u{1F300}-\u{1FAFF}\u{1F600}-\u{1F64F}\u{2600}-\u{27BF}]',
      unicode: true,
    );
    return emojiRegex.hasMatch(input);
  }
}
