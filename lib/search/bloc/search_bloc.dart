import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter_application_0/data/addcarted.dart';
import 'package:meta/meta.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Medicine> allMedicines;
  final List<Medicine> cartitems;

  SearchBloc(this.allMedicines, this.cartitems) : super(SearchInitial()) {
    on<SearchQueryChanged>(_mapSearchQueryChangedToState);
    on<SearchitemaddedtocartEvent>(_mapSearchItemAddedToCartToState);
    on<LoadAllMedicines>(_mapLoadAllMedicinesToState);
    on<Searchitemaddedtocart>(searchitemaddedtocart);
  }




  void _mapRemoveItemFromCartToState(
      RemoveitemfromAddedcartEvent event, Emitter<SearchState> emit) {
    if (state is SearchLoaded) {
      final updatedMedicines =
          List<Medicine>.from((state as SearchLoaded).filteredMedicines);
      final index =
          updatedMedicines.indexWhere((medicine) => medicine == event.removingProduct);
      if (index != -1) {
        // updatedMedicines[index].isInCart = false; // Update isInCart to false
        emit(SearchLoaded(updatedMedicines));
        carteditems.remove(event.removingProduct); // Remove from carted items list
      }
    }
  }

  FutureOr<void> searchitemaddedtocart(
      Searchitemaddedtocart event, Emitter<SearchState> emit) {
    print("Entokkeya lokath nadakkane");
    emit(SearhedItemAddindToCartActionState());
  }

  void _mapSearchQueryChangedToState(
      SearchQueryChanged event, Emitter<SearchState> emit) {
    final query = event.query.trim().toLowerCase();
    final filteredMedicines = allMedicines.where((medicine) =>
        medicine.name.toLowerCase().contains(query) ||
        medicine.company.toLowerCase().contains(query));

    emit(SearchLoaded(filteredMedicines.toList()));
  }

//  / Inside your SearchBloc when adding an item to the cart
void _mapSearchItemAddedToCartToState(
    SearchitemaddedtocartEvent event, Emitter<SearchState> emit) {
  if (state is SearchLoaded) {
    final updatedMedicines = List<Medicine>.from((state as SearchLoaded).filteredMedicines);
    final index = updatedMedicines.indexWhere((medicine) => medicine == event.addingproduct);
    if (index != -1) {
      // updatedMedicines[index].isInCart = true;
      emit(SearhedItemAddindToCartActionState());
      emit(SearchLoaded(updatedMedicines));

carteditems.add(updatedMedicines[index]);
    }
  }
}


  void _mapLoadAllMedicinesToState(
      LoadAllMedicines event, Emitter<SearchState> emit) {
    emit(SearchLoaded(List<Medicine>.from(allMedicines)));
  }
}
