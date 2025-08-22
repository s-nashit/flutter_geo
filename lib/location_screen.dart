import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String location = "Unknown";

  Future<void> _getAndStoreLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() => location = "Location services disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() => location = "Permission denied permanently.");
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() => location = "${position.latitude}, ${position.longitude}");

    // 🔥 Store in Firestore
    await FirebaseFirestore.instance.collection('user_locations').add({
      'latitude': position.latitude,
      'longitude': position.longitude,
      'timestamp': DateTime.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Capture Location")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Location: $location"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getAndStoreLocation,
              child: Text("Capture & Save Location"),
            ),
          ],
        ),
      ),
    );
  }
}
