import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'how_to_use_event.dart';
part 'how_to_use_state.dart';

class HowToUseBloc extends Bloc<HowToUseEvent, HowToUseState> {
  HowToUseBloc() : super(HowToUseInitial()) {
    on<OpenHowToUseEvent>(_openHowToUse);
    on<CloseHowToUseEvent>(_closeHowToUse);
  }

  _openHowToUse(OpenHowToUseEvent event, Emitter<HowToUseState> emit) {
    emit(HowToUseOpenState());
  }

  _closeHowToUse(CloseHowToUseEvent event, Emitter<HowToUseState> emit) {
    emit(HowToUseInitial());
  }
}
