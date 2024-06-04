
part of 'item_bloc.dart';

abstract class ItemState {}

class ItemInitial extends ItemState {}

class ItemStatusLoaded extends ItemState {
  final String status;

  ItemStatusLoaded(this.status);
}

class ItemDetailsError extends ItemState {}
