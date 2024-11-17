import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/customTextField.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/screens/updatePass.dart';

import 'package:intl/intl.dart';
// import 'package:flutter_application_1/sidebar.dart';

// import 'package:flutter_application_1/profile/theme.dart';

class UpdateProfileScreen extends StatefulWidget {
  final List profile;
  const UpdateProfileScreen({super.key, required this.profile});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  // late String img;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailTextController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  DateTime? createdOn =
      FirebaseAuth.instance.currentUser!.metadata.creationTime;
  @override
  void initState() {
    setTemp();

    // nameTextController.text = '2';
    // phoneController.text = '3';
    // emailTextController.text = 'g';
  }

  Future<void> deleteUserAccount() async {
    try {
      final FirebaseAuth auth = FirebaseAuth.instance;
      final User? user = auth.currentUser;
      String uid = user!.uid;
      String img = widget.profile[0]['image'];
      // user!.delete();

      await auth.currentUser!.delete();
      FirebaseFirestore.instance.collection("profile").doc(uid).delete();
      FirebaseStorage.instance.refFromURL(img).delete();
    } on FirebaseAuthException catch (e) {
      // log.e(e);
      print(e);

      // if (e.code == "requires-recent-login") {
      //   await _reauthenticateAndDelete();
      // } else {
      //   // Handle other Firebase exceptions
      // }
    } catch (e) {
      // log.e(e);
      print(e);

      // Handle general exception
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel", style: TextStyle()),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text(
        "Continue",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
      ),
      onPressed: () async {
        // final FirebaseAuth auth = FirebaseAuth.instance;
        // final User? user = auth.currentUser;
        // String uid = user!.uid;
        // // user!.delete();
        // FirebaseFirestore.instance.collection("profile").doc(uid).delete();
        // Navigator.pop(context);
        await deleteUserAccount().then((value) => Navigator.of(context)
            .pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => SignInScreen()),
                (Route<dynamic> route) => false));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Color.fromARGB(255, 232, 232, 232),
      title: Text("Alert Dialog"),
      content: Text(
        "Would you like to DELETE your profile ?",
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.w500, fontSize: 16),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future setTemp() async {
    // await getProfile().then((value) {
    //   profile = value;
    // });
    // sleep(Duration(seconds: 2));

    nameTextController = TextEditingController(text: widget.profile[0]['name']);
    emailTextController =
        TextEditingController(text: widget.profile[0]['email']);
    phoneController = TextEditingController(text: widget.profile[0]['phone']);
    passwordController = TextEditingController();
    setState(() {});
  }

  FilePickerResult? filePickerResult;

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      filePickerResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const SideBar(),
      appBar: AppBar(
        // leading: IconButton(
        //   onPressed: () => Get.back(),
        //   icon: const Icon(LineAwesomeIcons.angle_left),
        // ),
        title: const Text(
          "Edit Profile",
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.all(10),
              child: Column(children: [
                Stack(
                  children: [
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: filePickerResult == null
                                ? Image(
                                    image: NetworkImage(
                                        widget.profile[0]['image']),
                                    fit: BoxFit.cover,
                                  )
                                : Image(
                                    image: FileImage(File(
                                        filePickerResult!.files.first.path!)),
                                    fit: BoxFit.cover,
                                  ))),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: () {
                          _openFilePicker();
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.black),
                          child: const Icon(
                            Icons.edit_outlined,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // const SizedBox(
                //   height: 50,
                // ),
                Form(
                    child: Column(
                  children: [
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       label: Text("Full Name"),
                    //       prefixIcon: Icon(LineAwesomeIcons.user)),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       label: Text("Email"),
                    //       prefixIcon: Icon(LineAwesomeIcons.envelope)),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       label: Text("Phone No"),
                    //       prefixIcon: Icon(LineAwesomeIcons.phone_alt_solid)),
                    // ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    // TextFormField(
                    //   decoration: const InputDecoration(
                    //       label: Text("Password"),
                    //       prefixIcon: Icon(LineAwesomeIcons.fingerprint_solid)),
                    // ),
                    const SizedBox(height: 10),
                    Text(
                      widget.profile[0]['name'],
                      style:
                          TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                    Text(
                      widget.profile[0]['email'],
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomInputForm(
                      controller: nameTextController,
                      icon: Icons.person_outlined,
                      label: 'Name',
                      hint: '',
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // CustomInputForm(
                    //     controller: emailTextController,
                    //     icon: Icons.mail_outlined,
                    //     label: 'Email'),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomInputForm(
                      controller: phoneController,
                      icon: Icons.phone_outlined,
                      label: 'Mobile Number',
                      hint: '',
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // CustomInputForm(
                    //     controller: passwordController,
                    //     icon: Icons.fingerprint_outlined,
                    //     label: 'Password'),

                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            // Navigator.pushReplacement(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const ProfileScreen(profile: profile),
                            //   ),
                            // );
                            await updateUserProfile(
                                    nameTextController.text,
                                    phoneController.text,
                                    emailTextController.text,
                                    passwordController.text,
                                    filePickerResult,
                                    widget.profile[0]['image'])
                                .then((value) => ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                        content: Text('Profile Updated'))));
                            Navigator.pop(context);

                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             ProfileScreen(profile: l)));
                            // Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              side: BorderSide.none),
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    const Divider(
                      color: Color.fromARGB(242, 253, 253, 253),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => updatePassword(
                                  email: widget.profile[0]['email'],
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 0, 0),
                              side: BorderSide.none),
                          child: const Text(
                            "Change Password",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.access_time_outlined,
                            color: Colors.blueGrey[500]),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Account created on : ',
                          style: TextStyle(
                              // fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey[500]),
                        ),
                        Text(
                          DateFormat('d MMMM yyyy').format(createdOn!),
                          style: TextStyle(
                              // fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Colors.blueGrey[500]),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            showAlertDialog(context);
                            // showDialog(
                            //   context: context,
                            //   builder: (context) => Center(
                            //     child: CircularProgressIndicator(
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // );
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) =>
                            //         const UpdateProfileScreen(),
                            //   ),
                            // );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(250, 4, 4, 1),
                              side: BorderSide.none),
                          child: const Text(
                            "Delete Profile",
                            style: TextStyle(color: Colors.white),
                          )),
                    ),
                  ],
                ))
              ]))),
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
    );
  }
}
