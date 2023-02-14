import 'package:aplinkos_ministerija/data/repository.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'first_stage_event.dart';
part 'first_stage_state.dart';

class FirstStageBloc extends Bloc<FirstStageEvent, FirstStageState> {
  final Repository repo;
  FirstStageBloc({required this.repo}) : super(FirstStageInitial()) {
    on<OpenFirstStageEvent>(_openFirstStage);
  }

  _openFirstStage(
      OpenFirstStageEvent event, Emitter<FirstStageState> emit) async {
    emit(FirstStageLoadingState());
    List<Category> categoryList = await repo.getAllData();
    emit(FirstStageOpenState(
      listCategories: categoryList,
    ));
  }
}
