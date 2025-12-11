import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../controller/language_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../utility/local_db.dart';
import '../../widget/custom_button_widget.dart';
import '../../widget/custom_text_widget.dart';
import '../login/login_view.dart';
import 'language_selection_view_controller.dart';

class LanguageSelectionView extends GetView<LanguageSelectionViewController> {
  const LanguageSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final langController = Get.find<LanguageController>();
    Get.put(LanguageSelectionViewController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.applySavedLanguage(langController.locale.value.languageCode);
    });

    return Scaffold(
      appBar: AppBar(
        title: CustomTextWidget(
          fontColor: AppColors.white,
          textString: AppLocalizations.of(Get.context!)!.selectLanguage,
          isFontBold: false,
          isFontUnderline: false,
          textSize: FontSize().appBar,
          fontStyle: FontStyle.normal,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: 50,
                ),
                child: Column(
                  children: [
                    CustomTextWidget(
                      fontColor: AppColors.primaryColor,
                      textString: 'Choose your prefered app Language',
                      isFontBold: false,
                      isFontUnderline: false,
                      textSize: FontSize().appBar,
                      fontStyle: FontStyle.normal,
                    ),
                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.languageListData.length,
                        itemBuilder: (_, index) {
                          final lang = controller.languageListData[index];

                          /// CHECK IF THIS LANG IS SELECTED BY GUID
                          final bool isSelected =
                              controller.languageId.value == lang.id.toString();

                          return Card(
                            color: isSelected
                                ? AppColors.primaryColor
                                : AppColors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.primaryColor
                                    : AppColors.grey200,
                                width: 1,
                              ),
                            ),
                            child: Theme(
                              data: Theme.of(context).copyWith(
                                splashColor: AppColors.transparent,
                                highlightColor: AppColors.transparent,
                                hoverColor: AppColors.transparent,
                              ),
                              child: ListTile(
                                title: CustomTextWidget(
                                  fontColor: isSelected
                                      ? AppColors.white
                                      : AppColors.black,
                                  textString: lang.languageName.toString(),
                                  isFontBold: isSelected ? true : false,
                                  isFontUnderline: false,
                                  textSize: FontSize().regular,
                                  fontStyle: FontStyle.normal,
                                ),

                                trailing: isSelected
                                    ? const Icon(
                                        Icons.check_circle,
                                        color: AppColors.white,
                                      )
                                    : const Icon(Icons.circle_outlined),
                                onTap: () async {
                                  await langController.setLanguage(
                                    lang.languageCode.toString(),
                                  );
                                  controller.applySavedLanguage(
                                    lang.languageCode.toString(),
                                  );
                                  controller.languageId.value = lang.id
                                      .toString();
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: CustomElevatedButton(
          backgroundColor: controller.languageId.value.isNotEmpty ? AppColors.primaryColor : AppColors.grey,
          title: 'Submit',
          onPressed: () async {
            if (controller.languageId.value.isNotEmpty) {
              await LocalDB().setLanguageId(controller.languageId.value);
              controller.homeController.selectedLanguageId.value =
                  controller.languageId.value;
              final langController = Get.find<LanguageController>();
              await langController.loadLanguage();
              await controller.homeController.reload();
              await controller.submitLanguageSelection(
                controller.languageId.value,
              );

              Get.offAll(() => const LoginView());
            }
          },
          height: 40,
          textColor: AppColors.white,
        ),
      ),
    );
  }
}
