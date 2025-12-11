import 'package:flutter/material.dart';
import 'package:get/get.dart';
// 1. MUST HAVE: Import the dropdown_search package
// import 'package:dropdown_search/dropdown_search.dart';
import 'package:shimmer/shimmer.dart';

import 'package:dropdown_button2/dropdown_button2.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';
import '../localization/dynamic_app_localizations.dart';
import '../utility/validators.dart';
import 'custom_text_widget.dart';

class CommonWidget {
  static shimmerEffect({
    required double height,
    double? width,
    AlignmentGeometry shimmerAlignment = Alignment.centerLeft,
  }) {
    return Align(
      alignment: shimmerAlignment,
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 238, 238, 238),
        highlightColor: const Color.fromRGBO(245, 245, 245, 1),
        child: Container(
          height: height,
          width: width,
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
            color: AppColors.grey,
          ),
        ),
      ),
    );
  }

  static parentContainer(BuildContext context, Widget child) {
    return SafeArea(
      top: true,
      child: Container(
        height: Get.height,
        width: Get.width,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor,
              // AppColors.blueLight2
            ],
          ),
        ),
        child: Container(
          height: Get.height,
          width: Get.width,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.white,
          ),
          child: child,
        ),
      ),
    );
  }

  customSearchableDropdown({
    required RxString selectedValue,
    required List<String> items,
    Key? fieldKey,
    String? labelText,
    String? hintText,
    String? validatorMessage,
    required VoidCallback setStateUpdate,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    bool isEnabled = true,
  }) {
    final TextEditingController searchController = TextEditingController();

    return Obx(
      () => Theme(
        data: Theme.of(Get.context!).copyWith(
          highlightColor: AppColors.primaryColor.withValues(alpha: 0.2),
          splashColor: AppColors.primaryColor.withValues(alpha: 0.1),
        ),
        child: DropdownButtonFormField2<String>(
          key: fieldKey,
          isExpanded: true,
          style: Get.textTheme.displayMedium,

          decoration: InputDecoration(
            filled: true,
            fillColor: isEnabled ? AppColors.transparent : AppColors.grey400,
            labelText: (selectedValue.value.isEmpty) ? "" : labelText,
            hintStyle: Get.textTheme.displayMedium,
            labelStyle: Get.textTheme.displayMedium,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: BorderSide(
                color: isEnabled ? AppColors.primaryColor : AppColors.grey200,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(color: AppColors.red),
            ),
            errorStyle: TextStyle(
              fontSize: FontSize().small,
              color: AppColors.red,
              // fontStyle: FontStyle.normal,
            ),
          ),

          value:
              selectedValue.value.isEmpty ||
                  !items.contains(selectedValue.value)
              ? null
              : selectedValue.value,

          hint: Text(hintText ?? ""),

          items: items.map((item) {
            return DropdownMenuItem(value: item, child: Text(item));
          }).toList(),

          validator:
              validator ??
              (value) {
                if (items.isEmpty) return null;
                return Validators().validateForIsRequired(
                  value,
                  validatorMessage.toString(),
                );
              },

          onChanged: !isEnabled
              ? null
              : (value) {
                  selectedValue.value = value!;
                  onChanged?.call(value);
                  setStateUpdate();
                },

          dropdownStyleData: DropdownStyleData(
            maxHeight: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              color: AppColors.white,
            ),
          ),

          menuItemStyleData: MenuItemStyleData(
            overlayColor: WidgetStateProperty.all(
              AppColors.primaryColor.withValues(alpha: 0.2),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: searchController,
            searchInnerWidgetHeight: 60,
            searchInnerWidget: Padding(
              padding: const EdgeInsets.all(8),
              child: SizedBox(
                height: 45,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: DynamicAppLocalizations.of(
                      Get.context!,
                    ).t("search"),

                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: AppColors.grey200),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: BorderSide(color: AppColors.grey200),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: const BorderSide(
                        color: AppColors.primaryColor,
                        width: 1,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: const BorderSide(color: AppColors.red),
                    ),

                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      borderSide: const BorderSide(
                        color: AppColors.red,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value!.toLowerCase().contains(
                searchValue.toLowerCase(),
              );
            },
          ),

          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              searchController.clear();
            }
          },
        ),
      ),
    );
  }

  customDropdown({
    required RxString selectedValue,
    required List<String> items,
    Key? fieldKey,
    String? labelText,
    String? hintText,
    String? validatorMessage,
    required VoidCallback setStateUpdate,
    String? Function(String?)? validator,
    Function(String)? onChanged,
    bool isEnabled = true,
  }) {
    return Obx(
      () => Theme(
        data: Theme.of(Get.context!).copyWith(
          focusColor: selectedValue.value.isEmpty
              ? AppColors.transparent
              : AppColors.primaryColor,
        ),
        child: ButtonTheme(
          alignedDropdown: true,
          // height: 60,
          child: DropdownButtonFormField<String>(
            key: fieldKey,
            isExpanded: true,
            initialValue:
                selectedValue.value.isEmpty ||
                    !(items.map((e) => e).toSet()).contains(selectedValue.value)
                ? null
                : selectedValue.value,
            decoration: InputDecoration(
              // enabled: isEnabled,
              filled: true,
              fillColor: isEnabled ? AppColors.transparent : AppColors.grey400,
              labelText: (selectedValue.value.isEmpty) ? "" : labelText,
              hintStyle: Get.textTheme.displayMedium,
              labelStyle: Get.textTheme.displayMedium,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(
                  color: AppColors.primaryColor,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  color: isEnabled ? AppColors.primaryColor : AppColors.grey200,
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColors.red),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: const BorderSide(color: AppColors.red),
              ),
              errorStyle: TextStyle(
                fontSize: FontSize().small,
                color: AppColors.red,
                // fontStyle: FontStyle.normal,
              ),
            ),
            iconEnabledColor: AppColors.primaryColor,
            iconDisabledColor: AppColors.grey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            icon: const Icon(Icons.arrow_drop_down),
            style: Get.textTheme.displayMedium,
            dropdownColor: AppColors.white,
            menuMaxHeight: 300,
            borderRadius: BorderRadius.circular(borderRadius),
            hint: (hintText != null && hintText.trim().isNotEmpty)
                ? CustomTextWidget(
                    textString: hintText,
                    textSize: FontSize().regular,
                    fontColor: AppColors.black,
                    isFontBold: false,
                    isFontUnderline: false,
                  )
                : null,
            items: items.toSet().toList().map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: CustomTextWidget(
                  textString: item,
                  textSize: FontSize().small,
                  isFontBold: false,
                  fontColor: AppColors.black,
                  isFontUnderline: false,
                  fontStyle: FontStyle.normal,
                  numberOfLines: 2,
                ),
              );
            }).toList(),
            validator:
                validator ??
                (value) {
                  if (items.isEmpty) {
                    return null;
                  }
                  return Validators().validateForIsRequired(
                    value,
                    validatorMessage.toString(),
                  );
                },
            onChanged: !isEnabled
                ? null
                : (newValue) {
                    selectedValue.value = newValue!;
                    onChanged?.call(newValue); //
                    setStateUpdate();
                  },
          ),
        ),
      ),
    );
  }
}

showCustomSnackBar(String? title, String? message, bool isSuccess) async {
  return Get.showSnackbar(
    GetSnackBar(
      key: const Key('get-snackbar'),
      titleText: CustomTextWidget(
        textString: title!,
        textSize: FontSize().medium,
        isFontBold: true,
        fontColor: AppColors.white,
        isFontUnderline: false,
        fontStyle: FontStyle.normal,
        numberOfLines: 2,
      ),
      messageText: CustomTextWidget(
        textString: DynamicAppLocalizations.of(
          Get.context!,
        ).t(message.toString()),
        textSize: FontSize().regular,
        isFontBold: true,
        fontColor: AppColors.white,
        isFontUnderline: false,
        fontStyle: FontStyle.normal,
        numberOfLines: 2,
      ),
      backgroundColor: isSuccess ? AppColors.green : AppColors.red,
      icon: IconButton(
        icon: const Icon(Icons.error, color: AppColors.white),
        onPressed: () {
          Get.closeCurrentSnackbar();
        },
      ),
      margin: const EdgeInsets.all(15),
      borderRadius: 20,
      isDismissible: true,
      duration: const Duration(seconds: 3),
    ),
  );
}
