import 'package:get/get.dart';

import '../const/app_constant.dart';
import '../const/app_string.dart';
import '../localization/dynamic_app_localizations.dart';

class Validators {
  emailValidators(String value, String label) {
    if (value.trim().isEmpty) {
      return dynamicIsRequiredValidator(label);
    } else if (value.trim().length > emailMaxLength) {
      return maxLengthValidation(label, emailMaxLength);
    } else if (!RegExp(emailValidationRegExString).hasMatch(value.trim())) {
      return dynamicIsInValid(label);
    } else {
      return null;
    }
  }

  passwordValidators(String value, String label) {
    if (value.trim().isEmpty) {
      return dynamicIsRequiredValidator(label);
    } else {
      return null;
    }
  }

  validateTextField(String? value, String label) {
    if (value!.trim().isEmpty) {
      return dynamicIsRequiredValidator(label);
    }
    return null;
  }

  dynamicIsRequiredValidator(String label) {
    return '$label ' '${DynamicAppLocalizations.of(Get.context!).t("is_required")}';
  }

  dynamicIsInValid(String label) {
    return '$label $isInvalid';
  }

  maxLengthValidation(String label, int maxLength) {
    return '$label must be no longer than $maxLength characters.';
  }

  validateForIsRequired(String? value, String label) {
    if (value == null || value.trim().isEmpty) {
      return dynamicIsRequiredValidator(label);
    }
    return null;
  }

  String? validatePassword(String? valuePassword, String label) {
    final value = valuePassword?.trim() ?? "";

    if (value.isEmpty) {
      return dynamicIsRequiredValidator(label);
    }
    return null;
  }

    static bool hasUpperCase(String value) =>
      value.contains(RegExp(r'[A-Z]'));

  static bool hasLowerCase(String value) =>
      value.contains(RegExp(r'[a-z]'));

  static bool hasNumber(String value) =>
      value.contains(RegExp(r'[0-9]'));

  static bool hasSpecialCharacter(String value) =>
      value.contains(RegExp(r'[!@#\$&*~%^(){}[\]|?/<>+=_-]'));
}
