// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'first_stage_bloc.dart';

abstract class FirstStageState extends Equatable {
  const FirstStageState();

  @override
  List<Object> get props => [];
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

  const SecondStageOpenState({
    required this.category,
    required this.trashCode,
  });

  @override
  List<Object> get props => [
        category,
        trashCode,
      ];
}

class ThirdStageOpenState extends FirstStageState {
  final String title;
  final List<FinalList> finalList;

  const ThirdStageOpenState({
    required this.title,
    required this.finalList,
  });

  @override
  List<Object> get props => [
        title,
        finalList,
      ];
}

class ThirdStageLoadingState extends FirstStageState {}
