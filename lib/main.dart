import 'package:flutter/material.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
import 'package:flutter_application_0/authentication/ui/original_login_screen1.dart';
import 'package:flutter_application_0/constants/pallete.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: MaterialApp(
        // Set themeMode to system to automatically switch between light and dark themes
        themeMode: ThemeMode.system,
        // Define your dark theme here if needed
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(), // Use light theme as default
        home: LoginScreen(),
      ),
    );
  }
}
