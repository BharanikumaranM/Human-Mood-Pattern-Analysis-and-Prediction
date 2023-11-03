import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FaceRecog extends StatefulWidget {
  const FaceRecog({super.key});

  @override
  State<FaceRecog> createState() => _FaceRecogState();
}

class _FaceRecogState extends State<FaceRecog> {
  String greetings = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Flask connection'),
        const SizedBox(height: 20),
        ElevatedButton(
            onPressed: () async {
              final response =
                  await http.get(Uri.parse('http://192.168.102.31:5000'));
              print(response.statusCode);
              final decoded =
                  json.decode(response.body) as Map<String, dynamic>;
              print('here');
              setState(() {
                greetings = decoded['greetings'].toString();
              });
            },
            child: const Text('submit')),
        Text(greetings),
      ],
    )));
  }
}
