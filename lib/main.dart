import 'package:exam_planner/pages/auth/login_page.dart';
import 'package:exam_planner/pages/auth/registration_page.dart';
import 'package:exam_planner/pages/splashscreen.dart';
import 'package:exam_planner/pages/welcome_page.dart';
import 'package:exam_planner/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await findSystemLocale();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
        useMaterial3: true,
      ),
      initialRoute: '/splashscreen',
      routes: <String, WidgetBuilder>{
        '/splashscreen': (BuildContext context) => const Splashscreen(),
        '/welcome_page': (BuildContext context) => const WelcomePage(),
        '/login_page': (BuildContext context) => const LoginPage(),
        '/registration_page': (BuildContext context) =>
            const RegistrationPage(),
        '/home_page': (BuildContext context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
      },
    );
  }
}
