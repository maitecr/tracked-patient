import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }
  }

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
    service.setForegroundNotificationInfo(
      title: "Rastreamento ativo",
      content: "O paciente está sendo monitorado.",
    );
  }

  Timer.periodic(const Duration(seconds: 15), (timer) async {
    if (service is AndroidServiceInstance && !(await service.isForegroundService())) {
      timer.cancel();
      return;
    }

    Position position = await Geolocator.getCurrentPosition();

    final patientCode = "RPA20250610173946"; 
    final _firebaseUrl = "https://track-patient-cb919-default-rtdb.firebaseio.com/";
    //final _firebaseUrl = [YOUR_FIREBASE_URL];


    final response = await http.get(
      Uri.parse('$_firebaseUrl/track_person.json?orderBy="code"&equalTo="$patientCode"'),
      headers: {"Content-Type": "application/json"},
    );

    //print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      if (data == null || data.isEmpty) return;

      final patientId = data.keys.first;

      final currentLocation = {
        "currentLocation": {
          "latitude": position.latitude,
          "longitude": position.longitude,
          "address": "Endereço desconhecido",
          "title": "Localização Atual",
        }
      };

      print("Localização em tempo real: {$currentLocation}");

      await http.patch(
        Uri.parse('$_firebaseUrl/track_person/$patientId.json'),
        body: jsonEncode(currentLocation),
      );
    }
  });
}

Future<void> initializeService() async {
  await Geolocator.requestPermission();

  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      foregroundServiceTypes: [AndroidForegroundType.location],
    ),
    iosConfiguration: IosConfiguration(),
  );

  await service.startService();
}
