part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

class CartActionState extends CartState {}

class CartInitial extends CartState {}
class CartLoadingState extends CartState {
  CartLoadingState();
}

class CartSuccessState extends CartState { 
  final List<Medicine> cartitems;

  CartSuccessState({required this.cartitems});

  // Factory constructor to create a new CartSuccessState with updated cart items
  factory CartSuccessState.updatedList(List<Medicine> updatedItems) {
    return CartSuccessState(cartitems: updatedItems);
  }  
}

class CartErrorState extends CartState {
  final String error;

  CartErrorState({required this.error});
}
