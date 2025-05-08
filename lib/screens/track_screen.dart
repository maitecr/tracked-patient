import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tracked_pacient/provider/track_pacient.dart';
import 'package:provider/provider.dart';

class TrackScreen extends StatefulWidget {
  @override
  State<TrackScreen> createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  LatLng _currentPosition = LatLng(0, 0);

  Stream<Position>? _positionStream; 
 
    @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTrackingLocation();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
    });
  }

  void _startTrackingLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return;
      }
    }

    _positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15), 
      ),
    );

    _positionStream!.listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      //print("Eviando: ${_currentPosition}");
      final trackPacient = Provider.of<TrackPacient>(context, listen: false);
      trackPacient.updateCurrentLocation(
        "BF20250507215507", _currentPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Monitoramento'),
      ),
      body: Center(
        child: Column(
          children: [
            Text("Latitude: ${_currentPosition.latitude}"),
            Text("Longitude: ${_currentPosition.longitude}")
          ],
        ),
      ),

   );
  }
}