// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lsm/components/mytextfield.dart';

//TODO: fake email registration error handling
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[200],
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            'Enter Your Email and we will send you an password reset link',
            style: TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 25,
          ),
          MyTextField(
            controller: emailController,
            hintText: 'Email',
            obscureText: false,
          ),
          const SizedBox(height: 35),
          MaterialButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text.trim());
                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        content: Text("Password Reset Link Sent!"),
                      );
                    });
              } on FirebaseAuthException catch (e) {
                // ignore: use_build_context_synchronously
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(e.message.toString()),
                      );
                    });
              }
            },
            color: Colors.deepPurple[200],
            child: const Text("Reset Password"),
          ),
        ],
      ),
    );
  }
}
