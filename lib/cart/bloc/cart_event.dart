part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class CartInitialEvent extends CartEvent{}

class RemoveitemfromAddedcartEvent extends CartEvent {
    final Medicine removingProduct;
    RemoveitemfromAddedcartEvent({required this.removingProduct});
  }
