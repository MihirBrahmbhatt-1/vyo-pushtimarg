import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../model/user_habit_list_response_model.dart';

class HabitViewController extends GetxController with WidgetsBindingObserver {
  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final ScrollController scrollController = ScrollController();
  RxBool isShimmerLoading = false.obs;

  RxList<UserHabitListResponseModel> userHabitListResponseModel =
      <UserHabitListResponseModel>[].obs;
  RxMap<String, List<UserHabitListResponseModel>> groupedHabits =
      <String, List<UserHabitListResponseModel>>{}.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    fetchHabitsApi();
  }

  fetchHabitsApi() async {
    isShimmerLoading.value = true;
    apiController.userHabitListResponseModel.value = [];
    await apiController.fetchUserHabits(
      languageId: homeController.selectedLanguageId.value,
      jwtToken: homeController.jwtToken.value,
    );
    userHabitListResponseModel.value = apiController.userHabitListResponseModel;
    groupByType();
    isShimmerLoading.value = false;
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

  Future<void> refreshHabitsApi() async {
    await fetchHabitsApi();
  }

  Future<void> launchUrlFunction(
    BuildContext context,
    String userPhoneNumber,
  ) async {
    final call = Uri(scheme: 'tel', path: userPhoneNumber);

    if (await canLaunchUrl(call)) {
      await launchUrl(call);
    } else {
    }
  }
}
