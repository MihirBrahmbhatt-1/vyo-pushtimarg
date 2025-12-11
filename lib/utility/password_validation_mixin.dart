import 'package:get/get.dart';

mixin PasswordValidationMixin {
  RxBool isNewPasswordValid = false.obs;
  RxBool isConfirmPasswordValid = false.obs;

  /// Password validation rules
  Future<void> validateNewPassword(String value) async {
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigit = value.contains(RegExp(r'[0-9]'));
    bool hasSpecial = value.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>]'));
    bool isMinLength = value.length >= 8;

    isNewPasswordValid.value =
        hasUppercase && hasLowercase && hasDigit && hasSpecial && isMinLength;
  }

  /// Confirm password check
  void validateConfirmPassword(String value, String newPassword) {
    isConfirmPasswordValid.value = value == newPassword;
  }

  /// Overall form validity
  bool get isFormValid =>
      isNewPasswordValid.value && isConfirmPasswordValid.value;
}
