part of 'first_stage_bloc.dart';

abstract class FirstStageEvent extends Equatable {
  const FirstStageEvent();

  @override
  List<Object?> get props => [];
}

class PromptMoveToSecondEvent extends FirstStageEvent {
  final SecondCategory category;
  final String trashCode;
  final List<Category> listOfCategories;
  final String trashTitle;
  final String trashType;

  const PromptMoveToSecondEvent({
    required this.category,
    required this.trashCode,
    required this.listOfCategories,
    required this.trashTitle,
    required this.trashType,
  });

  @override
  List<Object?> get props => [
        category,
        trashCode,
        listOfCategories,
        trashTitle,
        trashType,
      ];
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
  bool? isKnown;
  bool? fromEntryPoint;
  int? entryPointLevel;

  CodeFoundEvent({
    this.title,
    this.trashCode,
    this.trashType,
    this.newCode,
    this.isKnown,
    this.fromEntryPoint,
    this.entryPointLevel,
  });

  @override
  List<Object?> get props => [
        title,
        trashCode,
        trashType,
        newCode,
        isKnown,
        fromEntryPoint,
        entryPointLevel,
      ];
}

class OpenSecondStageEvent extends FirstStageEvent {
  final String trashCode;
  final String trashType;
  final String title;
  final List<Category> listOfCategories;
  final bool? fromEntryPoint;
  final PromptManagerCubit promptManagerCubit;

  const OpenSecondStageEvent({
    required this.trashCode,
    required this.title,
    required this.trashType,
    required this.listOfCategories,
    this.fromEntryPoint,
    required this.promptManagerCubit,
  });

  @override
  List<Object?> get props => [
        trashCode,
        trashType,
        title,
        listOfCategories,
        fromEntryPoint,
        promptManagerCubit,
      ];
}

class OpenThirdStageEvent extends FirstStageEvent {
  final String trashTitle;
  final String trashCode;
  final String trashType;
  final List<Category> listOfCategories;
  final bool? fromEntryPoint;

  const OpenThirdStageEvent({
    required this.trashTitle,
    required this.listOfCategories,
    required this.trashType,
    required this.trashCode,
    this.fromEntryPoint,
  });

  @override
  List<Object?> get props => [
        trashTitle,
        trashCode,
        trashType,
        listOfCategories,
        fromEntryPoint,
      ];
}

class CodeFoundAfterThirdStageEvent extends FirstStageEvent {
  final String trashTitle;
  final String trashType;
  final bool? fromEntryPoint;

  const CodeFoundAfterThirdStageEvent({
    required this.trashTitle,
    required this.trashType,
    this.fromEntryPoint,
  });

  @override
  List<Object?> get props => [
        trashTitle,
        trashType,
        fromEntryPoint,
      ];
}

class BackToInitialEvent extends FirstStageEvent {}

class StartFromSecondStageEvent extends FirstStageEvent {}

class StartFromSecondStageSelectedCategoryEvent extends FirstStageEvent {
  final SecondCategory secondCategory;

  const StartFromSecondStageSelectedCategoryEvent({
    required this.secondCategory,
  });

  @override
  List<Object> get props => [
        secondCategory,
      ];
}
