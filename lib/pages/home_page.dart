import 'package:exam_planner/custom/Parser.dart';
import 'package:exam_planner/widgets/new_exam_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ExamDate.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  late User loggedinUser;

  final List<ExamDate> _examDates = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  //using this function you can use the credentials of the user
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void _addExamDateToList(ExamDate examDate) {
    setState(() {
      _examDates.add(examDate);
    });
  }

  _addExamDate() {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: NewExamDate(addExamDate: _addExamDateToList));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              onPressed: _addExamDate,
              icon: const Icon(Icons.add_alert_outlined)),
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text("Welcome ${Parser.parseEmail(loggedinUser.email!)}"),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, mainAxisSpacing: 8.0, crossAxisSpacing: 8.0),
          itemCount: _examDates.length,
          itemBuilder: (context, index) {
            return Card(
                elevation: 5.0,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _examDates[index].examSubject,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Parser.parseDateTime(_examDates[index].dateTime),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ));
          }),
    );
  }
}
