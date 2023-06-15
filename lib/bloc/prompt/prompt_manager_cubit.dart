import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/category.dart';
import '../../model/second_stage_models/second_category.dart';

part 'prompt_manager_state.dart';

class PromptManagerCubit extends Cubit<PromptManagerState> {
  PromptManagerCubit() : super(PromptManagerInitial());

  void backToInitial() => emit(PromptManagerInitial());

  void activatePromt({
    required SecondCategory category,
    required String trashCode,
    required List<Category> listOfCategories,
    required String trashTitle,
    required String trashType,
  }) {
    emit(PromptState(
      category: category,
      trashType: trashType,
      trashCode: trashCode,
      trashTitle: trashTitle,
      listOfCategories: listOfCategories,
    ));
  }
}
