import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'controller/expense_provider.dart';
import 'screens/home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
  const IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings();
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onSelectNotification: (String? payload) async {},
  );
  await _requestPermissions();
  scheduleNotifications(flutterLocalNotificationsPlugin);
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  if (await Permission.scheduleExactAlarm.isGranted) {
    return;
  }

  final status = await Permission.scheduleExactAlarm.request();
  if (status.isGranted) {
    return;
  }
}

void scheduleNotifications(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
  const androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'CHID1234',
    'eXPENSE NOTIFICATION',
    channelDescription: 'your channel description',
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();
  var platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.periodicallyShow(
    0,
    'Record Your Expenses',
    'Keep up with your expense by tracking them timely',
    RepeatInterval.hourly,
    platformChannelSpecifics,
    androidAllowWhileIdle: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ExpenseProvider(),
      child: MaterialApp(
        title: 'Expense Tracker',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}
