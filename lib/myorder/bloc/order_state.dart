part of 'order_bloc.dart';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/myorder/models/models.dart';

@immutable
sealed class OrderState {}

// final class OrderInitial extends OrderState {}
class OrderInitial extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoading extends OrderState {
  @override
  List<Object> get props => [];
}

class OrderLoaded extends OrderState {
  final List<OrderTileData> orders;

  OrderLoaded({required this.orders});

  @override
  List<Object> get props => [orders];
}

class OrderError extends OrderState {
  final String error;

  OrderError({required this.error});

  @override
  List<Object> get props => [error];
}