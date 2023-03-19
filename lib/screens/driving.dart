import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class Driving extends StatefulWidget {
  const Driving({Key? key}) : super(key: key);

  @override
  State<Driving> createState() => _DrivingState();
}

class _DrivingState extends State<Driving> {
  bool _isLoading = true;

  String location = 'Null, Press Button';
  String Address = 'search';

  Timer? periodicTimer;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location service are disabled');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location Permissions are denied');
      }
    }

    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  @override
  void initState() {
    _determinePosition();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: Text("Driving"),
      ),
      body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text("Distance covered",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        Text(
          "Co-ordinate points",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        Text(
          location,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        ElevatedButton(
            onPressed: () async {
              Position position = await _determinePosition();
              print(position.latitude);
              print(position.longitude);
              final periodicTimer =
                  Timer.periodic(const Duration(seconds: 5), (timer) {
                location =
                    'Lat: ${position.latitude}, Long: ${position.longitude}';
                setState(() {});
              });
            },
            child: Text("Get location"))
      ])),
    );
  }
}
