part of 'nav_bar_bloc.dart';

abstract class NavBarState extends Equatable {
  const NavBarState();

  @override
  List<Object> get props => [];
}

class NavBarInitial extends NavBarState {}

class NavBarOpenState extends NavBarState {}
