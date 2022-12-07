import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:quran/utils/constants.dart';
import 'package:quran/views/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {}
  });

  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Colors.blue,
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupkey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true
  );

  FirebaseMessaging.onBackgroundMessage(_onMessageReceived);

  FirebaseMessaging.instance.subscribeToTopic("notifications");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Quran - قران',
      theme: ThemeData(
          primarySwatch: primaryColor,
          fontFamily: "Tajawal"
      ),
      home: AnimatedSplashScreen.withScreenFunction(
        splash: 'assets/images/logo.png',
        duration: 5,
        screenFunction: () async {
          return Phoenix(child: Home());
        },
        splashIconSize: 200,
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}

Future<void> _onMessageReceived(RemoteMessage message) async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: DateTime.now().millisecond,
          channelKey: 'basic_channel',
          color: Colors.brown,
          title: message.data['title'],
          body: message.data['body']
      )
  );
}