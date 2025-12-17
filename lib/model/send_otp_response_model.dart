class SendOtpResponseModel {
  String? countryCode;
  String? mobileNumber;
  String? otpCode;
  String? otpHash;
  bool? used;
  String? createdAt;
  String? expiresAt;
  bool? isUserExist;
  String? verificationId;

  SendOtpResponseModel({
    this.countryCode,
    this.mobileNumber,
    this.otpCode,
    this.otpHash,
    this.used,
    this.createdAt,
    this.expiresAt,
    this.isUserExist,
    this.verificationId,
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
    verificationId = json['verification_id'];
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
    data['verification_id'] = verificationId;
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
  String? verificationId;

  ForgotPasswordSendOtpResponseModel({
    this.countryCode,
    this.mobileNumber,
    this.otpCode,
    this.otpHash,
    this.used,
    this.createdAt,
    this.expiresAt,
    this.isUserExist,
    this.verificationId,
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
    verificationId = json['verification_id'] ?? false;
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
    data['verification_id'] = verificationId;
    return data;
  }
}
