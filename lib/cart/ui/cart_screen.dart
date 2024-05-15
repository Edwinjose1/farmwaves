
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/order_deteails/detailsorderScreen.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/cart/widgets/medicinetile.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartBloc cartBloc = CartBloc();

  @override
  void initState() {
    super.initState();
    cartBloc.add(CartInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 237, 239, 245),
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
              Icons.arrow_back_ios, // Use the Cupertino-style back button icon
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: BlocConsumer<CartBloc, CartState>(
        bloc: cartBloc,
        listener: (context, state) {
          // Listener implementation if needed
        },
        builder: (context, state) {
          if (state is CartLoadingState) {
            return Center(
              child: CircularProgressIndicator(), // Circular Progress Indicator
            );
          } else if (state is CartSuccessState) {
            if (state.cartitems.isEmpty) {
              return const Center(
                child: Text(
                  'Cart is empty',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }
            double totalAmount = 0;
            for (var item in state.cartitems) {
              totalAmount += item.price * item.quantity;
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.cartitems.length,
                    itemBuilder: (context, index) {
                      final med = state.cartitems[index];

                      return MedicineTile(
                        medicine: med,
                        cartBloc: cartBloc,
                        onItemRemoved: rebuildScreen,
                      );
                    },
                  ),
                ),
                buildTotalAmount(totalAmount),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  color: Pallete.darkgreenColor,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItemDetailsPage(
                            medicalDetails: state.cartitems,
                            totalAmount: totalAmount,
                            selectedAddress:
                                "Your selected address here", // Pass the selected address here
                          ),
                        ),

                      );
                    },
                    child: const Text(
                      'Place order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  void rebuildScreen() {
    setState(() {});
  }


  Widget buildTotalAmount(double totalAmount) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Total Amount: $totalAmount Rs',
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}



Future<List<Medicine>> fetchMedicinesFromApi() async {
  final response =
      await http.get(Uri.parse('http://192.168.1.44:8080/api/products'));

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => Medicine.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load medicines from API');
  }
}