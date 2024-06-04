import 'package:flutter/material.dart';
import 'package:flutter_application_0/a_testingcart/bloc/acart_bloc.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';
import 'package:flutter_application_0/search/bloc/search_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onItemRemoved;
  final VoidCallback onCartChanged;
  final bool isInCart;
  final AcartBloc acartBloc;

  const MedicineTile({
    Key? key,
    required this.medicine,
    required this.onItemRemoved,
    required this.onCartChanged,
    required this.isInCart,
    required this.acartBloc,
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
                      //  await remove(id);

                      acartBloc.add(AddButtonclickedEvent());

                      BlocProvider.of<SearchBloc>(context).add(
                        SearchitemremoveocartEvent(removeprouct: medicine),
                      );

                      BlocProvider.of<CartBloc>(context)
                          .add(CartInitialEvent());
                    } else {
                      acartBloc.add(RemoveButtonclickedEvent());
                      // await addToCart(id, 1);
                      BlocProvider.of<SearchBloc>(context).add(
                        SearchitemaddedtocartEvent(addingproduct: medicine),
                      );

                      BlocProvider.of<CartBloc>(context)
                          .add(CartInitialEvent());

                      // Add this line
                    }
                    onCartChanged(); // Call the provided callback function
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
