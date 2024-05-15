import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/profile.dart';
import 'package:flutter_application_0/cart/ui/cart_screen.dart';
import 'package:flutter_application_0/home/bloc/home_bloc.dart';
import 'package:flutter_application_0/home/widgets/head_part.dart';
import 'package:flutter_application_0/home/widgets/prescriptionupload.dart';
import 'package:flutter_application_0/search/ui/search_screen.dart';

class MainHeading extends StatelessWidget {
  const MainHeading({
    super.key,
    this.homeBloc,
  });

  final HomeBloc? homeBloc;
  // final SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.7,
      width: double.infinity,
      color: Colors.white, // Example color, you can change this
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 5, 10, 10),
                child: SizedBox(
                  width: 130,
                  // Adjust height as needed
                  child: Container(
                    height: 55,
                    // width: 300,
                    child: Image.asset(
                      'assets/images/quickmed.png',
                      fit: BoxFit.fill, // Adjust BoxFit as needed
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CartScreen()),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(8.0), // Adjust padding Zas needed
                      child: Icon(
                        Icons
                            .shopping_cart, // Use the Cupertino-style back button icon
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => UserDetailsScreen(userId: 1)),
                        );
                      },
                      child: Container(
                        color: Colors.white,
                        padding:
                            EdgeInsets.all(8.0), // Adjust padding as needed
                        child: Icon(
                          Icons
                              .person, // Use the Cupertino-style back button icon
                          color: Colors.black,
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
                MaterialPageRoute(builder: (context) => SearchScreen()),
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
