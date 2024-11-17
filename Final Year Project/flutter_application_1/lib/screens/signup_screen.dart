// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_application_1/screens/VerifyEmail_screen.dart';
import 'package:flutter_application_1/screens/details_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _userNameTextController = TextEditingController();
  TextEditingController _userName2TextController = TextEditingController();

  // void signUp() async {
  //   showDialog(
  //       context: context,
  //       builder: (context) => Center(
  //             child: CircularProgressIndicator(),
  //           ));

  //   try {
  //     final newUser = await FirebaseAuth.instance
  //         .createUserWithEmailAndPassword(
  //             email: _emailTextController.text,
  //             password: _passwordTextController.text)
  //         .then((value) {
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
  //     });
  //     // if (newUser != null) {
  //     //   final currentContext = context;
  //     //   await newUser.user?.sendEmailVerification().then((value) {
  //     //     Navigator.pushReplacement(currentContext,
  //     //         MaterialPageRoute(builder: (context) => VerifyEmailScreen()));
  //     //   });
  //     // }
  //     if (context.mounted) Navigator.pop(context);
  //   } on FirebaseAuthException catch (e) {
  //     Navigator.pop(context);
  //     displayMessage(e.code);
  //   }
  // }

  void signUp() async {
    showDialog(
      context: context,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      //print("Inside try block");
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailTextController.text,
        password: _passwordTextController.text,
      );

      if (userCredential != null) {
        // await userCredential.user?.sendEmailVerification();
        await FirebaseAuth.instance.currentUser?.sendEmailVerification();
        Navigator.pop(context); // Dismiss the loading dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VerifyEmailScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      //print("FirebaseAuthException: ${e.code}");
      Navigator.pop(context); // Dismiss the loading dialog
      displayMessage(e.code);
    }
  }

  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
          ),
          // SizedBox(
          //   width: 350,
          //   child: Row(
          //     children: <Widget>[
          //       reusableTextField("First Name", Icons.person_2_outlined, false,
          //           _userNameTextController),
          //       SizedBox(
          //         width: 10,
          //       ),
          //       reusableTextField("Last Name", Icons.person_2_outlined, false,
          //           _userName2TextController),
          //     ],
          //   ),
          // ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 350,
            child: Row(
              children: <Widget>[
                reusableTextField("Enter Email Id", Icons.person_2_outlined,
                    false, _emailTextController),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
            width: 350,
            child: Row(
              children: <Widget>[
                reusableTextField("Enter Password", Icons.lock_outline, true,
                    _passwordTextController),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 350, child: signInSignUpButton(context, false, signUp)),
          SizedBox(
            height: 10,
          ),
          signUpOption(context),
        ]),
      ),
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text(
        "Have an account?",
        style: TextStyle(color: Colors.black87),
      ),
      GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => SignInScreen()));
        },
        child: const Text(
          " Sign In",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}
