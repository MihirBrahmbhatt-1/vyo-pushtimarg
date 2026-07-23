import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';
import '../localization/dynamic_app_localizations.dart';
import '../controller/api_controller.dart';
import 'countries.dart';
import 'custom_text_field_widget.dart';
import 'custom_text_widget.dart';

Future<Country?> showCountryPickerSheet(BuildContext context) async {
  TextEditingController searchCtrl = TextEditingController();
  final apiController = Get.find<ApiController>();

  return showModalBottomSheet<Country>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) {
      List<Country> filtered = apiController.countryCodeList.toList();

      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                height: Get.height * 0.75,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextWidget(
                      textString: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("select_country"),
                      textSize: FontSize().large,
                      isFontBold: true,
                      fontColor: AppColors.primaryColor,
                      isFontUnderline: false,
                    ),

                    const SizedBox(height: 16),
                    CustomTextFormFieldWidget(
                      controller: searchCtrl,
                      isOutlineBorder: true,
                      contentPadding: const EdgeInsets.all(15.0),
                      keyboardType: TextInputType.text,
                      cursorColor: AppColors.primaryColor,
                      hintText: '',
                      label: DynamicAppLocalizations.of(
                        Get.context!,
                      ).t("search_by_country_or_code"),
                      enabled: true,
                      autoValidateMode: AutovalidateMode.onUserInteraction,
                      style: Get.textTheme.displayMedium,
                      textInputAction: TextInputAction.done,
                      inputFormatters: [],
                      prefixIcon: const Icon(Icons.search),

                      onChanged: (value) {
                        setState(() {
                          filtered = apiController.countryCodeList.where((c) {
                            return c.name.toLowerCase().contains(
                                  value.toLowerCase(),
                                ) ||
                                c.dialCode.contains(value);
                          }).toList();
                        });
                      },
                    ),

                    const SizedBox(height: 16),

                    // Country List
                    Expanded(
                      child: ListView.separated(
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => Divider(height: 1),
                        itemBuilder: (_, index) {
                          final country = filtered[index];

                          return ListTile(
                            leading: CustomTextWidget(
                              textString: country.flag,
                              textSize: FontSize().xlarge,
                              isFontBold: false,
                              fontColor: AppColors.primaryColor,
                              isFontUnderline: false,
                            ),
                            title: CustomTextWidget(
                              fontColor: AppColors.primaryColor,
                              textString: country.name.toString(),
                              isFontBold: false,
                              isFontUnderline: false,
                              textSize: FontSize().appBar,
                              fontStyle: FontStyle.normal,
                            ),
                            subtitle: CustomTextWidget(
                              fontColor: AppColors.primaryColor,
                              textString: "+${country.dialCode.toString()}",
                              isFontBold: false,
                              isFontUnderline: false,
                              textSize: FontSize().appBar,
                              fontStyle: FontStyle.normal,
                            ),
                            onTap: () {
                              Navigator.pop(context, country);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
