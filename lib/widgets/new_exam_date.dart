import 'package:exam_planner/models/ExamDate.dart';
import 'package:flutter/material.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:geocoding/geocoding.dart';

class NewExamDate extends StatefulWidget {
  final Function addExamDate;

  const NewExamDate({super.key, required this.addExamDate});

  @override
  State<NewExamDate> createState() => _NewExamDateState();
}

class _NewExamDateState extends State<NewExamDate> {
  final _examDateTimeController = TextEditingController();
  final _examSubjectController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _output = '';

  void _submitData() {
    String enteredExamDateTime = _examDateTimeController.text;
    final String enteredExamSubject = _examSubjectController.text;
    double longitude = double.infinity;
    double latitude = double.infinity;

    // THIS IS A SYNC CALL, the rest of the logic will be executed after this
    locationFromAddress(_addressController.text).then((locations) {
      if (locations.isNotEmpty) {
        latitude = locations[0].latitude;
        longitude = locations[0].longitude;

        print('Latitude: $latitude');
        print('Longitude: $longitude');

        // Proceed to add exam date after obtaining location
        _addExamDate(
            enteredExamDateTime, enteredExamSubject, latitude, longitude);
      } else if (longitude == double.infinity || latitude == double.infinity) {
        return;
      }
    }).catchError((error) {
      // Handle any errors that occur during location retrieval
      print('Error occurred during location retrieval: $error');
      // You might want to display an error message to the user here
    });
  }

  void _addExamDate(String enteredExamDateTime, String enteredExamSubject,
      double latitude, double longitude) {
    if (enteredExamDateTime.isEmpty) {
      enteredExamDateTime = DateTime.now().toString();
    }

    if (enteredExamSubject.isEmpty) {
      // Handle case when exam subject is empty
      print('Exam subject cannot be empty.');
      // You might want to display an error message to the user here
      return;
    }

    widget.addExamDate(ExamDate(0, enteredExamSubject, enteredExamDateTime,
        false, longitude, latitude));

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
            TextField(
              autocorrect: false,
              controller: _addressController,
              style: Theme.of(context).textTheme.bodyMedium,
              decoration: const InputDecoration(
                labelText: 'Address',
                // prefixIcon: Icon(Icons.location_on),
              ),
              keyboardType: TextInputType.text,
              onSubmitted: (_) => _submitData,
              onChanged: (address) {
                // Whenever the user types or changes the address,
                // update the autofill text based on the address
                locationFromAddress(address).then((locations) {
                  var output = 'No results found.';
                  if (locations.isNotEmpty) {
                    output = locations[0].toString();
                  }
                  setState(() {
                    _output = "Valid address";
                  });
                }).catchError((error) {
                  // Handle any errors that occur during location retrieval
                  print('Error occurred during location retrieval: $error');

                  setState(() {
                    _output = "Invalid address";
                  });

                  // You might want to display an error message to the user here
                });
              },
            ),
            Center(
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Text(
                    _output,
                    style: _output == "Valid address"
                        ? const TextStyle(color: Colors.green)
                        : const TextStyle(color: Colors.redAccent),
                  )),
            ),
            ElevatedButton(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                onPressed: _submitData,
                child: const Text('Add Exam Date'))
          ],
        ));
  }
}
