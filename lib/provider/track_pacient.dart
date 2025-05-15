import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracked_pacient/models/patient_model.dart';
import 'package:http/http.dart' as http;
import 'package:tracked_pacient/models/place_location_model.dart';

class TrackPacient with ChangeNotifier {
  final _firebaseUrl = 'https://track-patient-cb919-default-rtdb.firebaseio.com';
  //final _firebaseUrl = [YOUR_FIREBASE_URL];

  final List<PatientModel> _items = [];
  List<PatientModel> get items => [..._items];

  Future<void> updateCurrentLocation(String patientCode, LatLng position) async {
    final String code = patientCode;

    final response = await http.get(
      Uri.parse('$_firebaseUrl/track_person.json?orderBy="code"&equalTo="$code"'),
      headers: {"Content-Type": "application/json"},
    );
    //print("Response body: ${response.body}");

    //print(response.statusCode);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      //print(data);

      if (data == null || data.isEmpty) return;

      final patientId = data.keys.first;
      //print("patient id ${patientId}");

      final updatedLocation = PlaceLocationModel(
        latitude: position.latitude,
        longitude: position.longitude,
        address: "Endereço desconhecido",  
        title: "Localização Atual",  
      );

      await http.patch(
       Uri.parse('$_firebaseUrl/track_person/$patientId.json'),
        body: jsonEncode({
          "currentLocation": updatedLocation.toJson() 
        }),
      );

      notifyListeners();
    }

  }
}

// {
//   "rules": {
//     ".read": "now < 1749610800000",  // 2025-6-11
//     ".write": "now < 1749610800000",  // 2025-6-11
//     "track_person": {
//       ".indexOn": ["code"]
//     }
//   }
// }