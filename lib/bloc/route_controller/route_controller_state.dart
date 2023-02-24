part of 'route_controller_bloc.dart';

abstract class RouteControllerState extends Equatable {
  const RouteControllerState();

  @override
  List<Object> get props => [];
}

class RouteControllerInitial extends RouteControllerState {}

class ResidentsState extends RouteControllerState {}

class BussinessState extends RouteControllerState {}