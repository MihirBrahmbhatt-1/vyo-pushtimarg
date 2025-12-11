class UserProfileDetailsResponseModel {
  String? id;
  String? name;
  String? birthdate;
  int? gender;
  int? userType;
  String? password;
  String? mobileNo;
  String? mobileCountryCode;
  String? email;
  int? countryId;
  String? countryName;
  int? stateId;
  String? stateName;
  int? cityId;
  String? cityName;
  String? preferredLanguageId;
  bool? isSurveyCompleted;
  bool? isProfileCompleted;
  bool? isActive;
  bool? isDeleted;
  String? createdBy;
  bool? labelUpdated;
  String? jwtToken;

  UserProfileDetailsResponseModel({
    this.id,
    this.name,
    this.birthdate,
    this.gender,
    this.userType,
    this.password,
    this.mobileNo,
    this.mobileCountryCode,
    this.email,
    this.countryId,
    this.countryName,
    this.stateId,
    this.stateName,
    this.cityId,
    this.cityName,
    this.preferredLanguageId,
    this.isSurveyCompleted,
    this.isProfileCompleted,
    this.isActive,
    this.isDeleted,
    this.createdBy,
    this.labelUpdated,
    this.jwtToken,
  });

  UserProfileDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    birthdate = json['birthdate'];
    gender = json['gender'];
    userType = json['user_type'];
    password = json['password'];
    mobileNo = json['mobile_no'];
    mobileCountryCode = json['mobile_country_code'];
    email = json['email'];
    countryId = json['country_id'];
    countryName = json['country_name'];
    stateId = json['state_id'];
    stateName = json['state_name'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    preferredLanguageId = json['preferred_language_id'];
    isSurveyCompleted = json['is_survey_completed'];
    isProfileCompleted = json['is_profile_completed'];
    isActive = json['is_active'];
    isDeleted = json['is_deleted'];
    createdBy = json['created_by'];
    labelUpdated = json['label_updated'];
    jwtToken = json['jwt_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['birthdate'] = birthdate;
    data['gender'] = gender;
    data['user_type'] = userType;
    data['password'] = password;
    data['mobile_no'] = mobileNo;
    data['mobile_country_code'] = mobileCountryCode;
    data['email'] = email;
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['preferred_language_id'] = preferredLanguageId;
    data['is_survey_completed'] = isSurveyCompleted;
    data['is_profile_completed'] = isProfileCompleted;
    data['is_active'] = isActive;
    data['is_deleted'] = isDeleted;
    data['created_by'] = createdBy;
    data['label_updated'] = labelUpdated;
    data['jwt_token'] = jwtToken;
    return data;
  }
}
