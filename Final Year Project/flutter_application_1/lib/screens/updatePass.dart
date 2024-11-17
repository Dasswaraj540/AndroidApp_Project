import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_application_1/customTextField.dart';
import 'package:flutter_application_1/screens/customTextField.dart';

class updatePassword extends StatefulWidget {
  final String email;
  const updatePassword({super.key, required this.email});

  @override
  State<updatePassword> createState() => _updatePasswordState();
}

class _updatePasswordState extends State<updatePassword> {
  int a = 0;
  TextEditingController oldPassController = TextEditingController();
  TextEditingController newPassController = TextEditingController();
  var currentUser = FirebaseAuth.instance.currentUser;

  Future<int> changePassword({email, oldPass, newPass}) async {
    // print(email);
    // print(oldPass);
    // print(newPass);
    // var cred = EmailAuthProvider.credential(email: email, password: oldPass);
    // await currentUser!.reauthenticateWithCredential(cred).then((value) {
    //   currentUser!.updatePassword(newPass).then((value) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text('Password Changed')));
    //   }).catchError((onError) {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(content: Text('${onError}')));
    //   });
    // }).catchError((onError) {
    //   // return;
    // });
    User user = FirebaseAuth.instance.currentUser!;
    AuthCredential credential =
        EmailAuthProvider.credential(email: user.email!, password: oldPass);

    Map<String, String?> codeResponses = {
      // Re-auth responses
      "user-mismatch": null,
      "user-not-found": null,
      "invalid-credential": 'Invalid Old Password',
      "invalid-email": null,
      "wrong-password": 'Wrong Password',
      "invalid-verification-code": null,
      "invalid-verification-id": null,
      "too-many-requests": 'Too many trys please try after sometime',
      // Update password error codes
      "weak-password": 'Weak Password',
      "requires-recent-login": 'Recent login required'
    };

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPass);

      // Navigator.pop(context);
      await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Changed Successfully!!! ')));
      return 1;
    } on FirebaseAuthException catch (error) {
      // print(codeResponses[error.code] ?? "Unknown");
      print(error.code);
      await ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(codeResponses[error.code] ?? "Unknown")));
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomInputForm(
              controller: oldPassController,
              icon: Icons.fingerprint_outlined,
              label: "Old Password",
              hint: '',
            ),
            SizedBox(
              height: 20,
            ),
            CustomInputForm(
              controller: newPassController,
              icon: Icons.fingerprint_outlined,
              label: "New Password",
              hint: '',
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: a == 1
                      ? null
                      : () async {
                          // showDialog(
                          //   context: context,
                          //   builder: (context) => Center(
                          //     child: CircularProgressIndicator(
                          //       color: Colors.black,
                          //     ),
                          //   ),
                          // );
                          a = await changePassword(
                              email: widget.email,
                              oldPass: oldPassController.text,
                              newPass: newPassController.text);
                          setState(() {
                            a = a;
                          });

                          // Navigator.of(context).pop(true);

                          // Navigator.of(context)
                          //   ..pop()
                          //   ..pop();
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         const UpdateProfileScreen(),
                          //   ),
                          // );
                        },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      side: BorderSide.none),
                  child: const Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 300,
              height: 50,
              child: ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      side: BorderSide.none),
                  child: const Text(
                    "Go Back",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
