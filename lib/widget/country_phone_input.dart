import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../const/app_color.dart';
import '../const/app_constant.dart';
// import '../widget/country_picker.dart';
// import './countries.dart';
import '../localization/dynamic_app_localizations.dart';
import 'countries.dart';
import 'country_picker.dart';
import 'custom_text_widget.dart';

class PhoneNumberField extends StatefulWidget {
  final Rx<Country> selectedCountry;
  final TextEditingController phoneController;

  final String label;
  final RxBool showError;
  final RxString errorText;

  final Function(Country)? onCountryChanged;
  final Function(String)? onPhoneChanged;
  final Function(bool)? isValidPhoneNumber;

  const PhoneNumberField({
    super.key,
    required this.selectedCountry,
    required this.phoneController,
    required this.showError,
    required this.errorText,
    this.label = "Phone number",
    this.onCountryChanged,
    this.onPhoneChanged,
    this.isValidPhoneNumber,
  });

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  bool isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final borderColor = widget.showError.value
          ? AppColors.red
          : (isFocused ? AppColors.primaryColor : AppColors.black);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            fontColor: AppColors.primaryColor,
            textString: DynamicAppLocalizations.of(context).t("phone_number"),
            textSize: FontSize().appBar,
            numberOfLines: 1,
            isFontBold: false,
            isFontUnderline: false,
          ),
          const SizedBox(height: 6),

          /// ---- FIELD CONTAINER ----
          FocusScope(
            onFocusChange: (f) => setState(() => isFocused = f),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                border: Border.all(color: borderColor, width: 1),
                color: AppColors.white,
              ),
              child: Row(
                children: [
                  /// ---- COUNTRY PICKER ----
                  GestureDetector(
                    onTap: () async {
                      final selected = await showCountryPickerSheet(context);

                      if (selected != null) {
                        widget.selectedCountry.value = selected;
                        widget.phoneController.clear();
                        widget.onCountryChanged?.call(selected);
                        widget.showError.value = false;
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Text(
                            widget.selectedCountry.value.flag,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 6),
                          CustomTextWidget(
                            uiKey: const Key('lbl-phn-number'),
                            textString:
                                "+${widget.selectedCountry.value.dialCode}",
                            textSize: FontSize().regular,
                            isFontBold: false,
                            fontColor: AppColors.primaryColor,
                            isFontUnderline: false,
                          ),

                          const Icon(Icons.keyboard_arrow_down, size: 18),
                        ],
                      ),
                    ),
                  ),

                  /// ---- DIVIDER ----
                  Container(
                    width: 1,
                    height: 24,
                    color: borderColor.withValues(alpha: 0.6),
                  ),

                  /// ---- PHONE INPUT ----
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        controller: widget.phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: AppColors.primaryColor,

                        /// ---- INPUT FORMATTERS ----
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(
                            widget.selectedCountry.value.maxLength,
                          ),
                          FilteringTextInputFormatter.digitsOnly,
                          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            return newValue.copyWith(
                              text: newValue.text.toLowerCase(),
                            );
                          }),
                        ],

                        onChanged: (value) {
                          widget.onPhoneChanged?.call(value);
                          if (value.isEmpty) {
                            widget.errorText.value = DynamicAppLocalizations.of(
                              Get.context!,
                            ).t("enter_phone_number");
                            widget.showError.value = true;
                            widget.isValidPhoneNumber?.call(false);
                          } else if (value.length <
                              widget.selectedCountry.value.minLength) {
                            final String localizedError =
                                DynamicAppLocalizations.of(Get.context!).t(
                                  "phone_validation_min_length",
                                  params: {
                                    'minLength':
                                        widget.selectedCountry.value.minLength,
                                  },
                                );
                            widget.errorText.value = localizedError;
                            widget.showError.value = true;
                            widget.isValidPhoneNumber?.call(false);
                          } else {
                            widget.isValidPhoneNumber?.call(true);
                            widget.showError.value = false;
                          }
                        },

                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: DynamicAppLocalizations.of(
                            Get.context!,
                          ).t("enter_phone_number"),
                          hintStyle: TextStyle(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ---- ERROR MESSAGE ----
          if (widget.showError.value)
            Padding(
              padding: const EdgeInsets.only(top: 5, left: 18),
              child: CustomTextWidget(
                textString: widget.errorText.value,
                textSize: FontSize().xsmall,
                fontColor: AppColors.red,
                isFontBold: true,
                isFontUnderline: false,
              ),
            ),
        ],
      );
    });
  }
}
