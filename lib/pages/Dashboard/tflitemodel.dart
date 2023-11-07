import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:tflite_v2/tflite_v2.dart';

class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String imageurl = '';
  String? _recognitions = "";
  File? image;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.gallery,
      );
      image = File(pickedImage!.path);
      setState(() {});
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> getImage() async {
    try {
      final picker = ImagePicker();
      final pickedImage = await picker.pickImage(
        source: ImageSource.camera,
      );
      image = File(pickedImage!.path);
      setState(() {});
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> uploadimage() async {
    final request = http.MultipartRequest(
        "POST", Uri.parse('http://172.17.48.107:5000/upload'));
    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        "image", image!.readAsBytes().asStream(), image!.lengthSync(),
        filename: image!.path.split("/").last));

    request.headers.addAll(headers);
    final response = await request.send();
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);

    _recognitions = resJson['message'];
    setState(() {});
  }

  Future<void> predictimagestore() async {
    var userRef = FirebaseFirestore.instance
        .collection('Users')
        .doc(_auth.currentUser?.uid)
        .collection('Predicted Moods')
        .doc();
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);
    DateTime now = DateTime.now();
    try {
      await referenceImageToUpload.putFile(File(image!.path));
      imageurl = await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      print(e);
    }
    await userRef.set({
      'emotionpredicted': _recognitions.toString(),
      'imageurl': imageurl,
      'timestamp': now,
    });
    print('done Uploading the image to database');
  }

  Future<void> updatecount() async {
    print('updating the count');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = _auth.currentUser!.uid;
    DocumentReference userDocRef = firestore.collection('Users').doc(userId);

    userDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser?.uid)
            .get()
            .then((value) {
          if (value.exists) {
            var userEmotionCount = value.data()?[_recognitions] as int?;
            if (userEmotionCount != null) {
              userEmotionCount++;
              var updateData = {_recognitions: userEmotionCount};
              value.reference.update(updateData.cast<Object, Object?>());

              print("Fetched =>>> $userEmotionCount (Updated)");
            } else {
              print("Fetched value is null.");
            }
          } else {
            print("Document does not exist.");
          }
        }).catchError((error) {
          print("Error fetching data: $error");
        });
      } else {
        print('Document does not exist. Initializing with default values...');

        Map<String, dynamic> initialData = {
          'angry': 0,
          'sadness': 0,
          'contempt': 0,
          'disgust': 0,
          'fear': 0,
          'happy': 0,
          'surprise': 0,
        };

        userDocRef.set(initialData).then((_) {
          print('Document initialized with default values.');
        }).catchError((error) {
          print('Error initializing document: $error');
        });
        FirebaseFirestore.instance
            .collection('Users')
            .doc(_auth.currentUser?.uid)
            .get()
            .then((value) {
          if (value.exists) {
            var userEmotionCount = value.data()?[_recognitions] as int?;
            if (userEmotionCount != null) {
              userEmotionCount++;
              var updateData = {_recognitions: userEmotionCount};
              value.reference.update(updateData.cast<Object, Object?>());

              print("Fetched =>>> $userEmotionCount (Updated)");
            } else {
              print("Fetched value is null.");
            }
          } else {
            print("Document does not exist.");
          }
        }).catchError((error) {
          print("Error fetching data: $error");
        });
      }
    }).catchError((error) {
      print('Error checking document existence: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (image != null)
              Image.file(
                File(image!.path),
                height: 200,
                width: 200,
                fit: BoxFit.cover,
              )
            else
              const Text('No image selected'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Gallery'),
            ),
            ElevatedButton(
              onPressed: getImage,
              child: const Text('Camera'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () async {
                  uploadimage();
                  predictimagestore();
                  updatecount();
                },
                //['anger', 'contempt', 'disgust', 'fear', 'happy', 'sadness', 'surprise']
                child: const Text("Detect Image")),
            Text(_recognitions.toString()),
          ],
        ),
      ),
    );
  }
}
