// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';


// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'dual',
//   'High Importance Notifications',
//   description: 'This channel is used for important notifications.',
//   importance: Importance.high,
//   enableVibration: true,
//   playSound: true,
// );

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.requestPermission();
// }

// Future<void> notificationService(GlobalKey<NavigatorState> navigatorKey) async {
//   WidgetsFlutterBinding.ensureInitialized();
  

//   await Firebase.initializeApp();

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.createNotificationChannel(channel);
//   flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//       ?.requestPermission();
//   flutterLocalNotificationsPlugin.initialize(
//     const InitializationSettings(
//       android: AndroidInitializationSettings("@mipmap/ic_launcher"),
//       iOS: DarwinInitializationSettings(
//         requestSoundPermission: true,
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//       ),
//     ),
//     onDidReceiveNotificationResponse: (NotificationResponse? response) {
    
//     },
//   );

//   await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
//       alert: true, badge: true, sound: true);

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

//   FirebaseMessaging.instance.getToken().then((value) async {
//     String? token = value;
//     if (kDebugMode) {
//       print('token: $token');
//     }
//   });

//   FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
   
//   });

//   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//     RemoteNotification? notification = message.notification;
//     AndroidNotification? android = message.notification?.android;

//     if (notification != null && android != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         NotificationDetails(
//           android: AndroidNotificationDetails(
//             channel.id,
//             channel.name,
//             channelDescription: channel.description,
//             color: const Color(0xFFFFE200),
//             playSound: channel.playSound,
//             enableVibration: channel.enableVibration,
//             icon: '@mipmap/ic_launcher',
//           ),
//         ),
//       );
//     }
//     if (notification != null && notification.apple != null) {
//       flutterLocalNotificationsPlugin.show(
//         notification.hashCode,
//         notification.title,
//         notification.body,
//         const NotificationDetails(
//           iOS: DarwinNotificationDetails(presentSound: true),
//         ),
//       );
//     }
//   });

//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//     RemoteNotification? notification = message.notification;
 
//   });
// }
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> notificationService(GlobalKey<NavigatorState> navigatorKey) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description: 'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestPermission();

  flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestAlertPermission: true,
        requestBadgePermission: true,
      ),
    ),
    onDidReceiveNotificationResponse: (NotificationResponse? response) {
      // Handle notification response
    },
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  FirebaseMessaging.instance.getToken().then((String? token) async {
    if (token == null) {
      if (kDebugMode) {
        print('Token is null');
      }
    } else {
      if (kDebugMode) {
        print('Token: $token');
      }
    }
  }).catchError((e) {
    if (kDebugMode) {
      print('Error retrieving token: $e');
    }
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    // Handle initial message if needed
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            color: const Color(0xFFFFE200),
            playSound: channel.playSound,
            enableVibration: channel.enableVibration,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
    if (notification != null && notification.apple != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          iOS: DarwinNotificationDetails(presentSound: true),
        ),
      );
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    // Handle notification tapped logic here
  });
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  // Handle background message logic here
}
