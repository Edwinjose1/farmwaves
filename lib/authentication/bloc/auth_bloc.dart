import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_0/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthLoginRequested>((event, emit) async {
      try {
        final email = event.email;
        final password = event.password;
        print(email);
        print(password);

        if (password.length < 4) {
          return emit(AuthFailure("Password cannot be less than 6 characters"));
        }

        final response = await http.post(
          Uri.parse('http://192.168.1.44:8000/api/login/'),
          body: json.encode({
            "username": email,
            "password": password,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          print(response.statusCode);
          print(response.body);
          final jsonResponse = json.decode(response.body);
          final token = jsonResponse['token'];
              String userId = jsonResponse['user_id'] ?? '';// assuming the user ID is stored in 'user_id'
       final sharedpref = await SharedPreferences.getInstance();
          await sharedpref.setBool(SAVE_KEY_NAME, true);
          await sharedpref.setString('user_id', userId);
          
          sharedpref.setString('', token);
          // prefs.setString('userId', userId);
          return emit(AuthSuccess(token: token ));
        } 
        
        
        
        else {
          print(
              'API call failed with status code ${response.statusCode}'); // Print the status code
          throw Exception('Failed to login');
        }




      } catch (e) {
        print(e);
        return emit(AuthFailure(e.toString()));
      }












    });
    on<AuthSignupRequested>((event, emit) async {
      try {
        final username = event.username;
        final email = event.email;
        final password = event.password;
        print(username);
        print(password);
        print(email);
        // final confirmPassword = event.confirmPassword;

        // Perform your signup operation here
        // For example, you can make an HTTP request to your backend API to create a new user
        final response = await http.post(
          Uri.parse('http://192.168.1.44:8000/api/register/'),
          body: json.encode({
            "username": username,
            "password": password,
            "email": email,
          }),
          headers: {
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 201) {
          print("sucesss");
          // Signup successful
          // Decode the JSON response
          final jsonResponse = json.decode(response.body);
          // Print the JSON response
          print("afffffff$jsonResponse");
          if (response.statusCode == 201) {
            final jsonResponse = json.decode(response.body);
            // final token = jsonResponse['token'];
            final userId = jsonResponse['user_id']; // assuming the user ID is stored in 'user_id'
    final sharedpref = await SharedPreferences.getInstance();
          await sharedpref.setBool(SAVE_KEY_NAME, true);
          await sharedpref.setString('user_id', userId.toString());
            final prefs = await SharedPreferences.getInstance();
            // prefs.setString('token', token);
            prefs.setString('userId', userId.toString());
            return emit(SignupSuccess());
          }
          // return emit(SignupSuccess());
          // Emit AuthSuccess or set appropriate user data
          // For example:
          // emit(AuthSuccess(uid: 'user_uid'));
        } else {
          print("faill");
          // Signup failed
          // Emit AuthFailure with appropriate error message
          // For example:
          // emit(AuthFailure('Failed to signup'));
        }
      } catch (e) {
        // Handle any errors that occurred during signup
        // Emit AuthFailure with the error message
        // For example:
        // emit(AuthFailure(e.toString()));
        print(e.toString()); // Print the error message
      }
    });
  }
}
