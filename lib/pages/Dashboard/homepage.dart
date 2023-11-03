import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lsm/pages/Dashboard/datalist.dart';
import 'package:lsm/pages/Dashboard/tflitemodel.dart';
import 'package:lsm/pages/Dashboard/testtrack.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showAppBar = true;

  int _selectedIndex = 0;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  final tabs = const [
    Center(child: ImagePickerDemo()),
    Center(child: DataShow()),
    Center(child: Trackdetails()),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: showAppBar
          ? AppBar(actions: [
              IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
            ])
          : null,
      body: tabs[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,
              activeColor: Colors.black,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: Colors.black,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.account_box,
                  text: 'Profile',
                ),
                GButton(
                  icon: Icons.accessibility_sharp,
                  text: 'Track',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                  if (_selectedIndex == 0) {
                    showAppBar = true;
                  } else {
                    showAppBar = false;
                  }
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
