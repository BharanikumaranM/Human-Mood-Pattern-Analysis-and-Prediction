import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Trackdetails extends StatefulWidget {
  const Trackdetails({super.key});

  @override
  State<Trackdetails> createState() => _TrackdetailsState();
}

class _TrackdetailsState extends State<Trackdetails> {
  // ignore: non_constant_identifier_names
  var Address = '';
  // User? userid = FirebaseAuth.instance.currentUser;

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  // ignore: non_constant_identifier_names
  Future<void> GetAddress(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    print(placemark);
    Address = '${place.subAdministrativeArea}, ${place.locality}';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Coordinates'),
        const SizedBox(height: 20),
        Text(Address),
        ElevatedButton(
            onPressed: () async {
              Position pos = await _determinePosition();
              GetAddress(pos);
              setState(() {});
            },
            child: const Text('Get Location'))
      ],
    )));
  }
}
