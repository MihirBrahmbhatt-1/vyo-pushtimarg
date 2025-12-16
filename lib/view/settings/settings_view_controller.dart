import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../utility/common_functions.dart';

class SettingsViewController extends GetxController {
  HomeController homeController = Get.put(HomeController());

  void logoutUser() async {
    clearAppDataAndLogout();
  }
}
