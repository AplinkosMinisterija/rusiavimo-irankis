import 'package:aplinkos_ministerija/data/repository.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'first_stage_event.dart';
part 'first_stage_state.dart';

class FirstStageBloc extends Bloc<FirstStageEvent, FirstStageState> {
  final Repository repo;
  FirstStageBloc({required this.repo}) : super(FirstStageInitial()) {
    on<OpenFirstStageEvent>(_openFirstStage);
    on<FirstStageSelectedCategoryEvent>(_selectedCategory);
    on<CodeFoundEvent>(_codeFound);
    on<OpenSecondStageEvent>(_openSecondStage);
  }

  _openFirstStage(
      OpenFirstStageEvent event, Emitter<FirstStageState> emit) async {
    emit(FirstStageLoadingState());
    List<Category> categoryList = await repo.getAllData();
    emit(FirstStageOpenState(
      listCategories: categoryList,
    ));
  }

  _selectedCategory(
      FirstStageSelectedCategoryEvent event, Emitter<FirstStageState> emit) {
    emit(SelectedCategoryState(category: event.category));
  }

  _openSecondStage(
      OpenSecondStageEvent event, Emitter<FirstStageState> emit) async {
    SecondCategory? foundCategory;
    emit(SecondStageLoadingState());
    List<SecondCategory> secondaryCategoryList =
        await repo.getSecondStageData();
    for (var i = 0; i < secondaryCategoryList.length; i++) {
      if (secondaryCategoryList[i].codesList!.contains(event.trashCode)) {
        foundCategory = secondaryCategoryList[i];
        break;
      }
    }
    emit(SecondStageOpenState(
      category: foundCategory!,
      trashCode: event.trashCode,
    ));
  }

  _codeFound(CodeFoundEvent event, Emitter<FirstStageState> emit) {
    emit(FoundCodeState(
      title: event.title,
      trashCode: event.trashCode,
      trashType: event.trashType,
    ));
  }
}
