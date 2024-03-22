part of 'liked_bloc.dart';

@immutable
sealed class LikedState {}

class LikedActionState extends LikedState {}

final class LikedInitial extends LikedState {}

class LikedSucessState extends LikedState {
  final List<HealthTipDataModel> likeditems;

  LikedSucessState({required this.likeditems});
  

}
