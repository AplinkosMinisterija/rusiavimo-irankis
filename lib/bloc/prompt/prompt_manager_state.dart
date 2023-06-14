part of 'prompt_manager_cubit.dart';

abstract class PromptManagerState extends Equatable {
  const PromptManagerState();

  @override
  List<Object?> get props => [];
}

class PromptManagerInitial extends PromptManagerState {}

class PromptState extends PromptManagerState {
  final SecondCategory category;
  final String trashCode;
  final List<Category> listOfCategories;
  final String trashTitle;
  final String trashType;

  const PromptState({
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
