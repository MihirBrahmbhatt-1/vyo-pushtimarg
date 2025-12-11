import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../widget/custom_text_widget.dart';
import 'questions_model.dart';

class QuestionsPage extends StatelessWidget {
  final Question question;
  final dynamic value;
  final void Function(String, String) onYesNo;
  final void Function(String, String) onToggleMulti;
  final void Function(String, String) onSingleSelect;
  final void Function(String, String) onText;
  final void Function(String, String) onNumber;
  final void Function(String, String) onSingleImage;
  final void Function(String, String) onToggleMultiImage;
  final Future<void> Function(BuildContext, String) onPickDateTime;
  final Future<void> Function(BuildContext, String) onPickDate;
  final Future<void> Function(BuildContext, String) onPickTime;
  final bool showError;

  const QuestionsPage({
    super.key,
    required this.question,
    this.value,
    required this.onYesNo,
    required this.onToggleMulti,
    required this.onSingleSelect,
    required this.onText,
    required this.onNumber,
    required this.onSingleImage,
    required this.onToggleMultiImage,
    required this.onPickDateTime,
    required this.onPickDate,
    required this.onPickTime,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget input;
    Widget validationMessage = const SizedBox.shrink();

    if (showError && question.isRequired) {
      validationMessage = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: CustomTextWidget(
          textString: DynamicAppLocalizations.of(
            Get.context!,
          ).t("please_answer_current_question"),
          textSize: FontSize().regular,
          fontColor: AppColors.red,
          isFontBold: true,
        ),
      );
    }

    Widget questionHeader = Padding(
      padding: const EdgeInsets.only(
        bottom: 24.0,
        left: 16,
        right: 16,
        top: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: CustomTextWidget(
                  fontColor: AppColors.black,
                  textString: DynamicAppLocalizations.of(
                    Get.context!,
                  ).t(question.title.toString()),
                  isFontBold: false,
                  isFontUnderline: false,
                  textSize: FontSize().medium,
                  fontStyle: FontStyle.normal,
                  numberOfLines: 20,
                ),
              ),
            ],
          ),
          if (question.subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CustomTextWidget(
                fontColor: AppColors.black,
                textString: DynamicAppLocalizations.of(
                  Get.context!,
                ).t(question.subtitle.toString()),
                isFontBold: false,
                isFontUnderline: false,
                textSize: FontSize().small,
                fontStyle: FontStyle.normal,
                numberOfLines: 30,
              ),
            ),
        ],
      ),
    );

    Widget wrapWithOptionalErrorBorder(Widget child) {
      return child;
    }

    switch (question.type) {
      case QuestionType.yesNo:
        input = wrapWithOptionalErrorBorder(
          YesNoSelector(
            question: question,
            selected: value as String?,
            onChanged: (v) => onYesNo(question.id, v),
          ),
        );
        break;
      case QuestionType.multiSelect:
        input = wrapWithOptionalErrorBorder(
          MultiSelectList(
            question: question,
            selected: (value is Set<String>) ? value : const <String>{},
            onToggle: (optId) => onToggleMulti(question.id, optId),
          ),
        );
        break;
      case QuestionType.singleSelect:
        input = wrapWithOptionalErrorBorder(
          SingleSelectList(
            question: question,
            selected: value as String?,
            onSelect: (optId) => onSingleSelect(question.id, optId),
          ),
        );
        break;
      case QuestionType.text:
        input = TextFieldSimple(
          initial: value as String?,
          placeholder: question.placeholder,
          onChanged: (txt) => onText(question.id, txt),
          showError: showError && question.isRequired,
        );
        break;
      case QuestionType.textarea:
        input = TextAreaField(
          initial: value as String?,
          placeholder: question.placeholder,
          onChanged: (txt) => onText(question.id, txt),
          showError: showError && question.isRequired,
        );
        break;
      case QuestionType.number:
        input = NumberField(
          initial: value as String?,
          placeholder: question.placeholder,
          onChanged: (numStr) => onNumber(question.id, numStr),
          showError: showError && question.isRequired,
        );
        break;
      case QuestionType.dateTime:
      case QuestionType.date:
      case QuestionType.time:
        input = wrapWithOptionalErrorBorder(
          _buildDateTimePicker(question.type, context),
        );
        break;
      case QuestionType.singleImage:
        input = wrapWithOptionalErrorBorder(
          SingleImageSelector(
            question: question,
            selected: value as String?,
            onSelect: (optId) => onSingleImage(question.id, optId),
          ),
        );
        break;
      case QuestionType.multiImage:
        input = wrapWithOptionalErrorBorder(
          MultiImageSelector(
            question: question,
            selected: (value is Set<String>) ? value : const <String>{},
            onToggle: (optId) => onToggleMultiImage(question.id, optId),
          ),
        );
        break;
      case QuestionType.unknown:
        input = Center(
          child: CustomTextWidget(
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t("unknown_question_type"),
            textSize: FontSize().regular,
            fontColor: AppColors.red,
            isFontBold: false,
          ),
        );
        break;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            questionHeader,
            input,
            validationMessage,
            const SizedBox(height: 150),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimePicker(QuestionType type, BuildContext context) {
    if (type == QuestionType.dateTime) {
      return DateTimePickerRow(
        questionId: question.id,
        value: value is DateTime ? value : null,
        onPick: onPickDateTime,
      );
    } else if (type == QuestionType.date) {
      return DatePickerRow(
        questionId: question.id,
        value: value is DateTime ? value : null,
        onPick: onPickDate,
      );
    } else if (type == QuestionType.time) {
      return TimePickerRow(
        questionId: question.id,
        value: value is TimeOfDay ? value : null,
        onPick: onPickTime,
      );
    }
    return const SizedBox.shrink();
  }
}

class TextFieldSimple extends StatelessWidget {
  final String? initial;
  final String? placeholder;
  final ValueChanged<String> onChanged;
  final bool showError;

  const TextFieldSimple({
    super.key,
    this.initial,
    this.placeholder,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = showError ? AppColors.red : AppColors.grey400;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(
          hintText: placeholder == null || placeholder!.isEmpty
              ? DynamicAppLocalizations.of(context).t("type_here")
              : placeholder,
          hintStyle: TextStyle(color: AppColors.primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: showError ? AppColors.red : AppColors.primaryColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
        ),
        onChanged: onChanged,
        maxLines: 1,
      ),
    );
  }
}

class TextAreaField extends StatelessWidget {
  final String? initial;
  final String? placeholder;
  final ValueChanged<String> onChanged;
  final bool showError;

  const TextAreaField({
    super.key,
    this.initial,
    this.placeholder,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = showError ? AppColors.red : AppColors.grey400;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(
          hintText: placeholder == null || placeholder!.isEmpty
              ? DynamicAppLocalizations.of(context).t("type_here")
              : placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: showError ? AppColors.red : AppColors.primaryColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
        ),
        onChanged: onChanged,
        maxLines: 5,
      ),
    );
  }
}

class NumberField extends StatelessWidget {
  final String? initial;
  final String? placeholder;
  final ValueChanged<String> onChanged;
  final bool showError;

  const NumberField({
    super.key,
    this.initial,
    this.placeholder,
    required this.onChanged,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = showError ? AppColors.red : AppColors.grey400;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      child: TextFormField(
        initialValue: initial,
        decoration: InputDecoration(
          hintText: placeholder == null || placeholder!.isEmpty
              ? DynamicAppLocalizations.of(context).t("type_here")
              : placeholder,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(
              color: showError ? AppColors.red : AppColors.primaryColor,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadius),
            borderSide: BorderSide(color: borderColor, width: 1),
          ),
        ),
        onChanged: onChanged,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        maxLines: 1,
      ),
    );
  }
}

class YesNoSelector extends StatelessWidget {
  final Question question;
  final String? selected;
  final ValueChanged<String> onChanged;
  const YesNoSelector({
    super.key,
    required this.question,
    this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildButton(
          context,
          DynamicAppLocalizations.of(context).t("yes"),
          'yes',
          selected,
          onChanged,
        ),
        _buildButton(
          context,
          DynamicAppLocalizations.of(context).t("no"),
          'no',
          selected,
          onChanged,
        ),
      ],
    );
  }

  Widget _buildButton(
    BuildContext context,
    String label,
    String value,
    String? current,
    ValueChanged<String> onChanged,
  ) {
    final isSelected = current == value;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ElevatedButton(
          onPressed: () => onChanged(value),
          style: ElevatedButton.styleFrom(
            backgroundColor: isSelected
                ? AppColors.primaryColor
                : AppColors.grey200,
            foregroundColor: isSelected ? AppColors.white : AppColors.black,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            elevation: isSelected ? 4 : 0,
          ),
          child: CustomTextWidget(
            fontColor: AppColors.black,
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t(label.toString()),
            isFontBold: false,
            isFontUnderline: false,
            textSize: FontSize().regular,
            fontStyle: FontStyle.normal,
          ),
        ),
      ),
    );
  }
}

class MultiSelectList extends StatelessWidget {
  final Question question;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  const MultiSelectList({
    super.key,
    required this.question,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: question.options.map((option) {
        final isSelected = selected.contains(option.id);
        return CheckboxListTile(
          title: CustomTextWidget(
            fontColor: AppColors.black,
            textString: DynamicAppLocalizations.of(
              Get.context!,
            ).t(option.label.toString()),
            isFontBold: false,
            isFontUnderline: false,
            textSize: FontSize().regular,
            fontStyle: FontStyle.normal,
            numberOfLines: 20,
          ),

          value: isSelected,
          onChanged: (_) => onToggle(option.id),
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppColors.primaryColor,
        );
      }).toList(),
    );
  }
}

class SingleSelectList extends StatelessWidget {
  final Question question;
  final String? selected;
  final ValueChanged<String> onSelect;
  const SingleSelectList({
    super.key,
    required this.question,
    this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
   return RadioGroup<String>(
  groupValue: selected,
  onChanged: (value) => onSelect(value!),
  child: Column(
    children: question.options.map((option) {

      return RadioListTile<String>(
        title: CustomTextWidget(
          fontColor: AppColors.black,
          textString: DynamicAppLocalizations.of(Get.context!).t(option.label),
          isFontBold: false,
          isFontUnderline: false,
          textSize: FontSize().regular,
          fontStyle: FontStyle.normal,
          numberOfLines: 20,
        ),
        value: option.id,
        activeColor: AppColors.primaryColor,
      );
    }).toList(),
  ),
);

  }
}

class DateTimePickerRow extends StatelessWidget {
  final String questionId;
  final DateTime? value;
  final Future<void> Function(BuildContext, String) onPick;
  const DateTimePickerRow({
    super.key,
    required this.questionId,
    this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final text = value != null
        ? DateFormat('MMM dd yyyy, HH:mm').format(value!)
        : DynamicAppLocalizations.of(context).t("select_date_and_time");
    return GestureDetector(
      onTap: () => onPick(context, questionId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            const Icon(Icons.access_time),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextWidget(
                textString: text,
                textSize: FontSize().small,
                isFontBold: false,
                fontColor: AppColors.primaryColor,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class DatePickerRow extends StatelessWidget {
  final String questionId;
  final DateTime? value;
  final Future<void> Function(BuildContext, String) onPick;
  const DatePickerRow({
    super.key,
    required this.questionId,
    this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final text = value != null
        ? DateFormat('MMM dd yyyy').format(value!)
        : DynamicAppLocalizations.of(context).t("select_date");
    return GestureDetector(
      onTap: () => onPick(context, questionId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextWidget(
                textString: text,
                textSize: FontSize().small,
                isFontBold: false,
                fontColor: AppColors.primaryColor,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class TimePickerRow extends StatelessWidget {
  final String questionId;
  final TimeOfDay? value;
  final Future<void> Function(BuildContext, String) onPick;
  const TimePickerRow({
    super.key,
    required this.questionId,
    this.value,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    final hour = value?.hour.toString().padLeft(2, '0');
    final minute = value?.minute.toString().padLeft(2, '0');

    final String text = value != null
        ? '$hour:$minute'
        : DynamicAppLocalizations.of(context).t("select_time");
    return GestureDetector(
      onTap: () => onPick(context, questionId),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(color: AppColors.grey200),
        ),
        child: Row(
          children: [
            const Icon(Icons.schedule),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextWidget(
                textString: text,
                textSize: FontSize().small,
                isFontBold: false,
                fontColor: AppColors.primaryColor,
                isFontUnderline: false,
                fontStyle: FontStyle.normal,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}

class SingleImageSelector extends StatelessWidget {
  final Question question;
  final String? selected;
  final ValueChanged<String> onSelect;
  const SingleImageSelector({
    super.key,
    required this.question,
    this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: question.options.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final option = question.options[index];
        final isSelected = selected == option.id;
        String? imageUrl = option.imageUrl;
        inspect(question);
        return InkWell(
          onTap: () => onSelect(option.id),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : AppColors.grey200,
                width: isSelected ? 3.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (imageUrl != null && imageUrl.isNotEmpty)
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.broken_image,
                                      color: AppColors.grey800,
                                    ),
                              ),
                            ),
                          ),

                        CustomTextWidget(
                          fontColor: AppColors.black,
                          textString: DynamicAppLocalizations.of(
                            Get.context!,
                          ).t(option.label.toString()),
                          isFontBold: false,
                          isFontUnderline: false,
                          textSize: FontSize().small,
                          fontStyle: FontStyle.normal,
                          numberOfLines: 2,
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSelected)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class MultiImageSelector extends StatelessWidget {
  final Question question;
  final Set<String> selected;
  final ValueChanged<String> onToggle;
  const MultiImageSelector({
    super.key,
    required this.question,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: question.options.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final option = question.options[index];
        final isSelected = selected.contains(option.id);
        final String? imageUrl = option.imageUrl;

        return InkWell(
          onTap: () => onToggle(option.id),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(
                color: isSelected ? AppColors.primaryColor : AppColors.grey200,
                width: isSelected ? 3.0 : 1.0,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
            ),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (imageUrl?.isNotEmpty == true)
                          Expanded(
                            flex: 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                borderRadius - 4,
                              ),
                              child: Image.network(
                                imageUrl!,
                                fit: BoxFit.contain,
                                loadingBuilder:
                                    (
                                      BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                              : null,
                                        ),
                                      );
                                    },
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(
                                      Icons.broken_image,
                                      color: AppColors.grey800,
                                      size: 30,
                                    ),
                              ),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: CustomTextWidget(
                            fontColor: AppColors.black,
                            textString: DynamicAppLocalizations.of(
                              Get.context!,
                            ).t(option.optionValue ?? option.label.toString()),
                            isFontBold: false,
                            textSize: FontSize().small,
                            textCenter: true,
                            numberOfLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (isSelected)
                  const Positioned(
                    top: 4,
                    right: 4,
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.primaryColor,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
