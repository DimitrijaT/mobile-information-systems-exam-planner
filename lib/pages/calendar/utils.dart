import 'dart:collection';

import 'package:exam_planner/custom/parser.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../models/ExamDate.dart';

class Event {
  final String title;

  final String examTime;

  const Event(this.title, this.examTime);

  @override
  String toString() => title;
}

class CalendarUtils {
  static LinkedHashMap<DateTime, List<Event>> listToLinkedHashMap(
      List<ExamDate> _examDates) {
    var kEventSource = {
      for (var e in _examDates)
        DateTime.parse(e.dateTime): [
          Event(e.examSubject, Parser.getTimeFromDateTimeString(e.dateTime))
        ]
    };

    final kEvents = LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(kEventSource);

    return kEvents;
  }
}

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year, kToday.month - 3, kToday.day);
final kLastDay = DateTime(kToday.year, kToday.month + 3, kToday.day);
