
import 'package:flutter/material.dart';
import 'package:flutter_application_0/myorder/screen/myorders.dart';
import 'package:flutter_application_0/Screens/profile.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/home/widgets/head_part.dart';
import 'package:flutter_application_0/home/widgets/prescriptionupload.dart';
import 'package:flutter_application_0/search/ui/search_screen.dart';
import 'package:badges/badges.dart' as badges;

class MainHeading extends StatelessWidget {
  const MainHeading({
    Key? key,
    required this.ctx,
    this.homeBloc,
    this.cartBloc,
    required this.cartItemCount,
  }) : super(key: key);

  final HomeBloc? homeBloc;
  final CartBloc? cartBloc;
  final int cartItemCount;
  final BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 3.1,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 10),
                child: SizedBox(
                  width: 130,
                  child: Container(
                    height: 55,
                    child: Image.asset(
                      'assets/images/quickmed.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartScreen(parentContext: ctx)),
                      );
                    },
                    child: cartItemCount > 0
                        ? badges.Badge(
                            position: badges.BadgePosition.topEnd(top: 1, end: -10),
                            badgeContent: Text(
                              cartItemCount > 9 ? '9+' : '$cartItemCount',
                              style: const TextStyle(color: Colors.white),
                            ),
                            child: const Icon(
                              Icons.shopping_cart,
                              color: Colors.black,
                            ),
                          )
                        : const Icon(
                            Icons.shopping_cart,
                            color: Colors.black,
                          ),
                  ),
                  const SizedBox(width: 20),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UserDetailsScreen()),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
                          Icons.person,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyOrdersPage()),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          "My Orders",
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen(parentContext: ctx)),
              );
            },
            child: const Headpart(),
          ),
          const SizedBox(
            height: 5,
          ),
          ImageUploading(homeBloc: homeBloc!),
        ],
      ),
    );
  }
}
