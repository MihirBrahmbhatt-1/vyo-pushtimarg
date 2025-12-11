import 'package:get/get.dart';

import '../../../controller/home_controller.dart';

class HomeViewController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HomeController homeController = Get.put(HomeController());

  RxBool isLoading = false.obs;
  RxBool canPop = false.obs;

  loadApi() async {
    isLoading.value = true;
    await homeController.reload();
    isLoading.value = false;
  }
}
