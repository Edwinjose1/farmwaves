part of 'order_bloc.dart';

// import 'package:flutter/material.dart';

@immutable
sealed class OrderEvent {}
class FetchOrders extends OrderEvent {}
class StartPolling extends OrderEvent {}
