// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/data/healthtip.dart';
import 'package:flutter_application_0/data/liked_tips.dart';
import 'package:flutter_application_0/model/cartitemmodel.dart';
import 'package:flutter_application_0/model/healthtipdatamodel.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// const SAVE_KEY_NAME = 'UserLoggedIn';
part 'home_event.dart';
part 'home_state.dart';
 List<CartItem> cartitems = [];
  List<String> cartProductIds = [];
  List<String> matchingProductIds=[];
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeSearchClickedEvent>(homeSearchButtonClickedEvent);
    on<HomeTipLikedEvent>(homeTipLikedEvent);
    on<LikeditemPageNavigateEvent>(likeditemPageNavigateEvent);
    on<UploadPrescriptionEvent>(uploadPrescriptionEvent);
    on<ImageshowingPageEvent>(imageshowingPageEvent);
    //  on<ApressEvent>(carttiplikedevent);
     on<ApressEvent>(carttiplikedevent);

  }

  FutureOr<void> imageshowingPageEvent(
      ImageshowingPageEvent event, Emitter<HomeState> emit) {
          // ignore: avoid_print
          print("ImageshowingPageEvent");
    emit(ImageshowingPageActionstate());
  }

  FutureOr<void> uploadPrescriptionEvent(
      UploadPrescriptionEvent event, Emitter<HomeState> emit) {
  
    emit(UploadprescriptionActionstate());
  }
FutureOr<void> carttiplikedevent(
  ApressEvent event, Emitter<HomeState> emit) async {
  print('Starting cart initialization...');
  emit(PressAction(productIds: cartProductIds,matchingProductIds: matchingProductIds));
  try {
    final List<Medicine> medicines = await fetchMedicinesFromApi();
    // print('Fetched medicines: ${medicines.length}');

    final sharedPref = await SharedPreferences.getInstance();
    String? storedUserId = sharedPref.getString('user_id');
    if (storedUserId == null) {
      emit(CartErrorState(error: 'User ID not found in shared preferences') as HomeState);
      return;
    }
    // print('Stored user ID: $storedUserId');

    final response = await http.post(
      Uri.parse('http://${Pallete.ipaddress}:8000/api/cart/'),
      body: {'user_id': storedUserId},
    );

    print('API response status: ${response.statusCode}');
    print('API response body: ${response.body}');

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      cartitems.clear();
      // List<String> matchingProductIds = [];

      for (var item in data) {
        int productId = item['product_id'];
        int quantity = item['quantity'];

        Medicine? medicine = medicines.firstWhere((m) => m.id == productId);

        if (medicine != null) {
          cartitems.add(CartItem(
            productId: medicine.id.toString(),
            quantity: quantity,
          ));
          matchingProductIds.add(medicine.id.toString()); // Store matching product ID
        } else {
          // print('Medicine with product_id $productId not found.');
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

      emit(PressAction(productIds: cartProductIds,matchingProductIds: matchingProductIds));

      // emit(CartAddedActioinState(productIds: cartProductIds));

      // _emitCartProductIds(emit);
      print('Matching medicines: ${matchingMedicines.length}');
      // emit(HomeErrorState()(
      //     cartitems: matchingMedicines,
      //     matchingProductCount: matchingMedicines.length) as HomeState);

      // Return matching product IDs
      // return matchingProductIds;
    } else {
      emit(HomeErrorState(error: 'Failed to load cart data'));
    }
  } catch (e) {
    emit(HomeErrorState(error: 'Exception: $e'));
  }
}


  FutureOr<void> homeSearchButtonClickedEvent(
      HomeSearchClickedEvent event, Emitter<HomeState> emit) {
    print("search clicked");
    emit(HomeSearchState());
  }


  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
        
        emit(HomeTipsLikedActionState());
    emit(HomeLoadingState());
    // ignore: prefer_const_constructors
    await Future.delayed(Duration(seconds: 1));
    emit(HomeLoadedSuccessState(
        tipslists: HealtTipData.tipslists
            .map((e) => HealthTipDataModel(
                id: e['id'],
                heading: e['heading'],
                description: e['description'],
                imageUrl: e['imageUrl']))
            .toList()));
  }
}










FutureOr<void> homeTipLikedEvent(
    HomeTipLikedEvent event, Emitter<HomeState> emit) {
      
  // ignore: avoid_print
  print("Liked an event");

  // likeditems.add(event.LikedProducts);

  emit(HomeTipsLikedActionState());
}

FutureOr<void> likeditemPageNavigateEvent(
    LikeditemPageNavigateEvent event, Emitter<HomeState> emit) {
  print("Liked page");
  emit(LikeditemPageNavigateActionState());
}
