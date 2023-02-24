import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'route_controller_event.dart';

part 'route_controller_state.dart';

class RouteControllerBloc
    extends Bloc<RouteControllerEvent, RouteControllerState> {
  RouteControllerBloc() : super(RouteControllerInitial()) {
    on<OpenHomeScreenEvent>(_openHomeScreen);
    on<OpenResidentsScreenEvent>(_openResidentsScreen);
    on<OpenBussinessScreenEvent>(_openBussinessScreen);
  }

  _openHomeScreen(
      OpenHomeScreenEvent event, Emitter<RouteControllerState> emit) {
    emit(RouteControllerInitial());
  }

  _openResidentsScreen(
      OpenResidentsScreenEvent event, Emitter<RouteControllerState> emit) {
    emit(ResidentsState());
  }

  _openBussinessScreen(
      OpenBussinessScreenEvent event, Emitter<RouteControllerState> emit) {
    emit(BussinessState());
  }
}
