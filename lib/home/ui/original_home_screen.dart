
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/chat_screen.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/home/widgets/card_tip.dart';
import 'package:flutter_application_0/home/widgets/main_heading.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Home1 extends StatefulWidget {
  const Home1({Key? key}) : super(key: key);

  @override
  State<Home1> createState() => _Home1State();
}

class _Home1State extends State<Home1> {
  late HomeBloc homeBloc;
  int cartItemCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    homeBloc = HomeBloc()
      ..add(HomeInitialEvent())
      ..add(ApressEvent());
  }

 

  @override
  Widget build(BuildContext context) {
    return BlocProvider<HomeBloc>(
      create: (context) => homeBloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is PressAction) {
            setState(() {
              cartItemCount = state.productIds.length;
            });
            print('workayillale${state.productIds}');
          }
        },
        builder: (context, state) {
          if (state is HomeLoadingState) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is HomeTipsLikedActionState) {
            // Handle HomeTipsLikedActionState
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (state is HomeLoadedSuccessState) {
            final successState = state;
            return SafeArea(
              child: Scaffold(
                backgroundColor: const Color.fromARGB(255, 237, 239, 245),
                body: Column(
                  children: [
                    MainHeading(
                      homeBloc: homeBloc,
                      cartItemCount: cartItemCount,
                      ctx: context,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            successState.tipslists.length,
                            (index) {
                              final tip = successState.tipslists[index];
                              return HealthTipItem(
                                healthTipDataModel: tip,
                                homeBloc: homeBloc,
                                id: tip.id,
                                heading: tip.heading,
                                description: tip.description,
                                imageUrl: tip.imageUrl,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Pallete.darkgreenColor,
                  child: const Icon(Icons.message_rounded,
                      color: Color.fromARGB(255, 179, 178, 178)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage()),
                    );
                  },
                ),
              ),
            );
          } else {
            return Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
