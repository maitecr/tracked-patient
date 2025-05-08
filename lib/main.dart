import 'package:flutter/material.dart';
import 'package:tracked_pacient/provider/track_pacient.dart';
import 'package:provider/provider.dart';
import 'package:tracked_pacient/screens/track_screen.dart';

void main() async {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TrackPacient(),
      child: const MyApp(),
    ),
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
      home: TrackScreen(),
    );
  }
}

