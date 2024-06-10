// order_bloc.dart
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/myorder/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<FetchOrders>(_fetchOrders);
    _startPolling();
  }

  Timer? _pollingTimer;

  void _startPolling() {
    _pollingTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      add(FetchOrders());
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }

  Future<void> _fetchOrders(FetchOrders event, Emitter<OrderState> emit) async {
    emit(OrderLoading());
    try {
      final orders = await fetchOrders();
      emit(OrderLoaded(orders: orders));
    } catch (e) {
      emit(OrderError(error: e.toString()));
    }
  }

  Future<List<OrderTileData>> fetchOrders() async {
    String? userId = await getUserIdFromSharedPreferences();
    final response = await http.get(Uri.parse('http://${Pallete.ipaddress}:8000/api/orders/user/$userId/'));

    if (response.statusCode == 200) {
      List<dynamic> orderList = json.decode(response.body);
      return orderList.map((order) => OrderTileData.fromJson(order)).toList();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<String?> getUserIdFromSharedPreferences() async {
    SharedPreferences sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString('user_id');
  }
}