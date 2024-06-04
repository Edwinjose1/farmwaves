// ignore_for_file: must_be_immutable

part of 'cart_bloc.dart';

@immutable
sealed class CartEvent {}

class CartInitialEvent extends CartEvent{}
class RemoveEvent extends CartEvent{
    final String removingProductid;

  RemoveEvent(this.removingProductid);

}



class Cartitemnumber extends CartEvent{}

// class RemoveitemfromAddedcartEvent extends CartEvent {
  // final int removingProductid;

  // RemoveitemfromAddedcartEvent(this.removingProductid);
// }