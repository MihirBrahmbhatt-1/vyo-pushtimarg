class VersionListResponseModel {
  String? versionType;
  String? versionTypeName;
  String? lastUpdatedDate;

  VersionListResponseModel({
    this.versionType,
    this.versionTypeName,
    this.lastUpdatedDate,
  });

  VersionListResponseModel.fromJson(Map<String, dynamic> json) {
    versionType = json['version_type'];
    versionTypeName = json['version_type_name'];
    lastUpdatedDate = json['last_updated_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['version_type'] = versionType;
    data['version_type_name'] = versionTypeName;
    data['last_updated_date'] = lastUpdatedDate;
    return data;
  }
}
