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
  final List<Category> listOfCategories;

  const OpenSecondStageEvent({
    required this.trashCode,
    required this.title,
    required this.trashType,
    required this.listOfCategories,
  });

  @override
  List<Object> get props => [
        trashCode,
        trashType,
        title,
        listOfCategories,
      ];
}

class OpenThirdStageEvent extends FirstStageEvent {
  final String trashTitle;
  final String trashCode;
  final String trashType;
  final List<Category> listOfCategories;

  const OpenThirdStageEvent({
    required this.trashTitle,
    required this.listOfCategories,
    required this.trashType,
    required this.trashCode,
  });

  @override
  List<Object> get props => [
        trashTitle,
        trashCode,
        trashType,
        listOfCategories,
      ];
}

class CodeFoundAfterThirdStageEvent extends FirstStageEvent {
  final String trashTitle;
  final String trashType;

  const CodeFoundAfterThirdStageEvent({
    required this.trashTitle,
    required this.trashType,
  });

  @override
  List<Object> get props => [
        trashTitle,
        trashType,
      ];
}

class BackToInitialEvent extends FirstStageEvent {}

class StartFromSecondStageEvent extends FirstStageEvent {}

class StartFromSecondStageSelectedCategoryEvent extends FirstStageEvent {
  final SecondCategory secondCategory;

  const StartFromSecondStageSelectedCategoryEvent(
      {required this.secondCategory});

  @override
  List<Object> get props => [
        secondCategory,
      ];
}
