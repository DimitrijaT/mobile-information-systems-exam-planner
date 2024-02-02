// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';

import 'package:exam_planner/models/ExamDate.dart';
import 'package:exam_planner/pages/maps/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class EventMapPage extends GoogleMapExampleAppPage {
  final List<ExamDate> examDates;

  const EventMapPage(this.examDates, {Key? key})
      : super(const Icon(Icons.place), 'Place marker', key: key);

  @override
  Widget build(BuildContext context) {
    return EventMapBody(examDates);
  }
}

class EventMapBody extends StatefulWidget {
  final List<ExamDate> examDates;

  const EventMapBody(this.examDates, {super.key});

  @override
  State<StatefulWidget> createState() => EventMapBodyState();
}

typedef MarkerUpdateAction = Marker Function(Marker marker);

class EventMapBodyState extends State<EventMapBody> {
  EventMapBodyState();

  late LatLng _currentPosition;

  bool _isLoading = true;
  GoogleMapController? controller;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  MarkerId? selectedMarker;
  int _markerIdCounter = 1;
  LatLng? markerPosition;

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        final MarkerId? previousMarkerId = selectedMarker;
        if (previousMarkerId != null && markers.containsKey(previousMarkerId)) {
          final Marker resetOld = markers[previousMarkerId]!
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          markers[previousMarkerId] = resetOld;
        }
        selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        markers[markerId] = newMarker;

        markerPosition = null;
      });
    }
  }

  Future<void> _onMarkerDrag(MarkerId markerId, LatLng newPosition) async {
    setState(() {
      markerPosition = newPosition;
    });
  }

  Future<void> _onMarkerDragEnd(MarkerId markerId, LatLng newPosition) async {
    final Marker? tappedMarker = markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        markerPosition = null;
      });
      await showDialog<void>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                actions: <Widget>[
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
                content: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 66),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text('Old position: ${tappedMarker.position}'),
                        Text('New position: $newPosition'),
                      ],
                    )));
          });
    }
  }

  @override
  void initState() {
    super.initState();
    getLocation();
    fillCoordinates();
  }

  getLocation() async {
    Position position = await GeolocatorUtils.determinePosition();

    LatLng location = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = location;
      _isLoading = false;
    });
  }

  void fillCoordinates() {
    for (var examDate in widget.examDates) {
      final MarkerId markerId = MarkerId('marker_id_$_markerIdCounter');
      _markerIdCounter++;
      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(examDate.latitude, examDate.longitude),
        infoWindow:
            InfoWindow(title: examDate.examSubject, snippet: examDate.dateTime),
        onTap: () => _onMarkerTapped(markerId),
        onDragEnd: (LatLng position) => _onMarkerDragEnd(markerId, position),
        onDrag: (LatLng position) => _onMarkerDrag(markerId, position),
      );

      setState(() {
        markers[markerId] = marker;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final MarkerId? selectedId = selectedMarker;
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: GoogleMap(
                        gestureRecognizers: <Factory<
                            OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        myLocationEnabled: true,
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: _currentPosition,
                          zoom: 16.0,
                        ),
                        markers: Set<Marker>.of(markers.values),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: markerPosition != null,
                  child: Container(
                    color: Colors.white70,
                    height: 30,
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        if (markerPosition == null)
                          Container()
                        else
                          Expanded(
                              child: Text('lat: ${markerPosition!.latitude}')),
                        if (markerPosition == null)
                          Container()
                        else
                          Expanded(
                              child: Text('lng: ${markerPosition!.longitude}')),
                      ],
                    ),
                  ),
                ),
              ]));
  }
}
