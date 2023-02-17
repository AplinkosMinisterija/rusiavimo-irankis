part of 'first_stage_bloc.dart';

abstract class FirstStageEvent extends Equatable {
  const FirstStageEvent();

  @override
  List<Object> get props => [];
}

class OpenFirstStageEvent extends FirstStageEvent {}

class FirstStageSelectedCategoryEvent extends FirstStageEvent {
  final Category category;

  const FirstStageSelectedCategoryEvent({required this.category});

  @override
  List<Object> get props => [
        category,
      ];
}

class CodeFoundEvent extends FirstStageEvent {
  final String title;
  final String trashType;
  final String trashCode;

  const CodeFoundEvent({
    required this.title,
    required this.trashCode,
    required this.trashType,
  });

  @override
  List<Object> get props => [
        title,
        trashCode,
        trashType,
      ];
}

class OpenSecondStageEvent extends FirstStageEvent {
  final String trashCode;

  const OpenSecondStageEvent({
    required this.trashCode,
  });

  @override
  List<Object> get props => [
        trashCode,
      ];
}
