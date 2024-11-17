import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/data_source/local/local_data_source.dart';
import 'package:quran/utils/constants.dart';
import 'package:quran/modules/home/view/home.dart';
import 'package:quran/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // init firebase
  await initFirebase();

  // handle notifications
  handleFirebaseNotification();

  runApp(const MyApp());
}

Future<void> initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void handleFirebaseNotification() {
  FirebaseMessaging.instance.subscribeToTopic("notifications");

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {}
  });

  AwesomeNotifications().initialize(
    'resource://drawable/logo',
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: primaryColor,
        ledColor: primaryColor,
        icon: 'resource://drawable/logo',
        importance: NotificationImportance.Max,
        playSound: true,
      )
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
      )
    ],
    debug: true,
  );

  FirebaseMessaging.onBackgroundMessage(_onMessageReceived);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    if (message.notification != null) {
      pushNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.notification != null) {
      pushNotification(message);
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran - قران',
      theme: ThemeData(
        primarySwatch: primaryColor,
        fontFamily: "Tajawal",
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: 'assets/images/logo.png',
        duration: 5,
        screenFunction: () async {
          await LocalDataSource.getInstance()?.initLocalDataSource();
          return Home();
        },
        splashIconSize: 200,
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

Future<void> _onMessageReceived(RemoteMessage message) async {
  pushNotification(message);
}

void pushNotification(message) {
  AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: DateTime.now().millisecond,
      channelKey: 'basic_channel',
      color: primaryColor,
      title: message.data['title'],
      body: message.data['body'],
      icon: 'resource://drawable/logo',
    ),
  );
}
