import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_assets.dart';
import '../const/app_color.dart';

// ignore: must_be_immutable
class HomeCustomScaffoldWidget extends StatelessWidget {
  final List<Widget>? actions;
  final bool? isBack;
  final PreferredSizeWidget? bottom;
  final Widget? title;
  final Widget? body;
  final Widget? floatingActionButton;
  final bool? centerTitle;
  final Widget? bottomNavigationBar;
  final bool? keyvalue;
  final bool? avoidResize;

  /// 👇 NEW — Support Drawer
  final Widget? drawer;

  const HomeCustomScaffoldWidget({
    super.key,
    this.actions,
    this.isBack,
    this.title,
    this.body,
    this.bottom,
    this.centerTitle,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.keyvalue,
    this.drawer,
    this.avoidResize = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: drawer,
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: avoidResize,

      bottomNavigationBar: bottomNavigationBar,

      appBar: AppBar(
        centerTitle: centerTitle ?? false,
        foregroundColor: AppColors.white,
        backgroundColor: AppColors.primaryColor,

        title: title ?? const SizedBox(),

        bottom: bottom,

        leading: isBack == true
            ? IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Platform.isIOS ? AppIcons.backArrowiOS : AppIcons.backArrow,
                  color: AppColors.white,
                ),
              )
            : null, // important change so drawer button can appear automatically

        actions: actions,
      ),

      floatingActionButton: floatingActionButton,
      body: body,
    );
  }
}
