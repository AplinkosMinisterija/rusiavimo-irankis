part of 'first_stage_bloc.dart';

abstract class FirstStageEvent extends Equatable {
  const FirstStageEvent();

  @override
  List<Object> get props => [];
}

class OpenFirstStageEvent extends FirstStageEvent {}
