class SendOtpResponseModel {
  String? countryCode;
  String? mobileNumber;
  String? otpCode;
  String? otpHash;
  bool? used;
  String? createdAt;
  String? expiresAt;
  bool? isUserExist;

  SendOtpResponseModel({
    this.countryCode,
    this.mobileNumber,
    this.otpCode,
    this.otpHash,
    this.used,
    this.createdAt,
    this.expiresAt,
    this.isUserExist,
  });

  SendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    otpCode = json['otp_code'];
    otpHash = json['otp_hash'];
    used = json['used'];
    createdAt = json['created_at'];
    expiresAt = json['expires_at'];
    isUserExist = json['is_user_exist'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['mobile_number'] = mobileNumber;
    data['otp_code'] = otpCode;
    data['otp_hash'] = otpHash;
    data['used'] = used;
    data['created_at'] = createdAt;
    data['expires_at'] = expiresAt;
    data['is_user_exist'] = isUserExist;
    return data;
  }
}


class ForgotPasswordSendOtpResponseModel {
  String? countryCode;
  String? mobileNumber;
  String? otpCode;
  String? otpHash;
  bool? used;
  String? createdAt;
  String? expiresAt;
  bool? isUserExist;

  ForgotPasswordSendOtpResponseModel({
    this.countryCode,
    this.mobileNumber,
    this.otpCode,
    this.otpHash,
    this.used,
    this.createdAt,
    this.expiresAt,
    this.isUserExist,
  });

  ForgotPasswordSendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    countryCode = json['country_code'];
    mobileNumber = json['mobile_number'];
    otpCode = json['otp_code'];
    otpHash = json['otp_hash'];
    used = json['used'];
    createdAt = json['created_at'];
    expiresAt = json['expires_at'];
    isUserExist = json['is_user_exist'] ?? false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['country_code'] = countryCode;
    data['mobile_number'] = mobileNumber;
    data['otp_code'] = otpCode;
    data['otp_hash'] = otpHash;
    data['used'] = used;
    data['created_at'] = createdAt;
    data['expires_at'] = expiresAt;
    data['is_user_exist'] = isUserExist;
    return data;
  }
}
