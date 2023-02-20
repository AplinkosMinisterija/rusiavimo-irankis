import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:equatable/equatable.dart';

class FinalQuestions extends Equatable {
  final String? question;
  final double? ifYesGoToId;
  final double? ifNoGoToId;
  final String? ifYesGetType;
  final String? ifNoGetType;

  const FinalQuestions({
    this.ifNoGetType,
    this.ifNoGoToId,
    this.ifYesGetType,
    this.ifYesGoToId,
    this.question,
  });

  factory FinalQuestions.fromMap(Map<String, dynamic> fromMap) {
    return FinalQuestions(
      ifNoGetType: fromMap[DatabaseConsts.FINAL_QUESTIONS_IF_NO_GET_TYPE],
      ifNoGoToId: fromMap[DatabaseConsts.FINAL_QUESTIONS_IF_NO_GO_TO_STAGE],
      ifYesGetType: fromMap[DatabaseConsts.FINAL_QUESTIONS_IF_YES_GET_TYPE],
      ifYesGoToId: fromMap[DatabaseConsts.FINAL_QUESTIONS_IF_YES_GO_TO_STAGE],
      question: fromMap[DatabaseConsts.FINAL_QUESTIONS_TITLE],
    );
  }

  @override
  List<Object?> get props => [
        ifNoGetType,
        ifYesGetType,
        ifYesGoToId,
        ifNoGoToId,
        question,
      ];
}
