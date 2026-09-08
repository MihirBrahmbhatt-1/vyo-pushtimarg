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
  return showModalBottomSheet<Country>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (_) => const _CountryPickerSheetContent(),
  );
}

// ROOT CAUSE (shared country-code picker bug): this content used to be built
// directly inside showModalBottomSheet's `builder` callback, with the search
// text and the filtered list held as plain local variables of that callback
// (only re-created via a nested StatefulBuilder.setState). `builder` is
// re-invoked by the framework whenever the sheet route's dependencies change
// (e.g. MediaQuery.viewInsets when the keyboard opens/closes on Done/OK), so
// every keyboard dismissal recreated a brand-new TextEditingController and
// reset `filtered` to the full list, wiping out whatever the user had typed.
// Moving the search text + filtered list into this dedicated StatefulWidget's
// State keeps them alive across those rebuilds.
class _CountryPickerSheetContent extends StatefulWidget {
  const _CountryPickerSheetContent();

  @override
  State<_CountryPickerSheetContent> createState() =>
      _CountryPickerSheetContentState();
}

class _CountryPickerSheetContentState
    extends State<_CountryPickerSheetContent> {
  final TextEditingController _searchCtrl = TextEditingController();
  final ApiController _apiController = Get.put(ApiController());
  late List<Country> _filtered;

  @override
  void initState() {
    super.initState();
    _filtered = _apiController.countryCodeList.toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _applyFilter(String value) {
    setState(() {
      _filtered = _apiController.countryCodeList.where((c) {
        return c.name.toLowerCase().contains(value.toLowerCase()) ||
            c.dialCode.contains(value);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                controller: _searchCtrl,
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
                onChanged: _applyFilter,
                onFieldSubmitted: _applyFilter,
              ),

              const SizedBox(height: 16),

              // Country List
              Expanded(
                child: ListView.separated(
                  itemCount: _filtered.length,
                  separatorBuilder: (_, __) => Divider(height: 1),
                  itemBuilder: (_, index) {
                    final country = _filtered[index];

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
  }
}
