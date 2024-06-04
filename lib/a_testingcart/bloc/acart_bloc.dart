import 'dart:async';
import 'dart:ffi';

import 'package:bloc/bloc.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:meta/meta.dart';

part 'acart_event.dart';
part 'acart_state.dart';

class AcartBloc extends Bloc<AcartEvent, AcartState> {
  AcartBloc() : super(AcartInitial()) {
    // on<AcartEvent>((event, emit) {});
    on<AcartInitialEvent>(acartInitialEvent);
    on<RemoveButtonclickedEvent>(removeButtonclickedEvent);
    on<AddButtonclickedEvent>(addButtonclickedEvent);
  }

 FutureOr<void> acartInitialEvent(AcartInitialEvent event, Emitter<AcartState>emit)
 {

 }
  FutureOr<void> removeButtonclickedEvent(RemoveButtonclickedEvent event, Emitter<AcartState>emit){
    print("product Wistlist removed");
  }
  FutureOr<void> addButtonclickedEvent(AddButtonclickedEvent event, Emitter<AcartState>emit){
    print(" product Wistlist added");
  }

}
