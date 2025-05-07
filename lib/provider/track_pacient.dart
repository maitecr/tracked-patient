import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tracked_pacient/models/patient_model.dart';
import 'package:http/http.dart' as http;

class TrackPacient with ChangeNotifier {
  final _firebaseUrl = [YOUR_FIREBASE_URL];

  PatientModel? _patient;

  void getPatientByCode() async {
    final response = await http.get(Uri.parse('$_firebaseUrl/track_person.json'));
    print(jsonDecode(response.body));
  }
  
}