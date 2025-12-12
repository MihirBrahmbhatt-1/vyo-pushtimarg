import 'package:get/get.dart';
import '../../controller/home_controller.dart';
import '../../utility/local_db.dart';
import '../../navigation/pages.dart';

class SettingsViewController extends GetxController {
  HomeController homeController = Get.put(HomeController());

  void logoutUser() async {
    await LocalDB().setIsLoggedIn(false);
    await LocalDB().setIsUserExists(false);
    await LocalDB().setIsUserProfileCompleted(false);
    await LocalDB().setJwtToken('');
    await LocalDB().setDashboardVersion('');
    await LocalDB().setDashboardSliderVersion('');
    await LocalDB().setDashboardHtmlCache('');
    await LocalDB().setDashboardImageSliderCache('');
    await LocalDB().setLabelLanguageVersion('');
    await LocalDB().setLanguageLabelsCache('');
    await LocalDB().setUserPassword('');
    await LocalDB().removeJwtToken();
    homeController.jwtToken.value = '';
    homeController.isLoggedIn.value = false;
    homeController.selectedIndex.value = 0;
    Get.offAllNamed(Routes.signin);
  }
}
