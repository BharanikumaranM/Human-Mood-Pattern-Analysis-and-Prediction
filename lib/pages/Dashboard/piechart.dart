import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class piechart extends StatefulWidget {
  const piechart({super.key});

  @override
  State<piechart> createState() => _piechartState();
}

class _piechartState extends State<piechart> {
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
    // print('Getting the Details');
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String userId = _auth.currentUser!.uid;
    DocumentReference userDocRef = firestore.collection('Users').doc(userId);

    userDocRef.get().then((docSnapshot) {
      if (docSnapshot.exists) {
        Map<String, dynamic> userData =
            docSnapshot.data() as Map<String, dynamic>;

        userData.forEach((key, value) {
          if (emotionsData.containsKey(key)) {
            // print(value as int);
            print(value as double);
            emotionsData[key] = value as int;
          }
        });

        print('Emotions Data Updated: $emotionsData');
        setState(() {});
      } else {
        // print('Document does not exist. Initializing with default values...');
        userDocRef.set(emotionsData).then((_) {
          // print('Document initialized with default values.');
        }).catchError((error) {
          // print('Error initializing document: $error');
        });
        // Call setState to rebuild the UI with default values
        setState(() {});
      }
    }).catchError((error) {
      // print('Error checking document existence: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pie Chart"),
        centerTitle: true,
      ),
      body: Column(children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 60),
          // child: Center(
          //   child: PieChart(
          //     dataMap: emotionsData,
          //     chartRadius: MediaQuery.of(context).size.width / 1.7,
          //     legendOptions: const LegendOptions(
          //       showLegends: false,
          //     ),
          //     chartValuesOptions: const ChartValuesOptions(
          //       showChartValuesInPercentage: true,
          //     ),
          //   ),
          // ),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () async {
              await getCounts(); // Call the getCounts method when the button is pressed
            },
            child: const Text("Get Count"),
          ),
        ),
      ]),
    );
  }
}
