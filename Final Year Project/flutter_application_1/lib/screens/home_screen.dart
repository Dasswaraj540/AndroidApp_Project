// ignore_for_file: prefer_const_constructors, unused_element, prefer_const_literals_to_create_immutables, unused_local_variable, non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_application_1/events/eventHome.dart';
import 'package:flutter_application_1/screens/post.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/screens/post2.dart';
import 'package:flutter_application_1/screens/safety.dart';
import 'package:flutter_application_1/screens/sidebar.dart';
import 'package:flutter_application_1/screens/signin_screen.dart';
import 'package:flutter_application_1/service/database.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

List<IconData> navIcons = [Icons.home, Icons.security, Icons.event];

int selectedIndex = 0;
final currentUser = FirebaseAuth.instance.currentUser!;
var userEmail = FirebaseAuth.instance.currentUser!.email;

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textcontroller = TextEditingController();
  Stream? UsersStream;

  getontheload() async {
    UsersStream = await DatabaseMethods().getUserData();
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      userEmail = user!.email;
    });
  }

  void signOut() async {
    await GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
  }

  Widget allUsersData() {
    return StreamBuilder(
        stream: UsersStream,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot ds = snapshot.data.docs[index];
                    return PostScreen(
                      message: ds["Message"],
                      name: ds["name"],
                      postId: ds.id,
                      likes: List<String>.from(ds["Likes"] ?? []),
                      image: NetworkImage(ds["image"]),
                      profileImage: ds["profileImg"],
                    );
                  })
              : Container();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          textAlign: TextAlign.center,
          "Feed",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          allUsersData(),
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImagePickPage()));
              },
              backgroundColor: Colors.black,
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _navBar()),
        ],
      ),
    );
  }

  Widget _navBar() {
    return Container(
      height: 65,
      margin: EdgeInsets.only(right: 24, left: 24, bottom: 24),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 20,
                spreadRadius: 10)
          ]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: navIcons.map((icon) {
          int index = navIcons.indexOf(icon);
          bool isSelected = selectedIndex == index;
          return Material(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
                switch (index) {
                  case 0:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    break;
                  case 1:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SafetyPage()),
                    );
                    break;
                  case 2:
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventHome()),
                    );
                    break;
                }
              },
              child: SingleChildScrollView(
                child: Container(
                  alignment: Alignment.center,
                  margin:
                      EdgeInsets.only(top: 0, bottom: 0, left: 35, right: 35),
                  child: Icon(
                    size: 28,
                    icon,
                    color: isSelected ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
