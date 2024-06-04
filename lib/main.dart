// // ignore_for_file: constant_identifier_names, avoid_print

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_application_0/Screens/notification.dart';
// import 'package:flutter_application_0/Screens/splashScreen.dart';
// import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
// import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
// import 'package:flutter_application_0/profile/profileScreen.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// const SAVE_KEY_NAME = 'UserLoggedIn';
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   FirebaseMessaging messaging = FirebaseMessaging.instance;
//   String? token = await messaging.getToken();
//   print('FCM Token: $token');
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     print("onMessageOpenedApp: $message");
//     Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
//         arguments: {"message": json.encode(message.data)});
//   });
//   FirebaseMessaging.onBackgroundMessage(_firebaseMessageInBackgroundHandler);
//   runApp(const MyApp());
//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
//     if (message != null) {
//       Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
//           arguments: {"message": json.encode(message.data)});
//     }
//   });
// }

// Future<void> _firebaseMessageInBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<AuthBloc>(
//           create: (context) => AuthBloc(),
//         ),
//         BlocProvider<CartBloc>(
//           create: (context) => CartBloc()..add(CartInitialEvent()),
//         ),
//       ],
//       child: MaterialApp(
//         themeMode: ThemeMode.system,
//         darkTheme: ThemeData.dark(),
//         debugShowCheckedModeBanner: false,
//         title: 'Flutter Demo',
//         theme: ThemeData.light(), // Use light theme as default
//         home: SplashScreen(),
//         navigatorKey: navigatorKey,
//         routes: {'/push-page': (context) => const Notificaionpage()},
//       ),
//     );
//   }
// }


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_0/Screens/notification.dart';
import 'package:flutter_application_0/Screens/splashScreen.dart';
import 'package:flutter_application_0/authentication/bloc/auth_bloc.dart';
import 'package:flutter_application_0/cart/bloc/cart_bloc.dart';
import 'package:flutter_application_0/firebase.dart';
// import 'package:flutter_application_0/profile/profileScreen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;

const SAVE_KEY_NAME = 'UserLoggedIn';
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  // Enable FCM auto-initialization
  // await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // FirebaseMessaging messaging = FirebaseMessaging.instance;
  // String? token = await messaging.getToken();
  // print('FCM Token: $token');
  
  // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
  //   print("onMessageOpenedApp: $message");
  //   Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
  //       arguments: {"message": json.encode(message.data)});
  // });
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessageInBackgroundHandler);
notificationService(navigatorKey);
  runApp(const MyApp());

  // FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
  //   if (message != null) {
  //     Navigator.pushNamed(navigatorKey.currentState!.context, '/push-page',
  //         arguments: {"message": json.encode(message.data)});
  //   }
  // }
  // );
}

// Future<void> _firebaseMessageInBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc()..add(CartInitialEvent()),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData.light(), // Use light theme as default
        home: SplashScreen(),
        navigatorKey: navigatorKey,
        routes: {'/push-page': (context) => const Notificaionpage()},
      ),
    );
  }
}

Future<void> sendNotification(String token, String title, String body) async {
  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'AIzaSyCsJVvtKgSQoEzgpA7yCisa1ezTltKSLK0',  // Replace with your server key
  };
  final bodyData = {
    'to': token,
    'notification': {
      'title': title,
      'body': body,
    },
  };

  final response = await http.post(url, headers: headers, body: jsonEncode(bodyData));

  if (response.statusCode == 200) {
    print('Notification sent successfully');
  } else {
    print('Failed to send notification. Error: ${response.body}');
  }
}
