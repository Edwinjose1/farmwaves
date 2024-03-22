part of 'liked_bloc.dart';

@immutable
sealed class LikedEvent {}

class LikedinitialEvent extends LikedEvent {}

class LikeRemoveFromCartEvent extends LikedEvent {
  final HealthTipDataModel healthTipDataModel;

  LikeRemoveFromCartEvent({required this.healthTipDataModel});
}
