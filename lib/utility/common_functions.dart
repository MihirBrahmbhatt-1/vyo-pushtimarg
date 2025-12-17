import 'package:get/get.dart';

import '../controller/home_controller.dart';
import '../navigation/pages.dart';
import 'api_service_interceptor.dart';
import 'local_db.dart';

clearAppDataAndLogout() async {
  HomeController homeController = Get.put(HomeController());
  ApiServiceInterceptor.isLoggingOut = true;
  ApiServiceInterceptor.cancelRequest();
  await LocalDB().setIsLoggedIn(false);
  await LocalDB().setIsUserExists(false);
  await LocalDB().setIsUserProfileCompleted(false);
  await LocalDB().setIsUserSurveyCompleted(false);
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
   ApiServiceInterceptor.isLoggingOut = false;
}
