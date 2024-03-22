import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_0/data/healthtip.dart';
import 'package:flutter_application_0/data/liked_tips.dart';
import 'package:flutter_application_0/model/healthtipdatamodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeSearchClickedEvent>(homeSearchButtonClickedEvent);
    on<HomeTipLikedEvent>(homeTipLikedEvent);
    on<LikeditemPageNavigateEvent>(likeditemPageNavigateEvent);
    on<UploadPrescriptionEvent>(uploadPrescriptionEvent);
    on<ImageshowingPageEvent>(imageshowingPageEvent);
  }

  FutureOr<void> imageshowingPageEvent(
      ImageshowingPageEvent event, Emitter<HomeState> emit) {
          print("ImageshowingPageEvent");
    emit(ImageshowingPageActionstate());
  }

  FutureOr<void> uploadPrescriptionEvent(
      UploadPrescriptionEvent event, Emitter<HomeState> emit) {
  
    emit(UploadprescriptionActionstate());
  }

  FutureOr<void> homeSearchButtonClickedEvent(
      HomeSearchClickedEvent event, Emitter<HomeState> emit) {
    print("search clicked");
    emit(HomeSearchState());
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    await Future.delayed(Duration(seconds: 1));
    emit(HomeLoadedSuccessState(
        tipslists: HealtTipData.tipslists
            .map((e) => HealthTipDataModel(
                id: e['id'],
                heading: e['heading'],
                description: e['description'],
                imageUrl: e['imageUrl']))
            .toList()));
  }
}

FutureOr<void> homeTipLikedEvent(
    HomeTipLikedEvent event, Emitter<HomeState> emit) {
      
  print("Liked an event");

  likeditems.add(event.LikedProducts);

  emit(HomeTipsLikedActionState());
}

FutureOr<void> likeditemPageNavigateEvent(
    LikeditemPageNavigateEvent event, Emitter<HomeState> emit) {
  print("Liked page");
  emit(LikeditemPageNavigateActionState());
}
