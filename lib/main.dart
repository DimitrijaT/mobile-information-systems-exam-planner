import 'package:exam_planner/pages/auth/login_page.dart';
import 'package:exam_planner/pages/auth/registration_page.dart';
import 'package:exam_planner/pages/auth/welcome_page.dart';
import 'package:exam_planner/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
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
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      //   useMaterial3: true,
      // ),
      initialRoute: '/welcome_page',
      routes: <String, WidgetBuilder>{
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
