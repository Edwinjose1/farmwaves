import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:lottie/lottie.dart';

class OrderProcessingPage extends StatefulWidget {
  @override
  _OrderProcessingPageState createState() => _OrderProcessingPageState();
}

class _OrderProcessingPageState extends State<OrderProcessingPage> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // Start a timer to hide the loading indicator after 1 second
    Timer(Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Pallete.whiteColor,
      appBar: AppBar(
        backgroundColor: Pallete.whiteColor,
        leading: GestureDetector(
          onTap: () {
            // Navigate to the home page and remove all previous routes from the stack
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Home1()), // Replace HomePage with your actual home page widget
              (Route<dynamic> route) => false, // Remove all routes in the stack
            );
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
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animation/order1.json',
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.width / 1.2,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      "Thank you for your order! Our back end team is currently processing it. Our pharmacy team will be in touch with you soon. Please wait patiently for further updates.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
