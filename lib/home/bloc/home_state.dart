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

class HomeErrorState extends HomeState {}

class HomeSearchState extends HomeActionState {}

class HomeTipLikedState extends HomeState{

}

class HomeTipsLikedActionState extends HomeActionState{}


class LikeditemPageNavigateActionState extends HomeActionState{

}
class PrescriptionUploadRequestedState extends HomeState {}


class UploadprescriptionActionstate extends HomeActionState {}

class Imageloadstate extends HomeState{}

class ImageshowingPageActionstate extends HomeActionState{}