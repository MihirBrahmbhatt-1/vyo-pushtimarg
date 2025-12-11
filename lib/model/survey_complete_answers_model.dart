class SurveySubmissionModel {
  final String userId;
  final List<Answer> answers;
  final List<AnswerOption> answerOptions;

  SurveySubmissionModel({
    required this.userId,
    required this.answers,
    required this.answerOptions,
  });

  factory SurveySubmissionModel.fromJson(Map<String, dynamic> json) {
    return SurveySubmissionModel(
      userId: json['user_id'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((item) => Answer.fromJson(item as Map<String, dynamic>))
          .toList(),
      answerOptions: (json['answerOptions'] as List<dynamic>)
          .map((item) => AnswerOption.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['answers'] = answers;
    data['answerOptions'] = answerOptions;
    return data;
  }
}

class Answer {
  final String questionId;
  final dynamic extra;
  final String answerText;

  Answer({required this.questionId, this.extra, required this.answerText});

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      questionId: json['question_id'] as String,
      extra: json['extra'],
      answerText: json['answer_text'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'extra': extra,
      'answer_text': answerText,
    };
  }
}


class AnswerOption {
  final String questionId;
  final dynamic extra; 
  final String answerOptionId;

  AnswerOption({
    required this.questionId,
    this.extra,
    required this.answerOptionId,
  });

  factory AnswerOption.fromJson(Map<String, dynamic> json) {
    return AnswerOption(
      questionId: json['question_id'] as String,
      extra: json['extra'],
      answerOptionId: json['answer_option_id'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question_id': questionId,
      'extra': extra,
      'answer_option_id': answerOptionId,
    };
  }
}
