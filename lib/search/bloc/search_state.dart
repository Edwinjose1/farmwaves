part of 'search_bloc.dart';

@immutable
sealed class SearchState {}

abstract class SearchActionState extends SearchState {}

class SearchInitial extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Medicine> filteredMedicines;

  SearchLoaded(this.filteredMedicines);
}

class CartAddedActioinState extends SearchActionState{
  
}

// class HomeErrorState extends HomeState {}
class SearchErorrstate extends SearchState {
  final String error;

  SearchErorrstate({required this.error});

  @override
  List<Object?> get props => [error];
}

class SearhedItemAddindToCartActionState extends SearchActionState {}

class SearhedItemRemoveToCartActionState extends SearchActionState {}
