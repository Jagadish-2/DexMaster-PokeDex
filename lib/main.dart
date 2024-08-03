import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pokedex/Screens/splash_screen.dart';
import 'package:pokedex/firebase_options.dart';
import 'package:pokedex/network/firebase_notification_api.dart';
import 'package:wiredash/wiredash.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseNotificationApi().initNotifications();
  runApp( ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.black,
    hintColor: Colors.blueAccent,
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    hintColor: Colors.blueGrey,
    //textTheme: TextTheme(
     // bodyLarge: TextStyle(color: Colors.black),
      //bodyMedium: TextStyle(color: Colors.black),
      //displayLarge: TextStyle(color: Colors.black),
     // displayMedium: TextStyle(color: Colors.black),
      //bodySmall: TextStyle(color: Colors.black),
     // headlineMedium: TextStyle(color: Colors.black),
      //headlineSmall: TextStyle(color: Colors.black)
   // ),
  );

  @override
  Widget build(BuildContext context) {
    return  Wiredash(
      projectId: 'pokedex-sq3c21o',
      secret: 'JvUFNwU2UEUvXCjNAdxACHMqIKM729wh',
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: ThemeMode.system,
          home: const SplashScreen()),
    );
  }
}
