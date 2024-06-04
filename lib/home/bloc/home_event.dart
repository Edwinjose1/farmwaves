
part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeSearchClickedEvent extends HomeEvent {}





class HomeTipLikedEvent extends HomeEvent {
  // ignore: non_constant_identifier_names
  // final HealthTipDataModel LikedProducts;

  // ignore: non_constant_identifier_names
  // HomeTipLikedEvent({required this.LikedProducts});
}

class LikeditemPageNavigateEvent extends HomeEvent {}



class UploadPrescriptionEvent extends HomeEvent {}
class ApressEvent extends HomeEvent{}

class ImageshowingPageEvent extends HomeEvent{}