import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'first_stage_event.dart';
part 'first_stage_state.dart';

class FirstStageBloc extends Bloc<FirstStageEvent, FirstStageState> {
  FirstStageBloc() : super(FirstStageInitial()) {
    on<OpenFirstStageEvent>(_openFirstStage);
  }

  _openFirstStage(OpenFirstStageEvent event, Emitter<FirstStageState> emit) {
    emit(FirstStageOpenState());
  }
}
