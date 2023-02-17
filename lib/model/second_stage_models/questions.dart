import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:equatable/equatable.dart';

class Questions extends Equatable {
  final String? question;
  final bool? progress;
  final bool? ifWrongIsMovable;
  final dynamic newCode;
  bool? isAnswered;

  Questions({
    this.ifWrongIsMovable,
    this.newCode,
    this.progress,
    this.question,
    this.isAnswered,
  });

  factory Questions.fromMap(Map<String, dynamic> fromMap) {
    return Questions(
      ifWrongIsMovable: fromMap[DatabaseConsts.QUESTION_IF_WRONG],
      newCode: fromMap[DatabaseConsts.QUESTION_NEW_CODE],
      progress: fromMap[DatabaseConsts.QUESTION_IF_CORRECT],
      question: fromMap[DatabaseConsts.QUESTION_TITLE],
      isAnswered: null,
    );
  }

  @override
  List<Object?> get props => [
        ifWrongIsMovable,
        newCode,
        progress,
        question,
        isAnswered,
      ];
}
