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


class CartTipLikedEvent extends SearchEvent{}

class SearchitemremoveocartEvent extends SearchEvent {
  final Medicine removeprouct;

  SearchitemremoveocartEvent({required this.removeprouct});
}


class SearchCartEvent extends SearchEvent{}
class Searchitemaddedtocart extends SearchEvent{
  
}

class RemoveitemfromAddedcartEvent extends SearchEvent {
  final Medicine removingProduct;

  RemoveitemfromAddedcartEvent({required this.removingProduct});
}