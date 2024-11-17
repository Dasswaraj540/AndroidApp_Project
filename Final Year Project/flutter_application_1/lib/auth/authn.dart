// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/VerifyEmail_screen.dart';
import 'package:flutter_application_1/screens/details_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/onboardingScreen.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder<User?>(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             User? user = snapshot.data;
//             if (user != null && user.emailVerified) {
//               return HomeScreen();
//             } else {
//               return DetailsScreen();
//             }
//           } else {
//             return OnboardingScreen();
//           }
//         },
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("Error"),
            );
          } else {
            if (snapshot.data == null) {
              return SignInScreen();
            } else if (snapshot.data?.emailVerified == true) {
              return DetailsScreen();
            } else {
              return VerifyEmailScreen();
            }
          }
        },
      ),
    );
  }
}
