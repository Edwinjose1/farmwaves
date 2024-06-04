// ignore_for_file: library_private_types_in_public_api, use_key_in_widget_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart'; // Import the HomeScreen
import 'package:lottie/lottie.dart';

class Ordersuccesspage extends StatefulWidget {
  @override
  _OrdersuccesspageState createState() => _OrdersuccesspageState();
}

class _OrdersuccesspageState extends State<Ordersuccesspage> {
  late bool _isLoading;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    // Start a timer to hide the loading indicator after 1 second and navigate to home page after 5 seconds
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
      body: Center(
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
                      "Thank you for your order!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Handle button press
                      // Example: Navigate to HomeScreen
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
                ],
              ),
      ),
    );
  }
}
