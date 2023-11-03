import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

class ProfileComponent extends StatefulWidget {
  const ProfileComponent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ProfileComponentState createState() => _ProfileComponentState();
}

class _ProfileComponentState extends State<ProfileComponent> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final TextEditingController _mood = TextEditingController();
  final TextEditingController _mooddescription = TextEditingController();
  File? _profileImage;
  List<String> emotions = [
    'Sad Memories',
    'Happy Memories',
    'Angry',
    'Excited',
    'Surprised',
  ];
  String? selectedEmotion;
  String imageUrl = '';
  var address = '';

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<void> _getAddress(Position position) async {
    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark place = placemark[0];
    setState(() {
      if (place.subAdministrativeArea != null) {
        address = '${place.subAdministrativeArea}, ${place.locality}';
      } else {
        address = '${place.locality}';
      }
    });
  }

  Future<void> _pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) return;
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(pickedFile.path));
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      // Handle errors as needed
    }

    setState(() {
      _profileImage = File(pickedFile.path);
    });
  }

  Future<void> saveUserData() async {
    if (_profileImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image.'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (selectedEmotion!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reaction field is required.'),
          backgroundColor: Colors.red,
        ),
      );
    } else {
      var userRef = FirebaseFirestore.instance
          .collection('Mood')
          .doc(_auth.currentUser?.uid)
          .collection('Different Moods')
          .doc();
      Position pos = await _determinePosition();
      await _getAddress(pos);
      DateTime now = DateTime.now();
      // print(now);
      // String formattedDate = DateFormat.MMMd().add_y().format(now);
      // print(formattedDate);

      await userRef.set({
        'type': selectedEmotion,
        'imageurl': imageUrl,
        'description': _mooddescription.text,
        'location': address,
        'timestamp': now,
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.check, color: Colors.green),
              SizedBox(width: 8),
              Text('User data saved successfully'),
            ],
          ),
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: _pickProfileImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 80,
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage('lib/images/user.png')
                            as ImageProvider<Object>,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: selectedEmotion,
                onChanged: (newValue) {
                  setState(() {
                    selectedEmotion = newValue;
                  });
                },
                items: emotions.map((emotion) {
                  return DropdownMenuItem<String>(
                    value: emotion,
                    child: Text(emotion),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Your Reaction',
                  prefixIcon: const Icon(Icons.emoji_emotions),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _mooddescription,
                decoration: InputDecoration(
                  labelText: 'Description for the Reaction',
                  prefixIcon: const Icon(Icons.description),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 28.0),
              ElevatedButton(
                onPressed: () {
                  saveUserData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "Save",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
