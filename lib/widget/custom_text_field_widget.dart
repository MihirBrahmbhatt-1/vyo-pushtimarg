import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../const/app_color.dart';
import '../const/app_constant.dart';
import 'custom_text_style.dart';

class CustomTextFormFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final Color? cursorColor;
  final TextStyle? style;
  final Color? iconColor;
  final Color? borderColor;
  final TextStyle? hintTextStyle;
  final String? hintText;
  final String? helperText;
  final Color? enabledColor;
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final AutovalidateMode? autoValidateMode;
  final TextStyle? errorTextStyle;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final bool enabled;
  final InputBorder? border;
  final String? label;
  final TextStyle? labelTextStyle;
  final String? errorText;
  final Color? errorBorderColor;
  final int? maxLength;
  final int? maxLines;
  final Color? cursorErrorColor;
  final Color? fillColor;
  final EdgeInsets? contentPadding;
  final bool readOnly;
  final void Function()? onSuffixIconPressed;
  final bool isOutlineBorder;
  final bool filled;
  final bool? isDisableLabel;
  final FocusNode? focusNode;
  final String? prefixText;
  final String? suffixText;

  const CustomTextFormFieldWidget({
    super.key,
    this.controller,
    this.contextMenuBuilder,
    this.cursorColor,
    this.style,
    this.iconColor,
    this.borderColor,
    this.hintTextStyle,
    this.hintText,
    this.helperText,
    this.enabledColor,
    this.validator,
    this.obscure = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.autoValidateMode,
    this.errorTextStyle,
    this.inputFormatters,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.filled = false,
    this.border,
    this.maxLength,
    this.maxLines = 1,
    this.label = '',
    this.labelTextStyle,
    this.errorText,
    this.errorBorderColor,
    this.cursorErrorColor,
    this.contentPadding = const EdgeInsets.only(top: 16),
    this.readOnly = false,
    this.onSuffixIconPressed,
    this.isOutlineBorder = false,
    this.isDisableLabel = true,
    this.textInputAction,
    this.focusNode,
    this.prefixText,
    this.suffixText,
    this.fillColor
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Semantics(
        slider: true,
        // container: true,
        textField: true,
        label: 'This is Email text field',
        child: TextFormField(
          key: key,
          focusNode: focusNode,
          contextMenuBuilder: contextMenuBuilder,
          cursorColor: cursorColor,
          controller: controller,
          readOnly: readOnly,
          cursorErrorColor: cursorErrorColor,
          style: style,
          obscureText: obscure,
          validator: validator,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          keyboardType: keyboardType,
          autovalidateMode: autoValidateMode,
          maxLength: maxLength,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixText: prefixText,
            suffixText: suffixText,
            alignLabelWithHint: true,
            filled: filled,
            fillColor: filled
                ? AppColors.primaryColor
                : AppColors.transparent,
            isDense: true,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon != null
                ? IconButton(
                    icon: suffixIcon!,
                    padding: EdgeInsets.zero,
                    onPressed: onSuffixIconPressed,
                  )
                : null,
            hintText: hintText,
            hintStyle: hintTextStyle ?? Get.textTheme.displayMedium,
            labelStyle: labelTextStyle ?? Get.textTheme.displayMedium,
            errorStyle: errorTextStyle ?? CustomTextStyle.errorTextStyle,
            labelText: label,
            helperText: helperText,
            floatingLabelBehavior: isDisableLabel == false
                ? FloatingLabelBehavior.never
                : FloatingLabelBehavior.auto,
            enabled: enabled,
            contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            errorText: errorText,
            errorMaxLines: 2,
            border: isOutlineBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.primaryColor,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.primaryColor,
                    ),
                  ),
            focusedBorder: isOutlineBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.primaryColor,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.primaryColor,
                    ),
                  ),
            disabledBorder: isOutlineBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.grey,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: borderColor ?? AppColors.grey,
                    ),
                  ),
            enabledBorder: isOutlineBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(
                      color: enabledColor ?? AppColors.black,
                    ),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: enabledColor ?? AppColors.black,
                    ),
                  ),
            errorBorder: isOutlineBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: AppColors.red),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
            focusedErrorBorder: isOutlineBorder
                ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                    borderSide: BorderSide(color: AppColors.red),
                  )
                : UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.red),
                  ),
          ),
        ),
      ),
    );
  }
}
