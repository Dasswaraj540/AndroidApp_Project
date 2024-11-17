// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/Home_Screen_2.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/onboardingScreen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';

class RealAuth extends StatelessWidget {
  const RealAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            //user is logged in
            if (snapshot.hasData) {
              return HomeScreen();
            }
            //user is not logged in
            else {
              return OnboardingScreen();
            }
          }),
    );
  }
}
