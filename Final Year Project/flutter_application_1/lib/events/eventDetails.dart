import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/screens/dateTime.dart';

class EventDetails extends StatefulWidget {
  final Map<String, dynamic> data;
  const EventDetails({
    super.key,
    required this.data,
  });

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  // final User? user = auth.currentUser;
  // final uid = user!.uid;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  bool isRVP = false;
  int add = 0;

  bool isUserPresent(List participants, String uid) {
    return participants.contains(uid);
  }

  @override
  void initState() {
    isRVP = isUserPresent(widget.data['participants'], uid);

    setState(() {});

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      // appBar: AppBar(
      //     backgroundColor: Colors.transparent,
      //     leading: IconButton(
      //         onPressed: () {
      //           // print(data['name']);
      //           Navigator.pop(context);
      //         },
      //         icon: Icon(Icons.arrow_back))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  // color: Colors.green,
                  height: 300,
                  width: double.infinity,
                  child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(0.15), BlendMode.darken),
                      child: Image.network(
                        widget.data['image'],
                        fit: BoxFit.cover,
                      )),
                ),
                Positioned(
                  top: 25,
                  child: IconButton(
                      onPressed: () {
                        // print(widget.data);
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_outlined,
                        color: Colors.white,
                        size: 30,
                      )),
                ),
                Positioned(
                  bottom: 45,
                  left: 8,
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        formatDate(widget.data['dateTime']),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                      SizedBox(
                        width: 14,
                      ),
                      Icon(
                        Icons.access_time_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                      Text(
                        formatTime(widget.data['dateTime']),
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 8,
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 22,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.data['location'],
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.data['name'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.data['description'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.people_alt,
                        color: Color.fromARGB(255, 80, 117, 180),
                        size: 21,
                      ),
                      Text(
                        ' ${((widget.data['participants'].length + add).toString())}',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(255, 80, 117, 180)),
                      ),
                      Text(
                        ' people are attending the event',
                        style: TextStyle(
                            fontSize: 17,
                            color: Color.fromARGB(255, 80, 117, 180)),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Text(
                    'Chief guest',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    widget.data['guest'] == '' ? 'None' : widget.data['guest'],
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Participants',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        'Year : ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.data['year'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        'Course : ',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        widget.data['branch'],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 90,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: isRVP
                              ? MaterialStateProperty.all(Colors.green)
                              : MaterialStateProperty.all(Colors.black)),
                      onPressed: () {
                        // isRVP ? add = -1 : add = 0;
                        // setState(() {});

                        RSVP(widget.data['participants'], widget.data['id'],
                                isRVP)
                            .then((value) {
                          if (value) {
                            setState(() {
                              isRVP = true;
                              add = 1;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'RSVP successful,count will be updated shortly')));
                            });
                          } else {
                            setState(() {
                              isRVP = false;
                              add = 0;
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      'RSVP cancelled,count will be updated shortly')));
                            });
                          }
                        });
                      },
                      child: isRVP
                          ? Text(
                              'You are attending the event',
                              style: TextStyle(color: Colors.white),
                            )
                          : Text(
                              'RSVP Event',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
