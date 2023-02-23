part of 'how_to_use_bloc.dart';

abstract class HowToUseState extends Equatable {
  const HowToUseState();

  @override
  List<Object> get props => [];
}

class HowToUseInitial extends HowToUseState {}

class HowToUseOpenState extends HowToUseState {}