import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_v2/tflite_v2.dart';

class ImagePickerDemo extends StatefulWidget {
  const ImagePickerDemo({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImagePickerDemoState createState() => _ImagePickerDemoState();
}

class _ImagePickerDemoState extends State<ImagePickerDemo> {
  // final ImagePicker _picker = ImagePicker();
  // XFile? _image;
  // File? file;
  // // ignore: prefer_typing_uninitialized_variables
  // var _recognitions;
  // var v = "";

  // @override
  // void initState() {
  //   super.initState();
  //   loadmodel().then((value) {
  //     setState(() {});
  //   });
  // }

  // loadmodel() async {
  //   await Tflite.loadModel(
  //     model: "lib/images/model_unquant.tflite",
  //     labels: "lib/images/labels.txt",
  //   );
  // }
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

  // Future detectimage(XFile image) async {
  //   int startTime = DateTime.now().millisecondsSinceEpoch;
  //   var recognitions = await Tflite.runModelOnImage(
  //     path: image.path,
  //     numResults: 6,
  //     threshold: 0.05,
  //     imageMean: 127.5,
  //     imageStd: 127.5,
  //   );
  //   setState(() {
  //     _recognitions = recognitions;
  //     v = recognitions.toString();
  //   });
  //   print(_recognitions);
  //   int endTime = DateTime.now().millisecondsSinceEpoch;
  //   print("Inference took ${endTime - startTime}ms");

  // }

  Future<void> uploadimage() async {
    print('here');
    final request = http.MultipartRequest(
        "POST", Uri.parse('http://172.17.48.107:5000/upload'));

    final headers = {"Content-type": "multipart/form-data"};
    request.files.add(http.MultipartFile(
        "image", image!.readAsBytes().asStream(), image!.lengthSync(),
        filename: image!.path.split("/").last));
    request.headers.addAll(headers);
    print('2 here');
    final response = await request.send();
    print('message sent');
    http.Response res = await http.Response.fromStream(response);
    final resJson = jsonDecode(res.body);
    _recognitions = resJson['message'];
    print('3 here');
    setState(() {});
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
            const SizedBox(height: 20), // Display recognition results here
            ElevatedButton(
                onPressed: () {
                  uploadimage();
                },
                child: const Text("Detect Image")),
            Text(_recognitions.toString()),
          ],
        ),
      ),
    );
  }
}
