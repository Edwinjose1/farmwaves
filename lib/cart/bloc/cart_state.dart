part of 'cart_bloc.dart';

@immutable
sealed class CartState {}

class CartActionState extends CartState {}

final class CartInitial extends CartState {}

// class CartSucessState extends CartState{
//   final List<Medicine> cartitems;
//   CartSucessState({required this.cartitems});
// }
class CartSucessState extends CartState {
  final List<Medicine> cartitems;

  CartSucessState({required this.cartitems});

  // Factory constructor to create a new CartSucessState with updated cart items
  factory CartSucessState.updatedList(List<Medicine> updatedItems) {
    return CartSucessState(cartitems: updatedItems);
  }
}