import 'package:get/get.dart';

import '../controller/dynamic_locale_controller.dart';

extension ApiLocalizationExtension on String {
  String trApi({Map<String, dynamic>? params}) {
    final ctrl = Get.find<DynamicLocaleController>();
    return ctrl.trApi(this, params: params);
  }
}
