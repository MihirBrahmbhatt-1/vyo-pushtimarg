import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/dynamic_locale_controller.dart';

class DynamicAppLocalizations {
  final Locale locale;

  DynamicAppLocalizations(this.locale);

  static DynamicAppLocalizations of(BuildContext context) {
    return Localizations.of<DynamicAppLocalizations>(
      context,
      DynamicAppLocalizations,
    )!;
  }

  /// Main translation function
  String t(String key, {Map<String, dynamic>? params}) {
    final dyn = Get.find<DynamicLocaleController>();
    return dyn.trApi(key, params: params);
  }
}

class DynamicAppLocalizationsDelegate
    extends LocalizationsDelegate<DynamicAppLocalizations> {
  const DynamicAppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => true; // API supports any language

  @override
  Future<DynamicAppLocalizations> load(Locale locale) async {
    return DynamicAppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => true;
}
