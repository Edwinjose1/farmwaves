import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_application_0/constants/pallete.dart';
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
        if (password.length < 6) {
          return emit(AuthFailure("Password cannot be less than 6 characters"));
        }

        final response = await http.post(
          Uri.parse('http://${Pallete.ipaddress}:8000/api/login/'),
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
          final userId = jsonResponse['user_id'] ?? ''; // assuming the user ID is stored in 'user_id'
          final sharedpref = await SharedPreferences.getInstance();
          await sharedpref.setBool(SAVE_KEY_NAME, true);
          await sharedpref.setString('user_id', userId.toString());
          await sharedpref.setString('auth_token', token);
          return emit(AuthSuccess(token: token));
        } else {
          print('API call failed with status code ${response.statusCode}'); // Print the status code
          return emit(AuthFailure('Failed to login'));
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

        final response = await http.post(
          Uri.parse('http://${Pallete.ipaddress}:8000/api/register/'),
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
          print("success");
          final jsonResponse = json.decode(response.body);
          print("response: $jsonResponse");

          final userId = jsonResponse['user_id'];
          final sharedpref = await SharedPreferences.getInstance();
          await sharedpref.setBool(SAVE_KEY_NAME, true);
          await sharedpref.setString('user_id', userId.toString());
          return emit(SignupSuccess());
        } else {
          print("fail");
          return emit(AuthFailure('Failed to signup'));
        }
      } catch (e) {
        print(e.toString());
        return emit(AuthFailure(e.toString()));
      }
    });
  }
}
