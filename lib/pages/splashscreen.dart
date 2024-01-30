import 'dart:async';

import 'package:flutter/material.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/welcome_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.purple[50],
        child: Center(
            child: Text("Exam Planner App",
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                    fontFamily: "Roboto"))));
  }
}
