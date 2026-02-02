import 'dart:async';
import 'dart:convert';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../model/pushti_practices_response_model.dart';
import '../../model/user_habit_list_response_model.dart';
import '../../utility/api_service_interceptor.dart';
import '../../utility/local_db.dart';

class HabitViewController extends GetxController with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final ScrollController scrollController = ScrollController();
  RxBool isShimmerLoading = false.obs;
  RxBool isLoading = false.obs;

  RxList<UserHabitListResponseModel> userHabitListResponseModel =
      <UserHabitListResponseModel>[].obs;
  RxMap<String, List<UserHabitListResponseModel>> groupedHabits =
      <String, List<UserHabitListResponseModel>>{}.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    fetchPushtiPractise();
  }

  fetchPushtiPractise() async {
    if (await ApiServiceInterceptor.checkInternet()) {
      homeController.isDisplayInternetConnection.value = false;
    } else {
      homeController.isDisplayInternetConnection.value = true;
    }
    final cachedJson = await LocalDB().getPushtiPracticesCache() ?? '';

    if (cachedJson.isEmpty) {
      isLoading.value = true;
      await apiController.pushtiPracticesApi(
        languageId: homeController.selectedLanguageId.value,
        jwtToken: homeController.jwtToken.value,
      );
      isLoading.value = false;
    } else {
      final List<dynamic> jsonList = jsonDecode(cachedJson);
      apiController.pushtiPracticeResponseModel.value = jsonList
          .map((j) => PushtiPracticeApiResponseModel.fromJson(j))
          .toList();
    }
  }

  void groupByType() {
    Map<String, List<UserHabitListResponseModel>> temp = {};

    for (var item in userHabitListResponseModel) {
      final key = item.typeName ?? "Unknown";

      if (!temp.containsKey(key)) {
        temp[key] = [];
      }
      temp[key]!.add(item);
    }

    groupedHabits.value = temp;
  }

  Future<void> refreshPushtiPractices() async {
    print(
        'isDisplayInternetConnection: ${homeController.isDisplayInternetConnection.value}');

    await apiController.fetchVersionsList(
      isUserLoggedIn: true,
      jwtToken: homeController.jwtToken.value,
      isFromPushti: true,
    );
    print(
        'isDisplayInternetConnection: ${homeController.isDisplayInternetConnection.value}');
    await fetchPushtiPractise();
  }

  Future<void> launchUrlFunction(
    BuildContext context,
    String userPhoneNumber,
  ) async {
    final call = Uri(scheme: 'tel', path: userPhoneNumber);

    if (await canLaunchUrl(call)) {
      await launchUrl(call);
    } else {}
  }

  /// Fetch dimensions for multiple images in parallel.
  Future<List<ui.Image>> getImagesDimensions(List<String> urls) async {
    final futures = urls.map((u) => getImageDimensions(u)).toList();
    return Future.wait(futures);
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
}
