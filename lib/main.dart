import 'package:flutter/material.dart';
import 'package:tracked_pacient/screens/loadingScreen.dart';
import 'package:tracked_pacient/services/background_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeService();
  runApp(
      const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tracked Pacient',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Loadingscreen(),
    );
  }
}

