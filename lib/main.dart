import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/splashScreen.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
const SAVE_KEY_NAME = 'UserLoggedIn';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Retrieve FCM token asynchronously
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? token = await messaging.getToken();
  print('FCM Token: $token');

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
        home: SplashScreen(),
      ),
    );
  }
}
