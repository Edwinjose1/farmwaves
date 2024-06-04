part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<HealthTipDataModel> tipslists;
  HomeLoadedSuccessState({required this.tipslists});
}

// class HomeErrorState extends HomeState {}
class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}

class HomeSearchState extends HomeActionState {}

class HomeTipLikedState extends HomeState{

}
class Cartlikedstate extends HomeState{}

class HomeTipsLikedActionState extends HomeActionState{}


class LikeditemPageNavigateActionState extends HomeActionState{

}
class PrescriptionUploadRequestedState extends HomeState {}


class UploadprescriptionActionstate extends HomeActionState {}

class PressAction extends HomeActionState  {
  final Set<String> productIds;
  final List<String> matchingProductIds;

  PressAction({required List<String> productIds, required this.matchingProductIds})
      : productIds = productIds.toSet();

  @override
  List<Object> get props => [productIds, matchingProductIds];
}

class Imageloadstate extends HomeState{}

class ImageshowingPageActionstate extends HomeActionState{}