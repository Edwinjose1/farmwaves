part of 'search_bloc.dart';

@immutable
sealed class SearchEvent {}

class LoadAllMedicines extends SearchEvent {}

class SearchQueryChanged extends SearchEvent {
  final String query;

  SearchQueryChanged(this.query);
}


class SearchitemaddedtocartEvent extends SearchEvent {
  final Medicine addingproduct;

  SearchitemaddedtocartEvent({required this.addingproduct});
}


class Searchitemaddedtocart extends SearchEvent{
  
}

class RemoveitemfromAddedcartEvent extends SearchEvent {
  final Medicine removingProduct;

  RemoveitemfromAddedcartEvent({required this.removingProduct});
}