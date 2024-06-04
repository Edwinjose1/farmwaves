// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/ui/signup_screen.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_application_0/home/ui/original_home_screen.dart';
import 'package:flutter_application_0/main.dart';

import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Simulate a time-consuming operation, like loading data or initializing
    Timer(
      const Duration(seconds: 3), // Change the duration as needed
      () {
        // Navigate to the next screen after the splash screen duration
        checkUserLoggedIn(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Pallete.darkgreenColor,
      // Customize the splash screen UI here
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Example of a logo
            SizedBox(height: 20),
            Text(
              'Quick Med',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> gotoLogin() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => SignupScreen()));
  }

  Future<void> checkUserLoggedIn(BuildContext context) async {
    final sharedpref = await SharedPreferences.getInstance();
    final userLoggedIn = sharedpref.getBool(SAVE_KEY_NAME);
    
 String? storeduserid = sharedpref.getString('user_id');
print(storeduserid);
   
    print(userLoggedIn);

    if (storeduserid != null ) {
      if (userLoggedIn == null || userLoggedIn == false) {
        gotoLogin();
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home1()));
      }

    } else {
      gotoLogin();
      // Redirect to the Login Page to re-authenticate
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }
}
