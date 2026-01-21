class PushtiPracticeApiResponseModel {
  String? practiceId;
  String? practiceName;
  int? practiceType;
  List<Sections>? sections;

  PushtiPracticeApiResponseModel({
    this.practiceId,
    this.practiceName,
    this.practiceType,
    this.sections,
  });

  PushtiPracticeApiResponseModel.fromJson(Map<String, dynamic> json) {
    practiceId = json['practice_id'];
    practiceName = json['practice_name'];
    practiceType = json['practice_type'];
    if (json['sections'] != null) {
      sections = <Sections>[];
      json['sections'].forEach((v) {
        sections!.add(Sections.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['practice_id'] = practiceId;
    data['practice_name'] = practiceName;
    data['practice_type'] = practiceType;
    if (sections != null) {
      data['sections'] = sections!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sections {
  String? sectionId;
  int? sectionType;
  String? practiceId;
  String? content;

  Sections({
    this.sectionId,
    this.sectionType,
    this.practiceId,
    this.content,
  });

  Sections.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    sectionType = json['section_type'];
    practiceId = json['practice_id'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['section_id'] = sectionId;
    data['section_type'] = sectionType;
    data['practice_id'] = practiceId;
    data['content'] = content;
    return data;
  }
}
