import 'package:flutter/material.dart';

class LogoWithText extends StatelessWidget {
  const LogoWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              color: Colors.white,
              child: Center(
                  child: Container(
                width: MediaQuery.of(context).size.width * 0.6,
                height: MediaQuery.of(context).size.width * 0.6,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/exam_planner_logo.png'),
                    fit: BoxFit.contain,
                  ),
                ),
              ))),
          Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                "Exam Planner App",
                style: TextStyle(
                    // color: Colors.deepPurple[800],
                    color: Colors.black,
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                    decoration: TextDecoration.none,
                    fontFamily: "Roboto"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
