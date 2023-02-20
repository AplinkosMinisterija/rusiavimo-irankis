import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:aplinkos_ministerija/model/final_stage_models/final_questions.dart';
import 'package:equatable/equatable.dart';

class FinalList extends Equatable {
  final double? id;
  final String? title;
  final List<FinalQuestions>? questions;

  const FinalList({
    this.id,
    this.questions,
    this.title,
  });

  factory FinalList.fromMap(Map<String, dynamic> fromMap) {
    return FinalList(
      id: fromMap[DatabaseConsts.FINAL_ID],
      questions: (fromMap[DatabaseConsts.FINAL_QUESTIONS] as List<dynamic>)
          .map((e) => FinalQuestions.fromMap(e))
          .toList(),
      title: fromMap[DatabaseConsts.FINAL_TITLE],
    );
  }

  @override
  List<Object?> get props => [
        id,
        questions,
        title,
      ];
}
