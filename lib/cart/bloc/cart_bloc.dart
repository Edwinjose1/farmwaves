import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_application_0/data/addcarted.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';
class CartBloc extends Bloc<CartEvent, CartState> {
  List<Medicine> cartitems = [];

  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>(_cartInitialEvent);
    on<RemoveitemfromAddedcartEvent>(_removeItemFromCart);
  }
   
  void _cartInitialEvent(CartInitialEvent event, Emitter<CartState> emit) {
    emit(CartSucessState(cartitems: carteditems));
  }
void _removeItemFromCart(RemoveitemfromAddedcartEvent event, Emitter<CartState> emit) {
  // Remove the item from the data source
  removeFromCart(event.removingProduct);
  
  // Filter out the removed item from the cartitems list
  final updatedCartItems = cartitems.where((item) => item != event.removingProduct).toList();
  
  // Emit a new state with the updated cartitems list
    // emit(CartSucessState(cartitems: updatedCartItems));

  // emit(CartSucessState.updatedList(updatedCartItems));
}

  
}

// Function to remove item from data source
void removeFromCart(Medicine removingProduct) {
  // Implement logic to remove item from your data source
  // For example, if `carteditems` is your data source:
  carteditems.remove(removingProduct);
}
