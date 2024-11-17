// ignore_for_file: prefer_const_constructors

import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_application_1/screens/Home_Screen_2.dart";
import "package:flutter_application_1/screens/about.dart";
import "package:flutter_application_1/screens/add_contacts.dart";
import "package:flutter_application_1/events/database.dart";
import "package:flutter_application_1/screens/help.dart";
import "package:flutter_application_1/screens/profile_screen.dart";
import "package:flutter_application_1/screens/signin_screen.dart";

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  List profile = [
    {
      'name': 'Name',
      'email': 'email@gmail.com',
      'image':
          'https://firebasestorage.googleapis.com/v0/b/eventspageapp.appspot.com/o/images%2F307ce493-b254-4b2d-8ba4-d12c080d6651.jpg?alt=media&token=d7d28313-811c-4a10-8429-70c7d7bdacdd'
    }
  ];

  void initState() {
    refresh();
  }

  void refresh() {
    getProfile().then((value) {
      profile = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            child: UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image(
                      image: NetworkImage(profile[0]['image']),
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(
                      image: AssetImage('assets/images/bg3.jpeg'),
                      fit: BoxFit.cover),
                ),
                accountName: Text(profile[0]['name']),
                accountEmail: Text(profile[0]['email'])),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Home"),
            onTap: () => {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen2()))
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text("Trusted Contacts"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddContactsPage()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => helpPage())),
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text("About"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => AboutPage())),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text("Log Out"),
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) =>
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignInScreen())));
            },
          ),
        ],
      ),
    );
  }
}
