// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/paymentScreen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
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
    Timer(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
     Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home1(),
          ),
        );
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
                ? const CircularProgressIndicator() // Show loading indicator
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/animation/order1.json',
                        width: MediaQuery.of(context).size.width / 1.2,
                        height: MediaQuery.of(context).size.width / 1.2,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 20),
                      const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text(
                          "Your order is being processed. Our pharmacy team will deliver soon. Thank you for your patience and trust in our service.",
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
                  Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Home1(),
          ),
        );
                 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 46, 190, 51), // Background color
                  shadowColor: Colors.white, // Text color
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Button border radius
                  ),
                ),
                child: const Text(
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
