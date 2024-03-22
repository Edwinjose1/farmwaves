import 'package:flutter/material.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/model/medicinedatamodel.dart';

class MedicineTile extends StatelessWidget {
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
                    'Company: ${medicine.company}',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            if (cartBloc != null)
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      cartBloc!.add(RemoveitemfromAddedcartEvent(
                          removingProduct: medicine));
                      onItemRemoved?.call();
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
                        onPressed: () {
                          if (medicine.quantity > 1) {
                            medicine.quantity--;
                            onItemRemoved?.call();
                          }
                        },
                        icon: Icon(Icons.remove, color: Colors.black),
                        iconSize: 20,
                      ),
                      Text(
                        '${medicine.quantity}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          medicine.quantity++;
                          onItemRemoved?.call();
                        },
                        icon: Icon(Icons.add),
                        iconSize: 20,
                        color: Colors.black,
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
