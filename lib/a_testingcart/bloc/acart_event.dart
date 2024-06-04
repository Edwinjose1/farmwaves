part of 'acart_bloc.dart';

@immutable
sealed class AcartEvent {}


class AddButtonclickedEvent extends AcartEvent{}
class RemoveButtonclickedEvent extends AcartEvent{}

class AcartInitialEvent extends AcartEvent{}