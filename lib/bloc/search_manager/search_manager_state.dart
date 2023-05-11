part of 'search_manager_cubit.dart';

abstract class SearchManagerState extends Equatable {
  const SearchManagerState();

  @override
  List<Object> get props => [];
}

class SearchManagerInitial extends SearchManagerState {}

class SearchOpenState extends SearchManagerState {
  final String searchString;
  final List<Category> listOfCategories;

  const SearchOpenState({
    required this.listOfCategories,
    required this.searchString,
  });

  @override
  List<Object> get props => [
        searchString,
        listOfCategories,
      ];
}
