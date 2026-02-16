import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../const/logger.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../utility/common_functions.dart';
import '../../utility/validators.dart';
import '../../widget/common_widget.dart';
import '../../widget/country_phone_input.dart';
import '../../widget/custom_button_widget.dart';
import '../../widget/custom_no_internet_widget.dart';
import '../../widget/custom_text_field_widget.dart';
import '../../widget/custom_text_widget.dart';
import 'contact_us_view_controller.dart';

class ContactUsView extends GetView<ContactUsViewController> {
  const ContactUsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ContactUsViewController());
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
            appBar: AppBar(
              foregroundColor: AppColors.white,
              backgroundColor: AppColors.primaryColor,
              centerTitle: true,
              title: CustomTextWidget(
                textString: DynamicAppLocalizations.of(context).t("contact_us"),
                textSize: FontSize().appBar,
                isFontBold: false,
                fontColor: AppColors.white,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
            body: controller.homeController.isDisplayInternetConnection.value ?
                  Center(
                    child: CustomNoInternetWidget(
                        onPressed: () async {
                          await checkInternetStatus(
                            onConnected: () async {
                              controller.homeController.isDisplayInternetConnection.value = false;
                              controller.isLoading.value = true;
                              await controller.apiController.fetchVersionsList(
                                isUserLoggedIn: false,
                                jwtToken: '',
                              );
                              // controller.selectedQueryName.value = '';
                              // controller.selectedQueryId.value = '';
                              // await controller.fetchQueryType();
                              controller.isLoading.value = false;
                            },
                            onNoConnection: () {
                              controller.homeController.isDisplayInternetConnection.value = true;
                            },
                          );
                        },
                      ),
                  )
                   :  SingleChildScrollView(
              child: Form(
                key: controller.contactUsFormKey.value,
                 autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Center(
                              child: CustomTextWidget(
                                textString:
                                    DynamicAppLocalizations.of(Get.context!)
                                        .t("get_in_touch"),
                                textSize: FontSize().large,
                                fontColor: AppColors.black,
                                isFontUnderline: false,
                                numberOfLines: 10,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            PhoneNumberField(
                              selectedCountry: controller.selectedCountry,
                              phoneController:
                                  controller.phoneNumberTextController.value,
                              showError: controller.showPhoneError,
                              errorText: controller.phoneErrorMessage,
                              onCountryChanged: (country) {
                                talker.info("Changed to: ${country.name}");
                              },
                              onPhoneChanged: (phone) {
                                talker.info("Updated phone: $phone");
                              },
                              isValidPhoneNumber: (isValid) {
                                talker.info("Valid phone: $isValid");
                                controller.isValidePhoneNumber.value = isValid;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            controller.isLoadingQueryList.value == true
                                ? Center(
                                    child: CommonWidget.shimmerEffect(
                                      height: 50,
                                      width: Get.width * 0.94,
                                      shimmerAlignment: Alignment.center,
                                    ),
                                  )
                                : CommonWidget().customSearchableDropdown(
                                      selectedValue: controller.selectedQueryName,
                                      items: controller.queryNames,
                                      labelText:
                                          DynamicAppLocalizations.of(Get.context!)
                                              .t("query_type"),
                                      hintText: DynamicAppLocalizations.of(
                                        Get.context!,
                                      ).t("select_query_type"),
                                      validatorMessage:
                                          DynamicAppLocalizations.of(
                                        Get.context!,
                                      ).t("query_type"),
                                      onChanged: (value) {
                                        controller.selectedQueryName.value =
                                            value;
                                        controller.selectedQueryId.value =
                                            controller.queryNameToId[value] ?? "";
                                      },
                                      setStateUpdate: () => {},
                                    ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormFieldWidget(
                              controller: controller.nameController.value,
                              isOutlineBorder: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              label:
                                  DynamicAppLocalizations.of(context).t("name"),
                              style: TextStyle(),
                              enabledColor: AppColors.grey400,
                              cursorColor: AppColors.primaryColor,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return DynamicAppLocalizations.of(context)
                                      .t("name_is_required");
                                }
                                return null;
                              },
                              onChanged: (val) {},
                              inputFormatters: [],
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormFieldWidget(
                              controller: controller.emailTextController.value,
                              isOutlineBorder: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              label:
                                  "${DynamicAppLocalizations.of(context).t("email")} ${DynamicAppLocalizations.of(context).t("optional")}",
                              style: TextStyle(),
                              enabledColor: AppColors.grey400,
                              cursorColor: AppColors.primaryColor,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return Validators().dynamicIsRequiredValidator(
                                      DynamicAppLocalizations.of(context)
                                          .t("email"));
                                }
                                if (!GetUtils.isEmail(v.trim())) {
                                  return DynamicAppLocalizations.of(context)
                                      .t("enter_valid_email");
                                }
                                return null;
                              },
                              onChanged: (val) {},
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r"[ ]")),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextFormFieldWidget(
                              controller:
                                  controller.queryDescriptionTextController.value,
                              isOutlineBorder: true,
                              contentPadding: const EdgeInsets.all(10.0),
                              label: DynamicAppLocalizations.of(context)
                                  .t("description"),
                              maxLines: 3,
                              maxLength: 1000,
                              enabled: true,
                              style: TextStyle(),
                              enabledColor: AppColors.grey400,
                              cursorColor: AppColors.primaryColor,
                              autoValidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onChanged: (value) {},
                              validator: (value) {
                                if (value!.trim().isEmpty) {
                                  return Validators().dynamicIsRequiredValidator(
                                      DynamicAppLocalizations.of(context)
                                          .t("description"));
                                } else if (value.replaceAll(' ', '').length < 8) {
                                  return Validators().dynamicIsRequiredValidator(
                                      DynamicAppLocalizations.of(
                                    Get.context!,
                                  ).t("minimum_eight_characters"));
                                } else {
                                  return null;
                                }
                              },
                            ),
                            const SizedBox(
                              height: 24,
                            ),
          
                            /// Submit Button
                            Center(
                              child: CustomElevatedButton(
                                isLoading: controller.isLoading.value,
                                title: DynamicAppLocalizations.of(context)
                                    .t("submit"),
                                width: Get.width * 0.5,
                                onPressed: () async {
                                  controller.validatePhone();
                                  if (!controller.isLoading.value &&
                                      controller
                                          .contactUsFormKey.value.currentState!
                                          .validate() && !controller.isLoadingQueryList.value) {
                                    controller.submitContactUs();
                                  }
                                },
                                backgroundColor: AppColors.primaryColor,
                                textColor: AppColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
