import 'dart:async';

import 'package:exam_planner/pages/auth/login_page.dart';
import 'package:exam_planner/pages/auth/registration_page.dart';
import 'package:exam_planner/pages/splashscreen.dart';
import 'package:exam_planner/pages/welcome_page.dart';
import 'package:exam_planner/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'firebase_options.dart';
import 'api/firebase_api.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await findSystemLocale();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotifications();
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
      navigatorKey: navigatorKey,
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

// Google Maps Necessities
Completer<AndroidMapRenderer?>? _initializedRendererCompleter;

/// Initializes map renderer to the `latest` renderer type for Android platform.
///
/// The renderer must be requested before creating GoogleMap instances,
/// as the renderer can be initialized only once per application context.
Future<AndroidMapRenderer?> initializeMapRenderer() async {
  if (_initializedRendererCompleter != null) {
    return _initializedRendererCompleter!.future;
  }

  final Completer<AndroidMapRenderer?> completer =
      Completer<AndroidMapRenderer?>();
  _initializedRendererCompleter = completer;

  WidgetsFlutterBinding.ensureInitialized();

  final GoogleMapsFlutterPlatform mapsImplementation =
      GoogleMapsFlutterPlatform.instance;
  if (mapsImplementation is GoogleMapsFlutterAndroid) {
    unawaited(mapsImplementation
        .initializeWithRenderer(AndroidMapRenderer.latest)
        .then((AndroidMapRenderer initializedRenderer) =>
            completer.complete(initializedRenderer)));
  } else {
    completer.complete(null);
  }

  return completer.future;
}
