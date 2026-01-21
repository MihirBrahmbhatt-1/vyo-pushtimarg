import 'package:get/get.dart';
import '../../const/logger.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';

class SettingsViewController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  ApiController apiController = Get.put(ApiController());

  RxBool isLoading = false.obs;

  void logoutUser() async {
    try {
      isLoading.value = true;
      apiController.logoutUser(
        deviceId: homeController.userDeviceIdString.value,
        jwtToken: homeController.jwtToken.value,
      );
      isLoading.value = false;
    } catch (e) {
      talker.error('Error in _perforLogout func: ${e.toString()}');
    }
  }
}
