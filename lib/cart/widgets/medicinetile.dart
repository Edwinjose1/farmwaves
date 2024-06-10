import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MedicineTile extends StatefulWidget {
  final Medicine medicine;
  final CartBloc? cartBloc;
  final VoidCallback? onItemRemoved;
  final BuildContext ctx;

  const MedicineTile({
    Key? key,
    required this.medicine,
    required this.ctx,
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
    userId = sharedpref.getString('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 100,
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.medicine.name,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'MRP: ${widget.medicine.price} Rs',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Company: ${widget.medicine.company}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            if (widget.cartBloc != null)
              Column(
                children: [
                  GestureDetector(
                    onTap: _isButtonDisabled
                        ? null
                        : () async {
                            setState(() {
                              _isButtonDisabled = true;
                            });
                            await remove();
                            widget.cartBloc!.add(CartInitialEvent());
                            BlocProvider.of<HomeBloc>(widget.ctx)
                                .add(ApressEvent());
                            ScaffoldMessenger.of(widget.ctx).showSnackBar(
                              SnackBar(
                                content: const Text('Item removed successfully'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                            setState(() {
                              _isButtonDisabled = false;
                            });
                          },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Pallete.darkgreenColor,
                      ),
                      height: 30,
                      width: 100,
                      child: const Center(
                        child: Text(
                          'Remove',
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
                                  await updateQuantity(
                                      widget.medicine.id,
                                      userId!,
                                      widget.medicine.quantity - 1);
                                  widget.cartBloc!.add(CartInitialEvent());
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                }
                                setState(() {
                                  _isButtonDisabled = false;
                                });
                              },
                        icon: const Icon(Icons.remove, color: Colors.black),
                        iconSize: 20,
                      ),
                      Text(
                        '${widget.medicine.quantity}',
                        style: const TextStyle(
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
                                if (widget.medicine.quantity < 10) {
                                  widget.onItemRemoved?.call();
                                  await updateQuantity(
                                      widget.medicine.id,
                                      userId!,
                                      widget.medicine.quantity + 1);
                                  widget.cartBloc!.add(CartInitialEvent());
                                  await Future.delayed(
                                      const Duration(milliseconds: 200));
                                }
                                setState(() {
                                  _isButtonDisabled = false;
                                });
                              },
                        icon: const Icon(Icons.add, color: Colors.black),
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

  Future<void> remove() async {
    final sharedpref = await SharedPreferences.getInstance();
    String? storeduserid = sharedpref.getString('user_id');

    http.Response response = await http.delete(
      Uri.parse(
          'http://${Pallete.ipaddress}:8000/api/cart/remove/$storeduserid/product/${widget.medicine.id}/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      print('Product removed from cart successfully.');
    } else {
      print('Failed to remove product from cart. Error: ${response.body}');
    }
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
    Uri.parse('http://${Pallete.ipaddress}:8000/api/cart/update/'),
    body: jsonBody,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to update quantity');
  }
}
