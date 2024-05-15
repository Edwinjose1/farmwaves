import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/data/addcarted.dart';
import 'package:flutter_application_0/model/cartitemmodel.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  List<CartItem> cartitems = [];

  CartBloc() : super(CartInitial()) {
    on<CartInitialEvent>(_cartInitialEvent);
    on<RemoveitemfromAddedcartEvent>(_removeItemFromCart);
  }

// ...
  void _cartInitialEvent(
      CartInitialEvent event, Emitter<CartState> emit) async {
        print('helooooooooo');
    try {
      // Fetch medicines from the API
      final List<Medicine> medicines = await fetchMedicinesFromApi();
      print(medicines[1].name);

      // Fetch data from the API without passing user ID in the URL
       final sharedpref = await SharedPreferences.getInstance();
        String? storeduserid = sharedpref.getString('user_id');
        print(storeduserid);
      String userId = storeduserid.toString(); // You can replace "1" with the actual user ID
      print("sfsdfsf");
      print("${userId}jjjj");
      final response = await http.post(
        Uri.parse('http://192.168.1.44:8000/api/cart/'),
        body: {'user_id': userId}, // Send user ID in the request body
      );

      if (response.statusCode == 200) {
        // If the request is successful, parse the response 
        // and add product_ids to cartItems
        final List<dynamic> data = json.decode(response.body);
        List<CartItem> cartItems = [];
        print("aljdflakjsdfkjas${cartitems}");

        for (var item in data) {
          int productId = item['product_id'];
          int quantity = item['quantity'];

          // Find the corresponding Medicine object based on productId
          Medicine? medicine = medicines.firstWhere((m) => m.id == productId);

          if (medicine != null) {
            // If a matching Medicine object is found, add it to cartItems
            cartItems.add(CartItem(
              productId: medicine.id.toString(),
              quantity: quantity,
            ));
          } else {
            // Handle the case where no matching Medicine object is found
            print('Medicine with product_id $productId not found.');
          }
        }

        // Get a list of CartMedicine instances that match the product_ids in cartItems
        List<CartMedicine> matchingMedicines = medicines
            .where((medicine) => cartItems.any(
                (cartItem) => cartItem.productId == medicine.id.toString()))
            .map((medicine) {
          int quantity = cartItems
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

        print(
            matchingMedicines); // Print the list of matching Medicine instances

        emit(CartSuccessState(cartitems: matchingMedicines));
      } else {
        // If the request fails, emit an error state
        emit(CartErrorState(error: 'Failed to load cart data'));
      }
    } catch (e) {
      // If an exception occurs, emit an error state
      emit(CartErrorState(error: 'Exception: $e'));
    }
  }

  void _removeItemFromCart(
      RemoveitemfromAddedcartEvent event, Emitter<CartState> emit) {
    // Remove the item from the data source
    removeFromCart(event.removingProduct);

    // Filter out the removed item from the cartitems list
    final updatedCartItems =
        cartitems.where((item) => item != event.removingProduct).toList();

    // Emit a new state with the updated cartitems list
    // emit(CartSuccessState(cartitems: updatedCartItems));
  }
}

// Function to remove item from data source
void removeFromCart(Medicine removingProduct) {
  // Implement logic to remove item from your data source
  // For example, if `carteditems` is your data source:
  carteditems.remove(removingProduct);
}

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
