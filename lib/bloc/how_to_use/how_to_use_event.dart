part of 'how_to_use_bloc.dart';

abstract class HowToUseEvent extends Equatable {
  const HowToUseEvent();

  @override
  List<Object?> get props => [];
}

class OpenHowToUseEvent extends HowToUseEvent {}

class CloseHowToUseEvent extends HowToUseEvent {}