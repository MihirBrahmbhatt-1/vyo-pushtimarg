class DashboardHtmlContentResponseModel {
  String? sectionId;
  int? sectionType;
  String? content;
  int? sequence;

  DashboardHtmlContentResponseModel(
      {this.sectionId, this.sectionType, this.content, this.sequence});

  DashboardHtmlContentResponseModel.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    sectionType = json['section_type'];
    content = json['content'];
    sequence = json['sequence'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section_id'] = sectionId;
    data['section_type'] = sectionType;
    data['content'] = content;
    data['sequence'] = sequence;
    return data;
  }
}
