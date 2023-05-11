import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:equatable/equatable.dart';

class Questions extends Equatable {
  final String? question;
  final dynamic newCode;
  bool? isAnswered;
  bool? answerToNextQuestion;
  final String? otherAnswer;
  final List<dynamic>? suggestion;

  Questions({
    this.newCode,
    this.question,
    this.isAnswered,
    this.answerToNextQuestion,
    this.otherAnswer,
    this.suggestion,
  });

  factory Questions.fromMap(Map<String, dynamic> fromMap) {
    return Questions(
      newCode: fromMap[DatabaseConsts.QUESTION_NEW_CODE],
      question: fromMap[DatabaseConsts.QUESTION_TITLE],
      answerToNextQuestion: fromMap[DatabaseConsts.QUESTION_ANSWER_TO_QUESTION],
      isAnswered: null,
      otherAnswer: fromMap[DatabaseConsts.QUESTION_OTHER_ANSWER],
      suggestion: fromMap[DatabaseConsts.QUESTION_SUGGESTION],
    );
  }

  @override
  List<Object?> get props =>
      [
        newCode,
        question,
        isAnswered,
        otherAnswer,
        suggestion,
      ];
}
