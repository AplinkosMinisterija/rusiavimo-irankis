import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'nav_bar_event.dart';
part 'nav_bar_state.dart';

class NavBarBloc extends Bloc<NavBarEvent, NavBarState> {
  NavBarBloc() : super(NavBarInitial()) {
    on<OpenNavBarEvent>(_openNavBar);
    on<CloseNavBarEvent>(_closeNavBar);
  }

  _openNavBar(OpenNavBarEvent event, Emitter<NavBarState> emit) {
    emit(NavBarOpenState());
  }

  _closeNavBar(CloseNavBarEvent event, Emitter<NavBarState> emit) {
    emit(NavBarInitial());
  }
}
