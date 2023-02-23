// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'first_stage_bloc.dart';

abstract class FirstStageState extends Equatable {
  const FirstStageState();

  @override
  List<Object?> get props => [];
}

class FirstStageInitial extends FirstStageState {}

class FirstStageLoadingState extends FirstStageState {}

class FirstStageOpenState extends FirstStageState {
  final List<Category> listCategories;

  const FirstStageOpenState({
    required this.listCategories,
  });

  @override
  List<Object> get props => [
        listCategories,
      ];
}

class SelectedCategoryState extends FirstStageState {
  final Category category;

  const SelectedCategoryState({required this.category});

  @override
  List<Object> get props => [
        category,
      ];
}

class FoundCodeState extends FirstStageState {
  final String title;
  final String trashType;
  final String trashCode;

  const FoundCodeState({
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

class SecondStageLoadingState extends FirstStageState {}

class SecondStageOpenState extends FirstStageState {
  final SecondCategory category;
  final String trashCode;
  final List<Category> listOfCategories;
  final String trashTitle;

  const SecondStageOpenState({
    required this.category,
    required this.trashCode,
    required this.listOfCategories,
    required this.trashTitle,
  });

  @override
  List<Object> get props => [
        category,
        trashCode,
        listOfCategories,
        trashTitle,
      ];
}

class ThirdStageOpenState extends FirstStageState {
  String? title;
  final List<FinalList> finalList;
  final String trashTitle;

  ThirdStageOpenState({
    this.title,
    required this.finalList,
    required this.trashTitle,
  });

  @override
  List<Object?> get props => [
        title,
        finalList,
        trashTitle,
      ];
}

class ThirdStageLoadingState extends FirstStageState {}

class CodeFoundAfterThirdStageState extends FirstStageState {
  final String trashTitle;
  final String trashType;

  const CodeFoundAfterThirdStageState({
    required this.trashType,
    required this.trashTitle,
  });

  @override
  List<Object> get props => [
        trashType,
        trashTitle,
      ];
}
