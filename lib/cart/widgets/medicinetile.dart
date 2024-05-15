import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicineTile extends StatefulWidget {
  final Medicine medicine;
  final CartBloc? cartBloc;
  final VoidCallback? onItemRemoved;

  const MedicineTile({
    Key? key,
    required this.medicine,
    this.cartBloc,
    this.onItemRemoved,
  }) : super(key: key);

  @override
  State<MedicineTile> createState() => _MedicineTileState();
}

class _MedicineTileState extends State<MedicineTile> {
  late SharedPreferences sharedpref;
  late String? userId;
  bool _isButtonDisabled = false;

  @override
  void initState() {
    super.initState();
    initializeSharedPreferences();
  }

  Future<void> initializeSharedPreferences() async {
    sharedpref = await SharedPreferences.getInstance();
    String? storeduserid = sharedpref.getString('user_id');
    userId = storeduserid;
  }

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
                    widget.medicine.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'MRP: ${widget.medicine.price} Rs',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Company: ${widget.medicine.company}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            if (widget.cartBloc != null)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.cartBloc!.add(RemoveitemfromAddedcartEvent(
                          removingProduct: widget.medicine));
                      widget.onItemRemoved?.call();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Pallete.darkgreenColor,
                      ),
                      height: 30,
                      width: 100,
                      child: Center(
                        child: Text(
                          'Remove ',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                                setState(() {
                                  _isButtonDisabled = true;
                                });
                                if (widget.medicine.quantity > 1) {
                                  widget.onItemRemoved?.call();
                                  updateQuantity(widget.medicine.id, userId!,
                                      widget.medicine.quantity - 1);
                                  widget.cartBloc!.add(CartInitialEvent());
                                  await Future.delayed(
                                      Duration(milliseconds: 200));
                                }
                                setState(() {
                                  _isButtonDisabled = false;
                                });
                              },
                        icon: Icon(Icons.remove, color: Colors.black),
                        iconSize: 20,
                      ),
                      Text(
                        '${widget.medicine.quantity}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: _isButtonDisabled
                            ? null
                            : () async {
                                setState(() {
                                  _isButtonDisabled = true;
                                });
                                if (widget.medicine.quantity >= 1) {
                                  widget.onItemRemoved?.call();
                                  updateQuantity(widget.medicine.id,userId!,
                                      widget.medicine.quantity + 1);
                                  widget.cartBloc!.add(CartInitialEvent());
                                  await Future.delayed(
                                      Duration(milliseconds: 200));
                                }
                                setState(() {
                                  _isButtonDisabled = false;
                                });
                              },
                        icon: Icon(Icons.add, color: Colors.black),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

Future<void> updateQuantity(
    int productId, String userId, int quantity) async {
  final jsonBody = json.encode({
    'user_id': userId,
    'product_id': productId,
    'quantity': quantity,
  });

  final response = await http.put(
    Uri.parse('http://192.168.1.44:8000/api/cart/update/'),
    body: jsonBody,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update quantity');
  }
}
