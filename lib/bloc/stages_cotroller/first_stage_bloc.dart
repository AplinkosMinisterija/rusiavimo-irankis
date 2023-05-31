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
  List<Category>? allData;

  FirstStageBloc({required this.repo}) : super(FirstStageInitial()) {
    on<OpenFirstStageEvent>(_openFirstStage);
    on<FirstStageSelectedCategoryEvent>(_selectedCategory);
    on<OpenSecondStageEvent>(_openSecondStage);
    on<CodeFoundEvent>(_codeFound);
    on<OpenThirdStageEvent>(_openThirdStage);
    on<BackToInitialEvent>(_moveBackToInitial);
    on<CodeFoundAfterThirdStageEvent>(_trashFound);
    on<StartFromSecondStageEvent>(_startForSecondStage);
    on<StartFromSecondStageSelectedCategoryEvent>(
        _startFromSecondStageSelectedCategory);
  }

  _startFromSecondStageSelectedCategory(
      StartFromSecondStageSelectedCategoryEvent event,
      Emitter<FirstStageState> emit) async {
    // emit(SecondStageLoadingState());
    List<Category> categoryList = await repo.getAllData();
    List<Items> sortedItemsList = [];
    int index = 0;
    String subIndex = '';
    for (var i = 0; i < event.secondCategory.codesList!.length; i++) {
      final split = event.secondCategory.codesList![i].toString().split(' ');
      if (index != int.parse(split[0])) {
        index = int.parse(split[0]);
      }
      if (subIndex != '${split[0]} ${split[1]}') {
        subIndex = '${split[0]} ${split[1]}';
      }
      int indexOfCategory = categoryList
          .indexWhere((element) => int.parse(element.categoryId!) == index);
      int indexOfSubCategory = categoryList[indexOfCategory]
          .subCategories!
          .indexWhere((element) => element.codeId! == subIndex);
      int indexOfItem = categoryList[indexOfCategory]
          .subCategories![indexOfSubCategory]
          .items!
          .indexWhere(
              (element) => element.code == event.secondCategory.codesList![i]);
      sortedItemsList.add(categoryList[indexOfCategory]
          .subCategories![indexOfSubCategory]
          .items![indexOfItem]);
    }
    emit(StartFromSecondStageSelectedCategoryState(
      listOfSortedItems: sortedItemsList,
    ));
  }

  _startForSecondStage(
      StartFromSecondStageEvent event, Emitter<FirstStageState> emit) async {
    emit(SecondStageLoadingState());
    List<SecondCategory> categoryList = await repo.getSecondStageData();
    emit(StartForSecondStageState(
      listOfCategories: categoryList,
    ));
  }

  _moveBackToInitial(BackToInitialEvent event, Emitter<FirstStageState> emit) {
    emit(FirstStageInitial());
  }

  _openFirstStage(
      OpenFirstStageEvent event, Emitter<FirstStageState> emit) async {
    emit(FirstStageLoadingState());
    List<Category> categoryList = await repo.getAllData();
    allData = categoryList;
    List<Map<String, dynamic>> dropdownList = categoryList
        .map((e) => {
              'value': '${e.categoryId} ${e.categoryName!.toCapitalized()}',
              'data': e,
            })
        .toList();
    emit(FirstStageOpenState(
      listCategories: categoryList,
      dropdownCategory: dropdownList,
    ));
  }

  _selectedCategory(
      FirstStageSelectedCategoryEvent event, Emitter<FirstStageState> emit) {
    List<Map<String, dynamic>> dropdownList = event.category.subCategories!
        .map((e) => {
              'value': '${e.codeId} ${e.name!.toCapitalized()}',
              'data': e,
            })
        .toList();
    emit(SelectedCategoryState(
      category: event.category,
      dropdownSubCategory: dropdownList,
    ));
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
    if (event.trashType == "AP" || event.trashType == "AN") {
      emit(FoundCodeState(
        title: event.title,
        trashCode: event.trashCode,
        trashType: event.trashType,
      ));
    } else {
      if (foundCategory != null) {
        emit(SecondStageOpenState(
          category: foundCategory,
          trashCode: event.trashCode,
          listOfCategories: event.listOfCategories,
          trashTitle: event.title,
          trashType: event.trashType,
        ));
      } else {
        add(CodeFoundEvent(newCode: event.trashCode));
      }
    }
  }

  _codeFound(CodeFoundEvent event, Emitter<FirstStageState> emit) async {
    if (event.title != null &&
        event.trashCode != null &&
        event.trashType != null) {
      if (event.isKnown != null) {
        emit(FoundCodeState(
          title: event.title!,
          trashCode: event.trashCode!,
          trashType: event.trashType!,
        ));
      } else {
        emit(FoundCodeState(
          title: event.title!,
          trashCode: event.trashCode!,
          trashType: event.trashType!,
        ));
      }
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
                  OpenThirdStageEvent(
                    trashTitle: item.itemName!,
                    listOfCategories: categoryList,
                    trashType: item.type!,
                    trashCode: item.code!,
                  ),
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
            listOfCategories: categoryList,
            trashType: event.trashType!,
            trashCode: event.trashCode!,
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
      listOfCategories: event.listOfCategories,
      trashCode: event.trashCode,
      trashType: event.trashType,
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
