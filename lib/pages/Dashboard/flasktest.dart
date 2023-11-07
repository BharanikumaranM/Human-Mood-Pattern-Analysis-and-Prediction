// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';

// class FaceRecog extends StatefulWidget {
//   const FaceRecog({super.key});

//   @override
//   State<FaceRecog> createState() => _FaceRecogState();
// }

// class _FaceRecogState extends State<FaceRecog> {
//   String? _recognitions = "";
//   File? image;

//   Future<void> getImage() async {
//     final picker = ImagePicker();
//     final pickedImage = await picker.pickImage(
//       source: ImageSource.camera,
//     );
//     image = File(pickedImage!.path);
//     setState(() {});
//   }

//   Future<void> uploadimage() async {
//     print('here');
//     final request = http.MultipartRequest(
//         "POST", Uri.parse('http://192.168.19.31:5000/upload'));

//     final headers = {"Content-type": "multipart/form-data"};
//     request.files.add(http.MultipartFile(
//         "image", image!.readAsBytes().asStream(), image!.lengthSync(),
//         filename: image!.path.split("/").last));
//     request.headers.addAll(headers);
//     print('2 here');
//     final response = await request.send();
//     print('message sent');
//     http.Response res = await http.Response.fromStream(response);
//     final resJson = jsonDecode(res.body);
//     _recognitions = resJson['message'];
//     print('3 here');
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: Center(
//             child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         // const Text('Flask connection'),
//         image == null ? const Text('Please pick an Image') : Image.file(image!),
//         const SizedBox(height: 20),
//         TextButton.icon(
//             onPressed: () async {
//               // final response =
//               //     await http.get(Uri.parse('http://192.168.102.31:5000'));
//               // print(response.statusCode);
//               // final decoded =
//               //     json.decode(response.body) as Map<String, dynamic>;
//               // print('here');
//               // setState(() {
//               //   greetings = decoded['greetings'].toString();
//               // });
//               // getImage();
//               uploadimage();
//             },
//             style: ButtonStyle(
//               backgroundColor: MaterialStateProperty.all(Colors.blue),
//             ),
//             icon: const Icon(Icons.upload_file, color: Colors.white),
//             label: const Text('submit')),
//         Text(_recognitions!),
//         FloatingActionButton(
//             onPressed: () async {
//               getImage();
//             },
//             child: const Icon(Icons.add_a_photo)),
//       ],
//     )));
//   }
// }
