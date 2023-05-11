import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../model/category.dart';

part 'search_manager_state.dart';

class SearchManagerCubit extends Cubit<SearchManagerState> {
  SearchManagerCubit() : super(SearchManagerInitial());

  void openSearch(
    String searchString,
    List<Category> listOfCategories,
  ) =>
      emit(SearchOpenState(
        searchString: searchString,
        listOfCategories: listOfCategories,
      ));
}
