import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/data/addcarted.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/search/bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Set<String> matchingProductIds = {};

class SearchScreen extends StatelessWidget {
  final BuildContext parentContext;

  const SearchScreen({super.key, required this.parentContext});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Medicine>>(
      future: fetchMedicinesFromApi(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => HomeBloc()
                  ..add(HomeInitialEvent()), // Provide HomeBloc here
              ),
              BlocProvider(
                create: (context) => SearchBloc(snapshot.data!, cartitems),
              ),
              BlocProvider(
                create: (context) => CartBloc()..add(CartInitialEvent()),
              ),
            ],
            child: SearchScreenContent(ctx: parentContext),
          );
        }
      },
    );
  }

  Future<List<Medicine>> fetchMedicinesFromApi() async {
    final response = await http
        .get(Uri.parse('http://${Pallete.ipaddress}:8080/api/products'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Medicine.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load medicines from API');
    }
  }
}

class SearchScreenContent extends StatefulWidget {
  final BuildContext ctx;

  const SearchScreenContent({super.key, required this.ctx});
  @override
  _SearchScreenContentState createState() => _SearchScreenContentState();
}

class _SearchScreenContentState extends State<SearchScreenContent> {
  late SearchBloc searchBloc;
  bool isLoading = true;
  late HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.add(LoadAllMedicines());
    homeBloc = BlocProvider.of<HomeBloc>(context);
    _cartInitialEvent();
  }

  void rebuildScreen() {
    print('rebuilded');
    searchBloc = BlocProvider.of<SearchBloc>(context);
    searchBloc.add(LoadAllMedicines());
    _cartInitialEvent();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Home1()),
        );
        return false;
      },
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchActionState) {
            // handle action state if needed
          }
        },
        buildWhen: (previous, current) => current is! SearchActionState,
        builder: (context, state) {
          if (isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is SearchLoaded) {
            return SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Pallete.whiteColor,
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home1()),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                backgroundColor: Color.fromARGB(255, 237, 239, 245),
                body: Column(
                  children: [
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
                                    prefixText: "     ",
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
                          final isInCart =
                              matchingProductIds.contains(medicine.id.toString());
                          return MedicineTile(
                            ctx: widget.ctx,
                            homeBloc: homeBloc,
                            medicine: medicine,
                            onItemRemoved: rebuildScreen,
                            onCartChanged: rebuildScreen,
                            isInCart: isInCart,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }


  @override
  void dispose() {
    matchingProductIds.clear();
    super.dispose();
  }

  void _cartInitialEvent() async {
    final List<Medicine> medicines = await fetchMedicinesFromApi();

    final sharedpref = await SharedPreferences.getInstance();
    String? storeduserid = sharedpref.getString('user_id');
    String userId = storeduserid.toString();
    final response = await http.post(
      Uri.parse('http://${Pallete.ipaddress}:8000/api/cart/'),
      body: {'user_id': userId},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      for (var item in data) {
        int productId = item['product_id'];
        Medicine medicine = medicines.firstWhere(
          (m) => m.id == productId,
          orElse: () => Medicine(
            id: -1,
            name: 'Unknown',
            price: 0,
            company: 'Unknown',
          ),
        );
        if (medicine.id != -1) {
          matchingProductIds.add(medicine.id.toString());
        } else {
          print('Medicine with product_id $productId not found.');
        }
      }
      setState(() {
        isLoading = false;
      });
    }
  }
}

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onItemRemoved;
  final VoidCallback onCartChanged;
  final bool isInCart;
  final HomeBloc homeBloc;
  final BuildContext ctx;

  const MedicineTile({
    Key? key,
    required this.ctx,
    required this.homeBloc,
    required this.medicine,
    required this.onItemRemoved,
    required this.onCartChanged,
    required this.isInCart,
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
                  onPressed: () async {
                    String id = medicine.id.toString();
                    if (isInCart) {
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(content: Text('Product is in cart')),
                      // );
                      //  SnackBar(content: Text("Item is  in cart"));
                      onCartChanged();
                    } else {
                     
                      await addToCart(id, 1);
                       BlocProvider.of<HomeBloc>(ctx).add(ApressEvent());
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //       content:
                      //           Text('Product added to cart successfully.')),
                      // );
                      // homeBloc.add(ApressEvent());
                      onCartChanged();
                    }
                  },
                  icon: Icon(
                    isInCart
                        ? Icons.remove_shopping_cart
                        : Icons.add_shopping_cart,
                    color: isInCart ? Colors.teal : Colors.black,
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

Future<void> addToCart(String productId, int quantity) async {
  final sharedpref = await SharedPreferences.getInstance();
  String? storeduserid = sharedpref.getString('user_id');
  String userId = storeduserid.toString();
  Map<String, dynamic> requestData = {
    'product_id': productId,
    'quantity': quantity.toString(),
    'user_id': userId
  };

  String requestBody = json.encode(requestData);

  http.Response response = await http.post(
    Uri.parse('http://${Pallete.ipaddress}:8000/api/cart/add/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: requestBody,
  );

  if (response.statusCode == 201) {
    print('Product added to cart successfully.');
  } else {
    print('Failed to add product to cart. Error: ${response.body}');
  }
}
