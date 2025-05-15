import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/uihelper.dart';
import 'login_screen.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String selectedRole = 'employee'; // Default role

  final List<String> roles = ['admin', 'employee'];

  Future<void> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      UiHelper.CustomAlertBox(context, "Enter Required Fields");
      return;
    }

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user role in Firestore
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userCredential.user!.uid)
          .set({
        'email': email,
        'role': selectedRole,
      });

      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } on FirebaseAuthException catch (ex) {
      UiHelper.CustomAlertBox(context, ex.message.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
            UiHelper.CustomTextField(passwordController, "Password", Icons.password, true),

            const SizedBox(height: 20),

            // Role Dropdown
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Select Role',
                ),
                items: roles
                    .map((role) => DropdownMenuItem(
                  value: role,
                  child: Text(role[0].toUpperCase() + role.substring(1)),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            UiHelper.CustomButton(() {
              signUp(emailController.text.trim(), passwordController.text.trim());
            }, "Sign Up"),
          ],
        ),
      ),
    );
  }
}
