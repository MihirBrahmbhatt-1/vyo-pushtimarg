import 'package:get/get.dart';
import '../model/dynamic_label.dart';
import '../utility/local_db.dart';
import 'home_controller.dart';

class DynamicLocaleController extends GetxController {
  HomeController homeController = Get.put(HomeController());
  final labels = <String, String>{}.obs;
final RxString versionString = ''.obs;
  void setLabels(List<DynamicLabel> list) async {
    labels.clear();
    for (var item in list) {
       if (item.key == "@@labels_version@@") {
        versionString.value = item.value;
        homeController.labelLanguageVersion.value = item.value;
        await LocalDB().setLabelLanguageVersion(item.value.toString());
        await LocalDB().reloadSharedPref();
        await homeController.reload();
        continue;
      }
      labels[item.key] = item.value;
    }
    update();
  }

  String trApi(String key, {Map<String, dynamic>? params}) {
    if (!labels.containsKey(key)) return key; // fallback to key itself
    
    String value = labels[key]!;

    if (params != null) {
      params.forEach((pKey, pValue) {
        value = value.replaceAll("\${$pKey}", pValue.toString());
      });
    }

    return value;
  }
}
