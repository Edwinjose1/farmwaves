
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeSearchClickedEvent extends HomeEvent {}





class HomeTipLikedEvent extends HomeEvent {
  final HealthTipDataModel LikedProducts;

  HomeTipLikedEvent({required this.LikedProducts});
}











class LikeditemPageNavigateEvent extends HomeEvent {}



class UploadPrescriptionEvent extends HomeEvent {}


class ImageshowingPageEvent extends HomeEvent{}