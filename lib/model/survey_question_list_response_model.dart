class SurveyQuestionListResponseModel {
  String? id;
  String? questionValue;
  int? sequence;
  int? type;
  bool? isRequired;
  String? extra;
  List<Options>? options;

  SurveyQuestionListResponseModel(
      {this.id,
      this.questionValue,
      this.sequence,
      this.type,
      this.isRequired,
      this.extra,
      this.options});

  SurveyQuestionListResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionValue = json['question_value'];
    sequence = json['sequence'];
    type = json['type'];
    isRequired = json['is_required'] ?? false;
    extra = json['extra'];
    if (json['Options'] != null) {
      options = <Options>[];
      json['Options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['question_value'] = questionValue;
    data['sequence'] = sequence;
    data['type'] = type;
    data['is_required'] = isRequired;
    data['extra'] = extra;
    if (options != null) {
      data['Options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? id;
  String? optionsValue;
  int? sequence;
  bool? isRequired;
  String? extra;
  String? imageUrl;

  Options(
      {this.id, this.optionsValue, this.sequence, this.isRequired, this.extra, this.imageUrl});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optionsValue = json['option_value'];
    sequence = json['sequence'];
    isRequired = json['is_required'];
    extra = json['extra'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['option_value'] = optionsValue;
    data['sequence'] = sequence;
    data['is_required'] = isRequired;
    data['extra'] = extra;
    data['image_url'] = imageUrl;
    return data;
  }
}
