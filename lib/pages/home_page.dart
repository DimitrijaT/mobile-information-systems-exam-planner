import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:exam_planner/custom/parser.dart';
import 'package:exam_planner/widgets/new_exam_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/ExamDate.dart';
import 'calendar/event_calendar.dart';
import 'calendar/utils.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  late User loggedinUser;

  final List<ExamDate> _examDates = [];

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    _getExamDates();
  }

  void _getExamDates() async {
    final examDates = await db.collection("examDates").get();
    setState(() {
      _examDates.clear();
      for (var element in examDates.docs) {
        if (element["userId"] == loggedinUser.uid) {
          _examDates.add(
              ExamDate(0, element["examSubject"], element["dateTime"], false));
        }
      }
    });
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
    db.collection("examDates").add({
      "examSubject": examDate.examSubject,
      "dateTime": examDate.dateTime,
      "userId": loggedinUser.uid,
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

  _openCalendar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => CalendarPage(
                kEvents: CalendarUtils.listToLinkedHashMap(_examDates))));
    // Navigator.pushNamed(context, '/calendar',
    //     arguments: Converter.listToLinkedHashMap(_examDates));
  }

  @override
  Widget build(BuildContext context) {
    var message = " Welcome ${Parser.parseEmail(loggedinUser.email!)}";
    // get the notification message and display on screen
    if (ModalRoute.of(context)!.settings.arguments != null) {
      var notificationMessage =
          ModalRoute.of(context)!.settings.arguments as RemoteMessage;
      message = notificationMessage.notification!.body!;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
              Navigator.pop(context);
              //Implement logout functionality
            }),
        actions: <Widget>[
          IconButton(
              onPressed: _addExamDate,
              icon: const Icon(Icons.add_alert_outlined)),
          IconButton(
              onPressed: _openCalendar, icon: const Icon(Icons.calendar_month)),
        ],
        title: FittedBox(
          fit: BoxFit.fitWidth,
          child: Row(children: [
            // const Icon(Icons.calendar_today_outlined),
            Text(message)
          ]),
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
                          fontSize: 18, fontWeight: FontWeight.bold),
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
