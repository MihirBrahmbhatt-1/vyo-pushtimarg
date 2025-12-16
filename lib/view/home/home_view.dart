import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../../const/app_assets.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';

import '../../localization/dynamic_app_localizations.dart';
import '../../widget/app_drawer.dart';
import '../../widget/custom_icon_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../../widget/home_custom_scaffold_widget.dart';

import '../dashboard/dashboard_view.dart';
import '../category_list/category_list_view.dart';
import '../habit/habit_view.dart';
import '../settings/settings_view.dart';

import '../survey/questions_screen.dart';
import 'home_view_controller.dart';

class HomeView extends GetView<HomeViewController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeViewController());

    return Obx(
      () => HomeCustomScaffoldWidget(
        isBack: false,
        drawer: controller.homeController.selectedIndex.value == 0
            ? AppDrawer()
            : null,
        actions: controller.homeController.selectedIndex.value == 0
            ? [
                IconButton(onPressed: () {
                  controller.displayPhoneNumberInfo();
                }, icon: Icon(Icons.phone)),
                const SizedBox(width: 10),
              ]
            : [],

        floatingActionButton: null,

        centerTitle: true,
        title: _titleText(),

        body: _tabView(controller.homeController.selectedIndex.value),

        bottomNavigationBar: Obx(() => _animatedBottomBar()),
      ),
    );
  }

  Widget _titleText() {
    switch (controller.homeController.selectedIndex.value) {
      case 0:
        return CustomTextWidget(
          textString: 'VYO World',
          textSize: FontSize().appBar,
          fontColor: AppColors.white,
        );
      case 1:
        return CustomTextWidget(
          textString: DynamicAppLocalizations.of(Get.context!).t("category"),
          textSize: FontSize().appBar,
          fontColor: AppColors.white,
        );
      case 2:
        return CustomTextWidget(
          textString: DynamicAppLocalizations.of(Get.context!).t("practice"),
          textSize: FontSize().appBar,
          fontColor: AppColors.white,
          fontStyle: FontStyle.normal,
        );
      case 3:
        return CustomTextWidget(
          textString: DynamicAppLocalizations.of(Get.context!).t("menu"),
          textSize: FontSize().appBar,
          fontColor: AppColors.white,
          fontStyle: FontStyle.normal,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _tabView(int index) {
    switch (index) {
      case 0:
        return const DashboardView();
      case 1:
        return const CategoryListView();
      case 2:
        return const HabitView();
      case 3:
        return const SettingsView();
    }
    return const DashboardView();
  }

  Widget _animatedBottomBar() {
    final selectedIndex = controller.homeController.selectedIndex.value;

    return BottomNavigationBar(
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.white,
      unselectedItemColor: Colors.white70,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: TextStyle(fontStyle: FontStyle.normal),
      unselectedLabelStyle: TextStyle(fontStyle: FontStyle.normal),
      onTap: (index) {
        HapticFeedback.mediumImpact();
        if (index == 2) {
          if (controller.homeController.isUserSurveyCompleted.value == false) {
            Get.to(() => QuestionsScreen());
            return;
          }
        }
        if (selectedIndex == index) return;
        controller.homeController.selectedIndex.value = index;
      },

      items: [
        _animatedItem(
          index: 0,
          icon: Icon(AppIcons.homeIcon),
          label: DynamicAppLocalizations.of(Get.context!).t("home"),
        ),
        _animatedItem(
          index: 1,
          icon: Icon(Icons.category),
          label: DynamicAppLocalizations.of(Get.context!).t("category"),
        ),
        _animatedItem(
          index: 2,
          icon: CustomImageAssetWidget(
            imagePath: AppIcons.prayImg,
            height: 40,
            width: 30,
            imageColor: AppColors.white,
          ),
          label: DynamicAppLocalizations.of(Get.context!).t("practice"),
        ),
        _animatedItem(
          index: 3,
          icon: Icon(AppIcons.settingsOutlinedIcon),
          label: DynamicAppLocalizations.of(Get.context!).t("menu"),
        ),
      ],
    );
  }

  BottomNavigationBarItem _animatedItem({
    required int index,
    required Widget icon,
    required String label,
  }) {
    final selected = controller.homeController.selectedIndex.value == index;

    return BottomNavigationBarItem(
      label: label,
      icon: AnimatedScale(
        scale: selected ? 1.25 : 1.0,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: icon,
      ),
    );
  }
}
