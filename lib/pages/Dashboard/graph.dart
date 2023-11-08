import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Graph extends StatefulWidget {
  const Graph({Key? key}) : super(key: key);

  @override
  State<Graph> createState() => _GraphState();
}

class _GraphState extends State<Graph> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Map<String, int> emotionsData = {
    'angry': 0,
    'sadness': 0,
    'contempt': 0,
    'disgust': 0,
    'fear': 0,
    'happy': 0,
    'surprise': 0,
  };

  Future<void> getCounts() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = _auth.currentUser!.uid;
    DocumentReference userDocRef = firestore.collection('Users').doc(userId);

    userDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;

        userData.forEach((key, value) {
          if (emotionsData.containsKey(key)) {
            emotionsData[key] = value;
          }
        });

        setState(() {});
      } else {
        userDocRef.set(emotionsData).then((_) {
          setState(() {});
        }).catchError((error) {
          print('Error initializing document: $error');
        });
      }
    }).catchError((error) {
      print('Error checking document existence: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pie Chart"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 60),
              child: PieChart(
                swapAnimationDuration: const Duration(seconds: 1),
                swapAnimationCurve: Curves.easeInOutQuint,
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: emotionsData['angry']?.toDouble(),
                      color: Colors.blue,
                    ),
                    PieChartSectionData(
                      value: emotionsData['sadness']?.toDouble(),
                      color: Colors.purple,
                    ),
                    PieChartSectionData(
                      value: emotionsData['fear']?.toDouble(),
                      color: Colors.indigoAccent,
                    ),
                    PieChartSectionData(
                      value: emotionsData['contempt']?.toDouble(),
                      color: Colors.teal,
                    ),
                    PieChartSectionData(
                      value: emotionsData['happy']?.toDouble(),
                      color: Colors.lightBlue,
                    ),
                    PieChartSectionData(
                      value: emotionsData['surprise']?.toDouble(),
                      color: Colors.blueGrey,
                    ),
                    PieChartSectionData(
                      value: emotionsData['disgust']?.toDouble(),
                      color: Colors.lightGreen,
                    ),
                    // Include other sections here
                  ],
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await getCounts();
            },
            child: const Text("Get Count"),
          ),
          Card(
            margin: const EdgeInsets.all(16),
            child: SizedBox(
              height: 300,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DefaultTextStyle(
                    style: const TextStyle(
                      fontFamily:
                          'YourFont', // Replace with your desired font family
                      color: Colors.black, // Text color
                      fontSize: 16, // Text font size
                      fontWeight: FontWeight.bold, // Text weight
                    ),
                    child: Column(
                      children: [
                        _buildEmotionProgress(
                            "Happy", emotionsData['happy'] ?? 0),
                        _buildEmotionProgress(
                            "Surprise", emotionsData['surprise'] ?? 0),
                        _buildEmotionProgress(
                            "Angry", emotionsData['angry'] ?? 0),
                        _buildEmotionProgress(
                            "Sadness", emotionsData['sadness'] ?? 0),
                        _buildEmotionProgress(
                            "Contempt", emotionsData['contempt'] ?? 0),
                        _buildEmotionProgress(
                            "Disgust", emotionsData['disgust'] ?? 0),
                        _buildEmotionProgress(
                            "Fear", emotionsData['fear'] ?? 0),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmotionProgress(String emotion, int count) {
    return ListTile(
      title: Text(emotion),
      subtitle: LinearProgressIndicator(
        value:
            count / 100, // Assuming 100 is the maximum count for each emotion
        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
        backgroundColor: Colors.grey,
      ),
      trailing: Text("Count: $count"),
    );
  }
}
