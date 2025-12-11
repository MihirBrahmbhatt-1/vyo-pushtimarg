import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageController extends GetxController {
  static const String key = "app_language";

  // reactive locale
  Rx<Locale> locale = const Locale("en").obs; // default English

  @override
  void onInit() {
    super.onInit();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(key) ?? "en";
    locale.value = Locale(code);
  }

  Future<void> setLanguage(String code) async {
    locale.value = Locale(code);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, code);

    // Updates app locale instantly
    Get.updateLocale(Locale(code));
  }
}
