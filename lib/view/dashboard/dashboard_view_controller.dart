import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:m_vyo_demo/widget/custom_button_widget.dart';
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

  Future<ui.Image>? imageDimensionsFuture;

  int hexColorWithHash = 7;
  int hexColorWithAlpha = 9;
  int hexColorLength = 6;

  @override
  void onInit() async {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    fetchSevaPranalikaDetails();

    fetchDashboardDetails();
    fetchDashboardImageSlider();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    //   checkUserRegistration();
    // });
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

    image.image
        .resolve(const ImageConfiguration())
        .addListener(
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
      await apiController.fetchDashboardSevaPranalika(
        date: formattedDate,
        jwtToken: homeController.jwtToken.value,
      );
      displaySevaPranalikaAlert();
    }
  }

  displaySevaPranalikaAlert() {
    return Get.defaultDialog(
      title: "",
      titleStyle: TextStyle(fontSize: 0),
      titlePadding: EdgeInsets.zero,
      barrierDismissible: false,
      radius: borderRadius,
      backgroundColor: AppColors.white,
      contentPadding: EdgeInsets.zero,
      content: Builder(
        builder: (context) {
          double screenHeight = MediaQuery.of(context).size.height;
          double maxHeight = screenHeight * 0.50;
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
                        child: _buildDetailsCard(),
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

  Widget _buildDetailsCard() {
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
              apiController.dailySevaPranalikaResponseModel.value?.date ?? "",
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
                onPressed: () => Get.back(),
                backgroundColor: AppColors.primaryColor,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
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
        const SizedBox(width: 8,),
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
        const SizedBox(width: 8,),
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
