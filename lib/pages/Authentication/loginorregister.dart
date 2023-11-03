import 'package:flutter/material.dart';
import 'package:lsm/pages/Authentication/Login.dart';
import 'package:lsm/pages/Authentication/registerpage.dart';

// ignore: camel_case_types
class loginorregister extends StatefulWidget {
  const loginorregister({super.key});

  @override
  State<loginorregister> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<loginorregister> {
  bool showLoginPage = true;
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(onTap: togglePages,);
    } else {
      return RegisterPage(onTap: togglePages);
    }
  }
}
