import 'package:flutter/material.dart';
import 'package:flutter_application_0/a_testingcart/bloc/acart_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Product extends StatefulWidget {
  const Product({super.key});

  @override
  State<Product> createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final AcartBloc cartbloc = AcartBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AcartBloc, AcartState>(
      bloc: cartbloc,
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Search'),
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.favorite_border)),
               IconButton(onPressed: () {}, icon: Icon(Icons.favorite))
            ],
          ),
        );
      },
    );
  }
}
