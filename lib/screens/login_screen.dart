import 'package:final_year_project/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../services/uihelper.dart';
import 'dashboard_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login(String email, String password) async {
    if (email == "" && password == "") {
      return UiHelper.CustomAlertBox(context, "Enter Required Fields");
    } else {

      try {
        UserCredential? usercredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
       Navigator.push(context, MaterialPageRoute(builder: (context)=>DashboardScreen()));


      } on FirebaseAuthException catch(ex){
        return UiHelper.CustomAlertBox(context, ex.code.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UiHelper.CustomTextField(emailController, "Email", Icons.mail, false),
            UiHelper.CustomTextField(
                passwordController, "Password", Icons.password, true),
            const SizedBox(height: 30),
            UiHelper.CustomButton(() async{
              await  login(emailController.text.toString(),
                  passwordController.text.toString());
            }, "Login"),
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Already have an Account",
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(width: 40),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignUpPage()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700,color: Colors.black),

                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
