part of 'first_stage_bloc.dart';

abstract class FirstStageState extends Equatable {
  const FirstStageState();

  @override
  List<Object> get props => [];
}

class FirstStageInitial extends FirstStageState {}

class FirstStageOpenState extends FirstStageState {}
