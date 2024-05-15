// item_event.dart
// part of 'item_bloc.dart';

// @immutable
// sealed class ItemEvent {}

// abstract class EnablePaymentEvent {}



// class ItemdetailsEvent extends ItemEvent{}
part of 'item_bloc.dart';

abstract class ItemdetailsEvent {}

class FetchItemStatus extends ItemdetailsEvent {}
