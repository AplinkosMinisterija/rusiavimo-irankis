import 'package:aplinkos_ministerija/data/repository.dart';
import 'package:aplinkos_ministerija/model/category.dart';
import 'package:aplinkos_ministerija/model/final_stage_models/final_list.dart';
import 'package:aplinkos_ministerija/model/items.dart';
import 'package:aplinkos_ministerija/model/second_stage_models/second_category.dart';
import 'package:aplinkos_ministerija/utils/capitalization.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'first_stage_event.dart';

part 'first_stage_state.dart';

class FirstStageBloc extends Bloc<FirstStageEvent, FirstStageState> {
  final Repository repo;

  FirstStageBloc({required this.repo}) : super(FirstStageInitial()) {
    on<OpenFirstStageEvent>(_openFirstStage);
    on<FirstStageSelectedCategoryEvent>(_selectedCategory);
    on<OpenSecondStageEvent>(_openSecondStage);
    on<CodeFoundEvent>(_codeFound);
    on<OpenThirdStageEvent>(_openThirdStage);
    on<BackToInitialEvent>(_moveBackToInitial);
    on<CodeFoundAfterThirdStageEvent>(_trashFound);
  }

  _moveBackToInitial(BackToInitialEvent event, Emitter<FirstStageState> emit) {
    emit(FirstStageInitial());
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
    if (foundCategory != null) {
      emit(SecondStageOpenState(
        category: foundCategory,
        trashCode: event.trashCode,
        listOfCategories: event.listOfCategories,
        trashTitle: event.title,
      ));
    } else if (event.trashType == "AP" || event.trashType == "AN") {
      emit(FoundCodeState(
        title: event.title,
        trashCode: event.trashCode,
        trashType: event.trashType,
      ));
    } else {
      add(CodeFoundEvent(newCode: event.trashCode));
    }
  }

  _codeFound(CodeFoundEvent event, Emitter<FirstStageState> emit) async {
    if (event.title != null &&
        event.trashCode != null &&
        event.trashType != null) {
      emit(FoundCodeState(
        title: event.title!,
        trashCode: event.trashCode!,
        trashType: event.trashType!,
      ));
    } else if (event.newCode != null) {
      emit(SecondStageLoadingState());
      Items? item;
      List<Category> categoryList = await repo.getAllData();
      for (var i = 0; i < categoryList.length; i++) {
        if (item != null) break;
        for (var z = 0; z < categoryList[i].subCategories!.length; z++) {
          if (item != null) break;
          for (var x = 0;
              x < categoryList[i].subCategories![z].items!.length;
              x++) {
            if (event.newCode ==
                categoryList[i].subCategories![z].items![x].code) {
              item = categoryList[i].subCategories![z].items![x];
              if (item.type == "AP" || item.type == "AN") {
                emit(FoundCodeState(
                  title: item.itemName!,
                  trashCode: item.code!,
                  trashType: item.type!,
                ));
                break;
              } else if (item.type == "VP" || item.type == "VN") {
                add(
                  OpenThirdStageEvent(trashTitle: item.itemName!),
                );
                break;
              }
            }
          }
        }
      }
      if (item == null) {
        add(
          OpenThirdStageEvent(
            trashTitle: event.trashCode!,
          ),
        );
      }
    }
  }

  _openThirdStage(
      OpenThirdStageEvent event, Emitter<FirstStageState> emit) async {
    emit(ThirdStageLoadingState());
    List<FinalList> finalList = await repo.getFinalListData();
    emit(ThirdStageOpenState(
      title: finalList.first.title,
      finalList: finalList,
      trashTitle: event.trashTitle,
    ));
  }
}

_trashFound(
    CodeFoundAfterThirdStageEvent event, Emitter<FirstStageState> emit) {
  emit(
    CodeFoundAfterThirdStageState(
      trashType: event.trashType,
      trashTitle: event.trashTitle,
    ),
  );
}
