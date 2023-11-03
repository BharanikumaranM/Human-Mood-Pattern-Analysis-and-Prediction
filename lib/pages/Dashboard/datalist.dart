import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lsm/pages/Dashboard/datacard.dart';
import 'package:lsm/pages/Dashboard/partialtab.dart';

class DataShow extends StatefulWidget {
  const DataShow({super.key});

  @override
  State<DataShow> createState() => _DataShowState();
}

class _DataShowState extends State<DataShow> {
  User? userid;

  late Stream<QuerySnapshot<Object?>> _userStream;

  @override
  void initState() {
    super.initState();
    userid = FirebaseAuth.instance.currentUser;
    _userStream = FirebaseFirestore.instance
        .collection('Mood')
        .doc(userid?.uid)
        .collection('Different Moods')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactions'),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: _userStream, // Use the initialized stream here
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Connection Error");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          var docs = snapshot.data!.docs;
          // print(docs.length);
          const SizedBox(
            height: 20,
          );

          return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                // print(docs[index]['timestamp']);
                final timestamp =
                    docs[index].data().toString().contains("timestamp")
                        ? docs[index].get("timestamp")
                        : '';
                print(timestamp);
                final dateTime = timestamp.toDate();
                final formattedDate =
                    DateFormat.MMMd().add_y().format(dateTime);
                return CustomCard(
                  title: docs[index]['type'],
                  subtitle: docs[index]['description'],
                  img1: docs[index]['imageurl'],
                  location: docs[index]['location'],
                  timestamp: formattedDate,
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return const ProfileComponent();
              });
        },
        tooltip: 'Navigate to Profile',
        child: const Icon(Icons.person),
      ),
    );
  }
}
