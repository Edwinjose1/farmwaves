import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/data/addcarted.dart';
import 'package:flutter_application_0/data/medicinedata.dart';
import 'package:flutter_application_0/search/bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchBloc(dummyMedicines, carteditems),
      child: SearchScreenContent(),
    );
  }
}

class SearchScreenContent extends StatefulWidget {
  @override
  _SearchScreenContentState createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.add(LoadAllMedicines());
  }

  void rebuildScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (previous, current) => current is SearchActionState,
      buildWhen: (previous, current) => current is! SearchActionState,
      builder: (context, state) {
        if (state is SearchLoaded) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Pallete.whiteColor,
                leading: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    color: Colors.white,
                    padding: EdgeInsets.all(8.0), // Adjust padding as needed
                    child: Icon(
                      Icons
                          .arrow_back_ios, // Use the Cupertino-style back button icon
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              backgroundColor: Color.fromARGB(255, 237, 239, 245),
              body: Column(
                children: [
                  // Your top container widget
                  Container(
                    height: 80,
                    width: double.infinity,
                    color: Pallete.greenColor,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                              child: TextField(
                                onChanged: (query) {
                                  searchBloc.add(SearchQueryChanged(query));
                                },
                                decoration: InputDecoration(
                                  prefixText:
                                      "     ", // Add space before cursor
                                  suffixIcon: Icon(
                                    Icons.search,
                                    color: Colors.white,
                                  ),
                                  labelStyle: TextStyle(color: Colors.white),
                                  labelText: "Search here....",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  floatingLabelStyle: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    borderSide: BorderSide(
                                      style: BorderStyle.solid,
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.filteredMedicines.length,
                      itemBuilder: (context, index) {
                        final medicine = state.filteredMedicines[index];

                        // Check if the medicine is in the cart
                        final isInCart = carteditems.contains(medicine);

                        // Update the isInCart property of the medicine
                        medicine.isInCart = isInCart;

                        return MedicineTile(
                          medicine: medicine,
                          onItemRemoved:
                              rebuildScreen, // Pass callback function
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Container(); // Placeholder for other states
        }
      },
    );
  }
}

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onItemRemoved; // Define callback function

  const MedicineTile({
    Key? key,
    required this.medicine,
    required this.onItemRemoved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 100,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'MRP: ${medicine.price} Rs',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Company ${medicine.company}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    if (carteditems.contains(medicine)) {
                      // Remove the item from the cart
                      carteditems.remove(medicine);
                      // Call the callback function to rebuild the screen
                      onItemRemoved();
                    } else {
                      // Dispatch the SearchItemAddedToCart event to the bloc
                      BlocProvider.of<SearchBloc>(context).add(
                          SearchitemaddedtocartEvent(addingproduct: medicine));
                    }
                  },
                  icon: Icon(
                    carteditems.contains(medicine)
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                    color: carteditems.contains(medicine)
                        ? Colors.teal
                        : Colors.black,
                  ),
                  iconSize: 30,
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
