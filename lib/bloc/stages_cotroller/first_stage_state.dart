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
  final List<Map<String, dynamic>> dropdownCategory;

  const FirstStageOpenState({
    required this.listCategories,
    required this.dropdownCategory,
  });

  @override
  List<Object> get props => [
        listCategories,
        dropdownCategory,
      ];
}

class SelectedCategoryState extends FirstStageState {
  final Category category;
  final List<Map<String, dynamic>> dropdownSubCategory;

  const SelectedCategoryState({
    required this.category,
    required this.dropdownSubCategory,
  });

  @override
  List<Object> get props => [
        category,
        dropdownSubCategory,
      ];
}

class FoundCodeState extends FirstStageState {
  final String title;
  final String trashType;
  final String trashCode;
  final bool? fromEntryPoint;

  const FoundCodeState({
    required this.title,
    required this.trashCode,
    required this.trashType,
    this.fromEntryPoint,
  });

  @override
  List<Object?> get props => [
        title,
        trashCode,
        trashType,
        fromEntryPoint,
      ];
}

class SecondStageLoadingState extends FirstStageState {}

class SecondStageOpenState extends FirstStageState {
  final SecondCategory category;
  final String trashCode;
  final List<Category> listOfCategories;
  final String trashTitle;
  final String trashType;
  final bool? fromEntryPoint;
  final int? entryPointLevel;

  const SecondStageOpenState({
    required this.category,
    required this.trashCode,
    required this.listOfCategories,
    required this.trashTitle,
    required this.trashType,
    this.fromEntryPoint,
    this.entryPointLevel,
  });

  @override
  List<Object?> get props => [
        category,
        trashCode,
        listOfCategories,
        trashTitle,
        trashType,
        fromEntryPoint,
        entryPointLevel,
      ];
}

class ThirdStageOpenState extends FirstStageState {
  String? title;
  final List<FinalList> finalList;
  final String trashTitle;
  final String trashCode;
  final String trashType;
  final List<Category> listOfCategories;
  final bool? fromEntryPoint;

  ThirdStageOpenState({
    this.title,
    required this.finalList,
    required this.trashTitle,
    required this.trashType,
    required this.trashCode,
    required this.listOfCategories,
    this.fromEntryPoint,
  });

  @override
  List<Object?> get props => [
        title,
        finalList,
        trashTitle,
        trashType,
        trashCode,
        listOfCategories,
        fromEntryPoint,
      ];
}

class ThirdStageLoadingState extends FirstStageState {}

class CodeFoundAfterThirdStageState extends FirstStageState {
  final String trashTitle;
  final String trashType;
  final bool? fromEntryPoint;

  const CodeFoundAfterThirdStageState({
    required this.trashType,
    required this.trashTitle,
    this.fromEntryPoint,
  });

  @override
  List<Object?> get props => [
        trashType,
        trashTitle,
        fromEntryPoint,
      ];
}

class StartForSecondStageState extends FirstStageState {
  final List<SecondCategory> listOfCategories;
  final List<Category> categoryList;
  final List<Map<String, dynamic>> dropdownSubCategory;

  const StartForSecondStageState({
    required this.listOfCategories,
    required this.categoryList,
    required this.dropdownSubCategory,
  });

  @override
  List<Object> get props => [
        listOfCategories,
        categoryList,
        dropdownSubCategory,
      ];
}

class StartFromSecondStageSelectedCategoryState extends FirstStageState {
  final List<Items> listOfSortedItems;
  final List<Category> categoryList;
  final List<Map<String, dynamic>> dropdownSubCategory;

  const StartFromSecondStageSelectedCategoryState({
    required this.listOfSortedItems,
    required this.categoryList,
    required this.dropdownSubCategory,
  });

  @override
  List<Object> get props => [
        listOfSortedItems,
        categoryList,
        dropdownSubCategory,
      ];
}
