// ignore_for_file: unused_element, prefer_const_constructors, sort_child_properties_last

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/auth/authn.dart';
import 'package:flutter_application_1/screens/details_screen.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({Key? key}) : super(key: key);

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _auth = FirebaseAuth.instance;
  late Timer timer;
  void initState() {
    super.initState();
    _auth.currentUser?.sendEmailVerification();
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
        timer.cancel();
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      }
    });
  }
  // bool isEmailVerified = false;
  // Timer? timer;
  // User? user;
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;

  //   if (isEmailVerified) {
  //     sendVerificationEmail();

  //     Timer.periodic(
  //       Duration(seconds: 3),
  //       (_) => checkEmailVerified(),
  //     );
  //   }
  // }

  // @override
  // void dispose() {
  //   timer?.cancel();
  //   // TODO: implement dispose
  //   super.dispose();
  // }

  // Future checkEmailVerified() async {
  //   await FirebaseAuth.instance.currentUser!.reload();
  //   setState(() {
  //     isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
  //   });
  //   if (isEmailVerified) timer?.cancel();
  // }

  // Future sendVerificationEmail() async {
  //   try {
  //     final user = FirebaseAuth.instance.currentUser!;
  //     await user.sendEmailVerification();
  //   } catch (e) {
  //     //Utils.showSnackBar(e.toString());
  //   }
  // }

  Future<void> _resendVerification(BuildContext context) async {
    try {
      var user = _auth.currentUser;
      if (user != null) {
        await user.sendEmailVerification();
        await user.reload();

        if (user.emailVerified) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => DetailsScreen()));
        }
        // Show a success message or navigate to another screen.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification email sent!'),
          ),
        );
        setState(() {});
      } else {
        // User not logged in
        // You might want to handle this case differently
      }
    } catch (e) {
      print('Error resending verification email: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Verify Email",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Verification email sent to ${FirebaseAuth.instance.currentUser?.email}",
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () => _resendVerification(context),
                child: Text(
                  "Resend Verification email",
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.transparent;
                      }
                      return Colors.black;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20))))),
          ),
        ],
      ),
    );
  }
}
