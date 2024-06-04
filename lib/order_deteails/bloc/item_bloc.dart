import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'item_event.dart';
part 'item_state.dart';
class ItemdetailsBloc extends Bloc<ItemdetailsEvent, ItemState> {
  ItemdetailsBloc() : super(ItemInitial()) {
    on<ItemdetailsEvent>(
        _itemdetailsEvent);
  }

Stream<void> _itemdetailsEvent(ItemdetailsEvent event, Emitter<ItemState> emit) async* {
  if (event is FetchItemStatus) {
    try {
      final response = await http.get(Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/'));
      if (response.statusCode == 200) {
        // ignore: avoid_print
        print("hai its working");
        final data = jsonDecode(response.body);
        final status = data['status'];
        yield ItemStatusLoaded(status);
      } else {
        yield ItemDetailsError();
      }
    } catch (e) {
      yield ItemDetailsError();
    }
  }
}

}

