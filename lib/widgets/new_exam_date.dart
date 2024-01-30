import 'package:exam_planner/models/ExamDate.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';

class NewExamDate extends StatefulWidget {
  final Function addExamDate;

  const NewExamDate({super.key, required this.addExamDate});

  @override
  State<NewExamDate> createState() => _NewExamDateState();
}

class _NewExamDateState extends State<NewExamDate> {
  final _examDateTimeController = TextEditingController();
  final _examSubjectController = TextEditingController();

  void _submitData() {
    String enteredExamDateTime = _examDateTimeController.text;
    final String enteredExamSubject = _examSubjectController.text;

    if (enteredExamDateTime.isEmpty) {
      enteredExamDateTime = DateTime.now().toString();
    }

    if (enteredExamSubject.isEmpty) {
      return;
    }

    widget.addExamDate(
        ExamDate(0, enteredExamSubject, enteredExamDateTime, false));

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: _examSubjectController,
              decoration: const InputDecoration(labelText: 'Exam Subject'),
              onSubmitted: (_) => _submitData,
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              // options: [date | time | dateTime | dateTimeSeparated]
              initialValue: null,
              icon: const Icon(Icons.event),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              dateLabelText: 'Date and Time',
              onChanged: (val) => print(val),
              validator: (val) {
                print(val);
                return null;
              },
              onSaved: (val) => print(val),
              controller: _examDateTimeController,
            ),
            ElevatedButton(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onPressed: _submitData,
                child: const Text('Add Exam Date'))
          ],
        ));
  }
}
