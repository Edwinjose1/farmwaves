import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/data/addcarted.dart';
import 'package:flutter_application_0/model/cartitemmodel.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_0/constants/pallete.dart';

import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItem> cartitems = [];
  List<String> cartProductIds = [];
  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>(cartInitialEvent);
    // on<CartTipLikedEvent>(carttiplikedevent);
    on<RemoveEvent>((event, emit) async {
      await _removeFromCartApi(event.removingProductid, emit);
    });
  }

  int value = 0;

  FutureOr<void> cartitemnumber(Cartitemnumber event, Emitter<CartState> emit,
      {required int val}) async {
    value = value + 1;
    emit((Cartitemnumberss(val: value)));
  }
//  void _emitCartProductIds(Emitter<CartState> emit) {
//     cartProductIds = cartitems.map((item) => item.productId).toList();
//     print('Emitting CartProductIdsState with productIds: $cartProductIds');
//     emit(CartProductIdsActionstate(productIds: cartProductIds));
//   }

  FutureOr<void> cartInitialEvent(
      CartInitialEvent event, Emitter<CartState> emit) async {
    // print('Starting cart initialization...');
    // emit(CartAddedActioinState(productIds: cartProductIds));
    try {
      final List<Medicine> medicines = await fetchMedicinesFromApi();
      // print('Fetched medicines: ${medicines.length}');

      final sharedPref = await SharedPreferences.getInstance();
      String? storedUserId = sharedPref.getString('user_id');
      if (storedUserId == null) {
        emit(CartErrorState(error: 'User ID not found in shared preferences'));
        return;
      }
      print('Stored user ID: $storedUserId');

      final response = await http.post(
        Uri.parse('http://${Pallete.ipaddress}:8000/api/cart/'),
        body: {'user_id': storedUserId},
      );

      // print('API response status: ${response.statusCode}');
      // print('API response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        cartitems.clear();

        for (var item in data) {
          int productId = item['product_id'];
          int quantity = item['quantity'];

          Medicine? medicine = medicines.firstWhere((m) => m.id == productId);

          if (medicine != null) {
            cartitems.add(CartItem(
              productId: medicine.id.toString(),
              quantity: quantity,
            ));
          } else {
            print('Medicine with product_id $productId not found.');
          }
        }

        List<CartMedicine> matchingMedicines = medicines
            .where((medicine) => cartitems.any(
                (cartItem) => cartItem.productId == medicine.id.toString()))
            .map((medicine) {
          int quantity = cartitems
              .firstWhere(
                  (cartItem) => cartItem.productId == medicine.id.toString())
              .quantity;
          return CartMedicine(
            id: medicine.id,
            name: medicine.name,
            price: medicine.price,
            company: medicine.company,
            quantity: quantity,
          );
        }).toList();
        cartProductIds = cartitems.map((item) => item.productId).toList();

        // emit(CartAddedActioinState(productIds: cartProductIds));

        // _emitCartProductIds(emit);
        // print('Matching medicines: ${matchingMedicines.length}');
        emit(CartSuccessState(
            cartitems: matchingMedicines,
            matchingProductCount: matchingMedicines.length));
      } else {
        emit(CartErrorState(error: 'Failed to load cart data'));
      }
    } catch (e) {
      emit(CartErrorState(error: 'Exception: $e'));
    }
  }

  Future<void> _removeFromCartApi(
      String productId, Emitter<CartState> emit) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      String? storedUserId = sharedPref.getString('user_id');
      if (storedUserId == null) {
        emit(CartErrorState(error: 'User ID not found'));
        return;
      }

      final response = await http.delete(
        Uri.parse(
            'http://${Pallete.ipaddress}:8000/api/cart/remove/$storedUserId/product/$productId/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      // If removal is successful, update the cart items and emit the updated state
      if (response.statusCode == 200) {
        cartitems.removeWhere((item) => item.productId == productId);
        // _emitCartProductIds(emit);
        // emit(CartItemRemovedState(productId: productId));
      } else {
        emit(CartErrorState(error: 'Failed to remove product from cart'));
      }
    } catch (e) {
      emit(CartErrorState(error: 'Exception: $e'));
    }
  }
}
// FutureOr<void> carttiplikedevent(
//     CartTipLikedEvent event, Emitter<CartState> emit) async {
//       print('myrrrrrrrrrrrrrrr');
//   emit(CartAddedActioinState());
// }


class CartMedicine extends Medicine {
  int quantity;

  CartMedicine({
    required int id,
    required String name,
    required double price,
    required String company,
    required this.quantity,
  }) : super(
            id: id,
            name: name,
            price: price,
            quantity: quantity,
            company: company);
}
