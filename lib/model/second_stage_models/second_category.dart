import 'package:aplinkos_ministerija/data/network/constants/database_consts.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/questions.dart';
import 'package:equatable/equatable.dart';

class SecondCategory extends Equatable {
  final String? title;
  final int? id;
  final List<dynamic>? codesList;
  final List<Questions>? questionsList;
  final bool? isMovableToThirdStage;

  const SecondCategory({
    this.codesList,
    this.id,
    this.isMovableToThirdStage,
    this.questionsList,
    this.title,
  });

  factory SecondCategory.fromMap(Map<String, dynamic> fromMap) {
    return SecondCategory(
      codesList: fromMap[DatabaseConsts.SECOND_CATEGORY_CODES_LIST],
      id: fromMap[DatabaseConsts.SECOND_CATEGORY_ID],
      isMovableToThirdStage: fromMap[DatabaseConsts.SECOND_CATEGORY_IS_MOVABLE],
      questionsList:
          (fromMap[DatabaseConsts.SECOND_CATEGORY_QUESTIONS] as List<dynamic>)
              .map((e) => Questions.fromMap(e))
              .toList(),
      title: fromMap[DatabaseConsts.SECOND_CATEGORY_TITLE],
    );
  }

  @override
  List<Object?> get props => [
        codesList,
        id,
        isMovableToThirdStage,
        questionsList,
        title,
      ];
}
