import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../model/category_list_response_model.dart';

class SubCategoryViewController extends GetxController with WidgetsBindingObserver {

  late CategoryListResponseModel categoryList;
  late List<SubCategories> subCategory = [];

  RxString appBarTitle = ''.obs;

  @override
  void onInit() async {
    WidgetsBinding.instance.addObserver(this);
    super.onInit();
    fetchSubCategoryList();
  }

  fetchSubCategoryList() async {
     categoryList = Get.arguments['categoryObj'];
     subCategory = categoryList.subCategories!;
     appBarTitle.value = Get.arguments['title'];

  }
}