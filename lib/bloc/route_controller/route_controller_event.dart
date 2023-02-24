part of 'route_controller_bloc.dart';

abstract class RouteControllerEvent extends Equatable {
  const RouteControllerEvent();

  @override
  List<Object> get props => [];
}

class OpenHomeScreenEvent extends RouteControllerEvent {}

class OpenResidentsScreenEvent extends RouteControllerEvent {}

class OpenBussinessScreenEvent extends RouteControllerEvent {}