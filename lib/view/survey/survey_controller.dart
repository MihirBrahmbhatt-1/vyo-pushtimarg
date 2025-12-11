import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../model/survey_question_list_response_model.dart';
import 'questions_model.dart';

class SurveyController extends GetxController {
  final PageController pageController = PageController();
  final AnimationController? animationController;

  ApiController apiController = Get.put(ApiController());
  HomeController homeController = Get.put(HomeController());

  final RxList<Question> questions = <Question>[].obs;
  final RxMap<String, dynamic> answers = <String, dynamic>{}.obs;
  final RxBool isLoading = true.obs;

  final RxInt currentIndex = 0.obs;

  SurveyController({this.animationController});

  Future<void> loadQuestions() async {
    isLoading.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final List<SurveyQuestionListResponseModel> apiQuestions =
          await apiController.fetchSurveyQuestionListApi(
            languageId: homeController.selectedLanguageId.value,
            jwtToken: homeController.jwtToken.value,
          );

      final List<Question> appQuestions = apiQuestions
          .map((apiQ) => Question.fromApiModel(apiQ))
          .toList();

      questions.value = appQuestions;
    } catch (e) {
      debugPrint("Error loading questions: $e");
      questions.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void setYesNo(String qid, String value) => answers[qid] = value;
  void setSingleSelect(String qid, String optionId) => answers[qid] = optionId;
  void setSingleImage(String qid, String optionId) => answers[qid] = optionId;
  void setText(String qid, String text) => answers[qid] = text;
  void setNumber(String qid, String number) => answers[qid] = number;

  void setDate(String qid, DateTime date) => answers[qid] = date;
  void setTime(String qid, TimeOfDay time) => answers[qid] = time;
  void setDateTime(String qid, DateTime dateTime) => answers[qid] = dateTime;

  void toggleMulti(String qid, String optionId) {
    final currentAnswer = answers[qid];
    final currentSet = (currentAnswer is Set<String>)
        ? currentAnswer
        : <String>{};
    final s = Set<String>.from(currentSet);

    if (s.contains(optionId)) {
      s.remove(optionId);
    } else {
      s.add(optionId);
    }

    answers[qid] = s.isEmpty ? null : s;
  }

  void toggleMultiImage(String qid, String optionId) =>
      toggleMulti(qid, optionId);

  bool isQuestionAnswered(String questionId, QuestionType type) {
    final answer = answers[questionId];
    if (answer == null) return false;

    switch (type) {
      case QuestionType.yesNo:
      case QuestionType.singleSelect:
      case QuestionType.singleImage:
      case QuestionType.date:
      case QuestionType.time:
      case QuestionType.dateTime:
        return answer != null;

      case QuestionType.multiSelect:
      case QuestionType.multiImage:
        return (answer is Set) && answer.isNotEmpty;

      case QuestionType.text:
      case QuestionType.textarea:
      case QuestionType.number:
        return (answer is String) && answer.trim().isNotEmpty;

      case QuestionType.unknown:
        return false;
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
