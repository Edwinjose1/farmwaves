import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_application_0/data/liked_tips.dart';
import 'package:flutter_application_0/model/healthtipdatamodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



part 'liked_event.dart';
part 'liked_state.dart';

class LikedBloc extends Bloc<LikedEvent, LikedState> {
  LikedBloc() : super(LikedInitial()) {
   on<LikedinitialEvent>(likedinitialEvent);
  }
     FutureOr<void> likedinitialEvent(
      LikedinitialEvent event,Emitter<LikedState> emit){
        // ignore: avoid_print
        print('HAI DA ENTHA ITHU INGANE');
        emit(LikedSucessState(likeditems: likeditems));
      }
}
