import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'const/theme.dart';
import 'controller/dynamic_locale_controller.dart';
import 'controller/home_controller.dart';
import 'controller/language_controller.dart';
import 'l10n/app_localizations.dart';
import 'localization/dynamic_app_localizations.dart';
import 'navigation/pages.dart';
import 'utility/network_service.dart';

void main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    Get.put(HomeController());
    Get.put(DynamicLocaleController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    Get.put(NetworkService(), permanent: true);

    runApp(MyApp());
  }, (exception, stackTrace) async {});
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageController controller = Get.put(LanguageController());
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'VYO',
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splash,
      locale: controller.locale.value,
      fallbackLocale: const Locale('en'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: [
        DynamicAppLocalizationsDelegate(),
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      getPages: Pages.routes,
      theme: Themes.lightTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
