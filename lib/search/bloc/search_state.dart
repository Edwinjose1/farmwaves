part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

abstract class SearchActionState extends SearchState {}

class SearchInitial extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Medicine> filteredMedicines;

  SearchLoaded(this.filteredMedicines);
}


class SearhedItemAddindToCartActionState extends SearchActionState {}
