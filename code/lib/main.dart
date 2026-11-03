import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'screens/people_records_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final options = DefaultFirebaseOptions.currentPlatform;
  bool firebaseReady = !options.apiKey.startsWith('REPLACE_WITH');
  if (firebaseReady) {
    try {
      await Firebase.initializeApp(options: options);
    } catch (_) {
      firebaseReady = false;
    }
  }

  runApp(PeopleRecordsApp(firebaseReady: firebaseReady));
}

class PeopleRecordsApp extends StatelessWidget {
  final bool firebaseReady;

  const PeopleRecordsApp({super.key, required this.firebaseReady});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee / Student Records (Firestore)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
      ),
      home: PeopleRecordsScreen(firebaseReady: firebaseReady),
    );
  }
}
