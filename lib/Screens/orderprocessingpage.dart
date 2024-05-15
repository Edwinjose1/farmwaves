import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/paymentScreen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:lottie/lottie.dart';

class OrderProcessingPage extends StatefulWidget {
  final int orderId; // Add orderId parameter

  OrderProcessingPage({required this.orderId}); // Constructor

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
      body: Stack(
        children: [
          Center(
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
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  print(widget.orderId);
                  // Handle button press
                  // Example: Navigate to another screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(orderId: widget.orderId),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 46, 190, 51), // Background color
                  onPrimary: Colors.white, // Text color
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Button border radius
                  ),
                ),
                child: Text(
                  '   Next   ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
