part of 'first_stage_bloc.dart';

abstract class FirstStageEvent extends Equatable {
  const FirstStageEvent();

  @override
  List<Object?> get props => [];
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
  String? title;
  String? trashType;
  String? trashCode;
  String? newCode;

  CodeFoundEvent({
    this.title,
    this.trashCode,
    this.trashType,
    this.newCode,
  });

  @override
  List<Object?> get props => [
        title,
        trashCode,
        trashType,
        newCode,
      ];
}

class OpenSecondStageEvent extends FirstStageEvent {
  final String trashCode;
  final String trashType;
  final String title;

  const OpenSecondStageEvent({
    required this.trashCode,
    required this.title,
    required this.trashType,
  });

  @override
  List<Object> get props => [
        trashCode,
      ];
}

class OpenThirdStageEvent extends FirstStageEvent {}
