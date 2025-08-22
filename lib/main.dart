import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'location_screen.dart'; // your main screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: LocationScreen());
  }
}
