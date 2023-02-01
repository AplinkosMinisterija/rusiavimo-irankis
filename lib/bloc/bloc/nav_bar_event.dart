part of 'nav_bar_bloc.dart';

abstract class NavBarEvent extends Equatable {
  const NavBarEvent();

  @override
  List<Object> get props => [];
}

class OpenNavBarEvent extends NavBarEvent {}

class CloseNavBarEvent extends NavBarEvent {}
