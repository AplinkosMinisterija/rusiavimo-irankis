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
