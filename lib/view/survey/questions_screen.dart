import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../const/app_color.dart';
import '../../const/app_constant.dart';
import '../../controller/api_controller.dart';
import '../../controller/home_controller.dart';
import '../../localization/dynamic_app_localizations.dart';
import '../../model/survey_complete_answers_model.dart';
import '../../navigation/pages.dart';
import '../../widget/custom_text_widget.dart';
import 'questions_model.dart';
import 'questions_page.dart';
import 'survey_controller.dart';

class QuestionsScreen extends StatefulWidget {
  const QuestionsScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen>
    with SingleTickerProviderStateMixin {
  ApiController apiController = Get.put(ApiController());
  late SurveyController controller;
  late AnimationController animationController;
  int currentIndex = 0;
  bool _showValidationError = false;
  RxBool isLoading = false.obs;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    controller = Get.put(
      SurveyController(animationController: animationController),
    );

    controller.pageController.addListener(() {
      final page = controller.pageController.hasClients
          ? controller.pageController.page?.round() ?? 0
          : 0;
      if (page != currentIndex) {
        setState(() {
          currentIndex = page;
          _showValidationError = false;
        });
        controller.currentIndex.value = page;
      }
    });

    _loadData();
  }

  Future<void> _loadData() async {
    await controller.loadQuestions();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Future<void> _pickDateTime(BuildContext ctx, String qid) async {
    final date = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return PopScope(
          canPop: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.white,
                onSurface: AppColors.primaryColor,
              ),
              datePickerTheme: const DatePickerThemeData(
                backgroundColor: AppColors.white,
                headerBackgroundColor: AppColors.primaryColor,
                headerForegroundColor: AppColors.white,
                dividerColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (date == null) return;

    final initialTime = TimeOfDay.fromDateTime(DateTime.now());
    final time = await showTimePicker(
      context: Get.context!,
      initialTime: initialTime,
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return PopScope(
          canPop: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.white,
                onSurface: AppColors.primaryColor,
              ),

              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppColors.white,
                hourMinuteColor: AppColors.primaryColor,
                hourMinuteTextColor: AppColors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
                dayPeriodColor: WidgetStateColor.resolveWith((
                  Set<WidgetState> states,
                ) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.primaryColor
                      : AppColors.grey200;
                }),

                dayPeriodTextColor: WidgetStateColor.resolveWith((
                  Set<WidgetState> states,
                ) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.white
                      : AppColors.grey;
                }),
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },
    );
    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
    controller.setDateTime(qid, selectedDateTime);
  }

  Future<void> _pickDate(BuildContext ctx, String qid) async {
    final date = await showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return PopScope(
          canPop: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.white,
                onSurface: AppColors.primaryColor,
              ),
              datePickerTheme: const DatePickerThemeData(
                backgroundColor: AppColors.white,
                headerBackgroundColor: AppColors.primaryColor,
                headerForegroundColor: AppColors.white,
                dividerColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
              ),
            ),
            child: child!,
          ),
        );
      },
    );
    if (date != null) {
      controller.setDate(qid, date);
    }
  }

  Future<void> _pickTime(BuildContext ctx, String qid) async {
    final time = await showTimePicker(
      context: ctx,
      initialTime: TimeOfDay.fromDateTime(DateTime.now()),
      initialEntryMode: TimePickerEntryMode.dialOnly,
      builder: (context, child) {
        return PopScope(
          canPop: false,
          child: Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: AppColors.primaryColor,
                onPrimary: AppColors.white,
                onSurface: AppColors.primaryColor,
              ),

              timePickerTheme: TimePickerThemeData(
                backgroundColor: AppColors.white,
                hourMinuteColor: AppColors.primaryColor,
                hourMinuteTextColor: AppColors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                ),
                dayPeriodColor: WidgetStateColor.resolveWith((
                  Set<WidgetState> states,
                ) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.primaryColor
                      : AppColors.grey200;
                }),

                dayPeriodTextColor: WidgetStateColor.resolveWith((
                  Set<WidgetState> states,
                ) {
                  return states.contains(WidgetState.selected)
                      ? AppColors.white
                      : AppColors.grey;
                }),
              ),
            ),
            child: MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(alwaysUse24HourFormat: true),
              child: child ?? const SizedBox(),
            ),
          ),
        );
      },
    );
    if (time != null) {
      controller.setTime(qid, time);
    }
  }

  void _nextQuestion({bool forceSkip = false}) async {
    final totalQuestions = controller.questions.length;
    final isLastQuestion = currentIndex >= totalQuestions - 1;
    if (isLastQuestion) {
            isLoading.value = true;
      final currentQuestion = controller.questions[currentIndex];
      if (currentQuestion.isRequired &&
          !controller.isQuestionAnswered(
            currentQuestion.id,
            currentQuestion.type,
          )) {
        setState(() => _showValidationError = true);
        return;
      }

      final List<Map<String, dynamic>> textAnswers = [];
      final List<Map<String, dynamic>> optionAnswers = [];

      for (final question in controller.questions) {
        final answerValue = controller.answers[question.id];
        if (answerValue == null) continue;

        final baseAnswer = {"question_id": question.id, "extra": null};

        if ([
          QuestionType.yesNo,
          QuestionType.text,
          QuestionType.textarea,
          QuestionType.number,
          QuestionType.dateTime,
          QuestionType.date,
          QuestionType.time,
        ].contains(question.type)) {
          String answerText;
          if (question.type == QuestionType.yesNo) {
            answerText = answerValue;
          } else if (answerValue is DateTime) {
            if (question.type == QuestionType.dateTime) {
              answerText =
                  '${answerValue.toUtc().toIso8601String().split('.').first}Z';
            } else if (question.type == QuestionType.date) {
              answerText = DateFormat('yyyy-MM-dd').format(answerValue);
            } else {
              answerText = answerValue.toString();
            }
          } else if (answerValue is TimeOfDay) {
            final hour = answerValue.hour.toString().padLeft(2, '0');
            final minute = answerValue.minute.toString().padLeft(2, '0');
            answerText = '$hour:$minute:00';
          } else {
            answerText = answerValue.toString();
          }
          textAnswers.add({...baseAnswer, "answer_text": answerText});
        } else if ([
          QuestionType.singleSelect,
          QuestionType.singleImage,
        ].contains(question.type)) {
          optionAnswers.add({
            ...baseAnswer,
            "answer_option_id": answerValue as String,
          });
        } else if ([
          QuestionType.multiSelect,
          QuestionType.multiImage,
        ].contains(question.type)) {
          if (answerValue is Set<String>) {
            for (final optionId in answerValue) {
              optionAnswers.add({...baseAnswer, "answer_option_id": optionId});
            }
          }
        }
      }
      HomeController homeController = Get.put(HomeController());
      final submissionBody = {
        "user_id": homeController.customerIdString.value.toString(),
        "answers": textAnswers,
        "answerOptions": optionAnswers,
      };

      final SurveySubmissionModel submissionModel =
          SurveySubmissionModel.fromJson(submissionBody);
      final List<Answer> answerObjects = submissionModel.answers;
      final List<AnswerOption> answerOptionsObject =
          submissionModel.answerOptions;
      final List<Map<String, dynamic>> answerMaps = answerObjects
          .map((answer) => answer.toJson())
          .toList();
      final List<Map<String, dynamic>> answerOptionsMap = answerOptionsObject
          .map((answer) => answer.toJson())
          .toList();


      bool isSuccess = await apiController.submitUserSurvey(
        jwtToken: homeController.jwtToken.value,
        userId: homeController.customerIdString.value,
        answer: answerMaps,
        answerOption: answerOptionsMap,
      );
      if (isSuccess) {
        isLoading.value = false;
        Get.offAllNamed(Routes.surveycompleted);
      }
      isLoading.value = false;

      return;
    }
    final currentQuestion = controller.questions[currentIndex];

    if (currentQuestion.isRequired && !forceSkip) {
      final isAnswered = controller.isQuestionAnswered(
        currentQuestion.id,
        currentQuestion.type,
      );
      if (!isAnswered) {
        setState(() => _showValidationError = true);
        return;
      }
    }

    setState(() => _showValidationError = false);
    controller.pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      controller.pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(color: AppColors.primaryColor),
          ),
        );
      }

      if (controller.questions.isEmpty) {
        return Scaffold(
          body: Center(
            child: CustomTextWidget(
              textString: DynamicAppLocalizations.of(
                Get.context!,
              ).t("no_survey_questions"),
              textSize: FontSize().regular,
              fontColor: AppColors.red,
              isFontBold: false,
            ),
          ),
        );
      }

      final totalQuestions = controller.questions.length;
      if (currentIndex >= totalQuestions) {
        currentIndex = totalQuestions - 1;
      }

      final currentQuestion = controller.questions[currentIndex];
      final bool canSkip = !currentQuestion.isRequired;
      final bool isAnswered = controller.isQuestionAnswered(
        currentQuestion.id,
        currentQuestion.type,
      );
      final bool isLastQuestion = currentIndex == totalQuestions - 1;

      return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              _SurveyProgressHeader(controller: controller),

              Expanded(
                child: PageView.builder(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: totalQuestions,
                  itemBuilder: (context, index) {
                    final question = controller.questions[index];
                    final answerValue = controller.answers[question.id];

                    return QuestionsPage(
                      key: ValueKey(question.id),
                      question: question,
                      value: answerValue,
                      showError: _showValidationError && index == currentIndex,
                      onYesNo: controller.setYesNo,
                      onToggleMulti: controller.toggleMulti,
                      onSingleSelect: controller.setSingleSelect,
                      onText: controller.setText,
                      onNumber: controller.setNumber,
                      onSingleImage: controller.setSingleImage,
                      onToggleMultiImage: controller.toggleMultiImage,
                      onPickDateTime: _pickDateTime,
                      onPickDate: _pickDate,
                      onPickTime: _pickTime,
                    );
                  },
                ),
              ),

              Container(
                padding: const EdgeInsets.only(top: 10, bottom: 24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  boxShadow: [
                    BoxShadow(color: AppColors.grey200, blurRadius: 4),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22.0),
                  child: Row(
                    children: [
                      // Back Button
                      if (currentIndex > 0)
                        TextButton(
                          onPressed: _previousQuestion,
                          child: CustomTextWidget(
                            textString: DynamicAppLocalizations.of(
                              Get.context!,
                            ).t("back"),
                            textSize: FontSize().regular,
                            fontColor: AppColors.grey,
                            isFontBold: false,
                          ),
                        ),
                      const Spacer(),
                      if (canSkip && !isAnswered && !isLastQuestion)
                        TextButton(
                          onPressed: () => _nextQuestion(forceSkip: true),
                          child: CustomTextWidget(
                            textString: DynamicAppLocalizations.of(
                              Get.context!,
                            ).t("skip"),
                            textSize: FontSize().regular,
                            fontColor: AppColors.primaryColor,
                            isFontBold: false,
                          ),
                        ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _nextQuestion(),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const StadiumBorder(),
                            elevation: 6,
                            backgroundColor: AppColors.primaryColor,
                          ),
                          child: isLoading.value ?SizedBox(height: 14, width: 14, child: CircularProgressIndicator(color: AppColors.white,)) : CustomTextWidget(
                            textString: isLastQuestion
                                ? DynamicAppLocalizations.of(
                                    Get.context!,
                                  ).t("finish")
                                : DynamicAppLocalizations.of(
                                    Get.context!,
                                  ).t('next'),
                            textSize: FontSize().regular,
                            fontColor: AppColors.white,
                            isFontBold: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

class _SurveyProgressHeader extends StatelessWidget {
  final SurveyController controller;

  const _SurveyProgressHeader({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final total = controller.questions.length;
      final current = controller.currentIndex.value;

      final progress = (current + 1) / total;
      final String questionProgress = DynamicAppLocalizations.of(Get.context!)
          .t(
            "question_current_of_total",
            params: {'current': current + 1, 'total': total},
          );

      return Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
        color: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              textString: questionProgress,
              textSize: FontSize().regular,
              fontColor: AppColors.primaryColor,
              isFontBold: false,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: AppColors.grey200,
                color: AppColors.primaryColor,
              ),
            ),
          ],
        ),
      );
    });
  }
}
