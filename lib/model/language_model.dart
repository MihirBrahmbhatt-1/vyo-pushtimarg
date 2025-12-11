class AppLanguage {
  final String code; // "en", "hi", "gu", "fr"
  final String name; // English, Hindi, Gujarati
  final String flag; // emoji or asset

  AppLanguage({required this.code, required this.name, required this.flag});
}

class LanguageModel {
  String? id;
  String? languageName;
  String? languageCode;
  bool? isDefault;
  String? createdOn;
  String? createdBy;
  String? modifiedBy;
  String? modifiedOn;
  bool? isActive;

  LanguageModel({
    this.id,
    this.languageName,
    this.languageCode,
    this.isDefault = false,
    this.createdOn,
    this.createdBy,
    this.modifiedBy,
    this.modifiedOn,
    this.isActive,
  });

  LanguageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
    languageCode = json['language_code'];
    isDefault = json['is_default'];
    createdOn = json['created_on'];
    createdBy = json['created_by'];
    modifiedBy = json['modified_by'];
    modifiedOn = json['modified_on'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language_name'] = languageName;
    data['language_code'] = languageCode;
    data['is_default'] = isDefault;
    data['created_on'] = createdOn;
    data['created_by'] = createdBy;
    data['modified_by'] = modifiedBy;
    data['modified_on'] = modifiedOn;
    data['is_active'] = isActive;
    return data;
  }
}
