import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/customInputDecor.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/screens/updateProfileScreen.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List profile = [
    {
      'name': 'Name',
      'email': 'email@gmail.com',
      'age': 'Age',
      'phone': 'Phone',
      'regdNo': 'Registration Number',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/eventspageapp.appspot.com/o/images%2F307ce493-b254-4b2d-8ba4-d12c080d6651.jpg?alt=media&token=d7d28313-811c-4a10-8429-70c7d7bdacdd'
    }
  ];

  DateTime? createdOn =
      FirebaseAuth.instance.currentUser!.metadata.creationTime;

  @override
  void initState() {
    super.initState();
    refresh();
  }

  void refresh() {
    getProfile().then((value) {
      profile = value;
      setState(() {});
    });
  }

  showAlertDialog(BuildContext context) {
    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: const Text(
        "Log Out",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700),
      ),
      onPressed: () async {
        await FirebaseAuth.instance.signOut().then((value) =>
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SignInScreen())));
      },
    );

    AlertDialog alert = AlertDialog(
      title: const Text("Log Out"),
      content: const Text("Would you like to log out?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showAlertDialog(context);
            },
            icon: const Icon(
              Icons.logout_outlined,
              size: 26,
            ),
          ),
        ],
        title: const Text(
          "Profile",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                // Add functionality to change profile picture
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage('${profile[0]['image']}'),
                    backgroundColor: Colors.grey.shade300,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${profile[0]['name']}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22),
            ),
            Text(
              profile[0]['email'],
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdateProfileScreen(
                      profile: profile,
                    ),
                  ),
                );
                refresh();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              child: const Text(
                "Edit Profile",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            CustomInputDecor(
                icon: Icons.person_outlined,
                label: 'Name',
                data: profile[0]['name']),
            const SizedBox(height: 15),
            CustomInputDecor(
                icon: Icons.calendar_month_outlined,
                label: 'Age',
                data: profile[0]['age']),
            const SizedBox(height: 15),
            CustomInputDecor(
                icon: Icons.phone_outlined,
                label: 'Mobile Number',
                data: profile[0]['phone']),
            const SizedBox(height: 15),
            CustomInputDecor(
                icon: Icons.numbers_outlined,
                label: 'Registration Number',
                data: profile[0]['regdNo']),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_outlined, color: Colors.blueGrey[500]),
                const SizedBox(width: 10),
                Text(
                  'Account created on: ',
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.blueGrey[500]),
                ),
                Text(
                  DateFormat('d MMMM yyyy').format(createdOn!),
                  style: TextStyle(
                      fontWeight: FontWeight.w700, color: Colors.blueGrey[500]),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 245, 245, 245),
    );
  }
}
