import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../utility/local_db.dart';
import '../home/home_view.dart';
import '../language/language_selection_view.dart';
import '../login/login_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 400), () {
          checkStatus();
        });
      }
    });
  }

  checkStatus() async {
    ApiController apiController = Get.put(ApiController());
    HomeController homeController = Get.put(HomeController());
    bool? isLoggedIn = await LocalDB().getIsLoggedIn();
    bool? isInitialLanguageSelected = await LocalDB().getIsLanguageSelected();

    if (isLoggedIn == null || !isLoggedIn) {
      await apiController.fetchVersionsList(
        isUserLoggedIn: false,
        jwtToken: '',
      );

      if (isInitialLanguageSelected == true) {
        Get.offAll(() => LoginView());
      } else {
        Get.offAll(() => LanguageSelectionView());
      }
    } else {
      await apiController.fetchVersionsList(
        isUserLoggedIn: true,
        jwtToken: homeController.jwtToken.value,
      );

      await apiController.getUserProfileByPhoneNumber(
        phoneNumber: homeController.userPhoneNumber.value,
        jwtToken: homeController.jwtToken.value,
      );
        Get.offAll(() => const HomeView());
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Image.asset(
            "assets/images/app_logo.png",
            width: 160,
            height: 160,
          ),
        ),
      ),
    );
  }
}
