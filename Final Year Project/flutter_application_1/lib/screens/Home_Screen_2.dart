// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/events/eventContainer.dart';
import 'package:flutter_application_1/events/eventHome.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/post_for_home.dart';
import 'package:flutter_application_1/service/database.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({Key? key}) : super(key: key);

  @override
  _HomeScreen2State createState() => _HomeScreen2State();
}

class _HomeScreen2State extends State<HomeScreen2>
    with SingleTickerProviderStateMixin {
  Stream? usersStream;
  List profile = [
    {'name': 'User'}
  ];

  void getDataOnLoad() async {
    usersStream = await DatabaseMethods().getUserData();
    setState(() {});
  }

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super
        .initState(); // Call super.initState() before any other initializations
    getDataOnLoad();
    refresh();
    getProfile().then((value) {
      profile = value;
    });

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List events = [];
  List<List> filterList = [];
  List<String> titles = ['Name', 'Branch', 'Year'];
  List<int>? filterIndex;
  bool isLoading = true;
  String changeText = 'Upcoming Events';

  @override
  void refresh() {
    getAllEvents().then((value) {
      events = value;
      filterList = getFilterList(events);
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double targetHeight = screenHeight * 0.65; // 65% of screen height

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Hello ${profile[0]['name'].split(' ')[0]} !',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  //height: 200,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen())),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.teal.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.green, Colors.teal],
                                ),
                              ),
                              height: targetHeight,
                              padding: EdgeInsets.all(16.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16.0),
                                child: StreamBuilder(
                                  stream: usersStream,
                                  builder: (context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: CircularProgressIndicator());
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.data.docs.isEmpty) {
                                      return Center(
                                          child: Text('No data available'));
                                    }

                                    return Expanded(
                                      child: CarouselSlider.builder(
                                        itemCount: snapshot.data.docs.length,
                                        options: CarouselOptions(
                                          scrollDirection: Axis.vertical,
                                          height: targetHeight,
                                          enlargeCenterPage: true,
                                          enableInfiniteScroll: true,
                                          autoPlay: true,
                                          autoPlayInterval:
                                              Duration(seconds: 5),
                                          autoPlayAnimationDuration:
                                              Duration(milliseconds: 800),
                                          pauseAutoPlayOnTouch: true,
                                          viewportFraction: 0.9,
                                          aspectRatio: 16 / 9,
                                        ),
                                        itemBuilder:
                                            (context, index, realIndex) {
                                          DocumentSnapshot ds =
                                              snapshot.data.docs[index];
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0),
                                            child: PostScreen2(
                                              message: ds["Message"],
                                              name: ds["name"],
                                              postId: ds.id,
                                              image: NetworkImage(ds["image"]),
                                              profileImage: ds["profileImg"],
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black,
                              ],
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.bottomLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, bottom: 7),
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return ShaderMask(
                                      shaderCallback: (bounds) {
                                        return LinearGradient(
                                          colors: [
                                            Color(0xFF00C6FF),
                                            Color(0xFF0072FF),
                                            Color(0xFF6A0DAD),
                                            //Colors.green,
                                            Colors.teal
                                          ],
                                          begin:
                                              Alignment(-_animation.value, -2),
                                          end: Alignment(
                                              1 - _animation.value, 0),
                                        ).createShader(bounds);
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            'Explore\nwhats happening\naround you',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // This will be masked by the gradient
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Transform.translate(
                                            offset: Offset(_animation.value, 3),
                                            child: Icon(
                                              Icons.arrow_forward,
                                              color: Colors.white,
                                              size: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              isLoading
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => Navigator.push(context,
                          MaterialPageRoute(builder: (context) => EventHome())),
                      child: Stack(
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.orange.shade400
                                          .withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.orange.shade400,
                                      Colors.purple
                                    ],
                                  ),
                                ),
                                height: 400,
                                child: CarouselSlider(
                                  options: CarouselOptions(
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 5),
                                    aspectRatio: 16 / 9,
                                    viewportFraction: 0.9,
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  ),
                                  items: [
                                    ...List.generate(events.length, (index) {
                                      return EventContainer(
                                        data: events[index],
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [Colors.transparent, Colors.black],
                                  ),
                                ),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, bottom: 7),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: AnimatedBuilder(
                                        animation: _animation,
                                        builder: (context, child) {
                                          return ShaderMask(
                                            shaderCallback: (bounds) {
                                              return LinearGradient(
                                                colors: [
                                                  Color(0xFF2196F3), // Blue

                                                  Color(0xFF81D4FA),
                                                  Colors.teal,
                                                  Color.fromARGB(
                                                      255, 160, 71, 176)
                                                  // DodgerBlue
                                                ],
                                                begin: Alignment(
                                                    -_animation.value, -2),
                                                end: Alignment(
                                                    1 - _animation.value, 0),
                                              ).createShader(bounds);
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  "Don't\nforget to checkout\nall events",
                                                  textAlign: TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors
                                                        .white, // This will be masked by the gradient
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Transform.translate(
                                                  offset: Offset(
                                                      _animation.value, 1),
                                                  child: Icon(
                                                    Icons.arrow_forward,
                                                    color: Colors.white,
                                                    size: 30,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// // ignore_for_file: prefer_const_constructors

// // ignore_for_file: prefer_const_constructors

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_application_1/events/database.dart';
// import 'package:flutter_application_1/events/eventContainer.dart';
// import 'package:flutter_application_1/events/eventHome.dart';
// import 'package:flutter_application_1/screens/post_for_home.dart';
// import 'package:flutter_application_1/service/database.dart';

// class HomeScreen2 extends StatefulWidget {
//   const HomeScreen2({Key? key}) : super(key: key);

//   @override
//   _HomeScreen2State createState() => _HomeScreen2State();
// }

// class _HomeScreen2State extends State<HomeScreen2> {
//   Stream? usersStream;

//   void getDataOnLoad() async {
//     usersStream = await DatabaseMethods().getUserData();
//     setState(() {});
//   }

//   @override
//   void initState() {
//     getDataOnLoad();
//     refresh();
//     super.initState();
//   }

//   List events = [];
//   List<List> filterList = [];
//   List<String> titles = ['Name', 'Branch', 'Year'];
//   List<int>? filterIndex;
//   bool isLoading = true;
//   String changeText = 'Upcoming Events';

//   @override
//   void refresh() {
//     getAllEvents().then((value) {
//       events = value;
//       filterList = getFilterList(events);
//       isLoading = false;
//       setState(() {});
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double screenHeight = MediaQuery.of(context).size.height;
//     double targetHeight = screenHeight * 0.65; // 65% of screen height

//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               Stack(
//                 children: [
//                   //padding: const EdgeInsets.all(16.0),
//                   SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(16.0),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.teal.withOpacity(0.3),
//                                   blurRadius: 10,
//                                   offset: Offset(0, 5),
//                                 ),
//                               ],
//                               gradient: LinearGradient(
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomCenter,
//                                 colors: [
//                                   Colors.green, Colors.teal // Coral
//                                 ],
//                               ),
//                             ),
//                             height: targetHeight,
//                             padding: EdgeInsets.all(16.0),
//                             child: ClipRRect(
//                               borderRadius: BorderRadius.circular(16.0),
//                               child: StreamBuilder(
//                                 stream: usersStream,
//                                 builder: (context, AsyncSnapshot snapshot) {
//                                   if (snapshot.connectionState ==
//                                       ConnectionState.waiting) {
//                                     return Center(
//                                         child: CircularProgressIndicator());
//                                   }
//                                   if (!snapshot.hasData ||
//                                       snapshot.data.docs.isEmpty) {
//                                     return Center(
//                                         child: Text('No data available'));
//                                   }

//                                   return Expanded(
//                                     child: CarouselSlider.builder(
//                                       itemCount: snapshot.data.docs.length,
//                                       options: CarouselOptions(
//                                         scrollDirection: Axis.vertical,
//                                         height: targetHeight,
//                                         enlargeCenterPage: true,
//                                         enableInfiniteScroll: true,
//                                         autoPlay: true,
//                                         autoPlayInterval: Duration(seconds: 5),
//                                         autoPlayAnimationDuration:
//                                             Duration(milliseconds: 800),
//                                         pauseAutoPlayOnTouch: true,
//                                         viewportFraction: 0.9,
//                                         aspectRatio: 16 / 9,
//                                       ),
//                                       itemBuilder: (context, index, realIndex) {
//                                         DocumentSnapshot ds =
//                                             snapshot.data.docs[index];
//                                         return Expanded(
//                                           child: Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 vertical: 8.0),
//                                             child: PostScreen2(
//                                               message: ds["Message"],
//                                               name: ds["name"],
//                                               postId: ds.id,
//                                               image: NetworkImage(ds["image"]),
//                                               profileImage: ds["profileImg"],
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Positioned.fill(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16.0),
//                           gradient: LinearGradient(
//                             begin: Alignment.topCenter,
//                             end: Alignment.bottomCenter,
//                             colors: [
//                               Colors.transparent,
//                               Colors.black.withOpacity(0.5),
//                             ],
//                           ),
//                         ),
//                         child: Align(
//                           alignment: Alignment.bottomLeft,
//                           child: Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: FittedBox(
//                               fit: BoxFit.contain,
//                               child: Text(
//                                 textAlign: TextAlign.center,
//                                 'Explore',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontSize: 24,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               isLoading
//                   ? const SizedBox()
//                   : Stack(
//                       children: [
//                         Container(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16.0),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.teal.withOpacity(0.3),
//                                     blurRadius: 10,
//                                     offset: Offset(0, 5),
//                                   ),
//                                 ],
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     Colors.orange.shade400,
//                                     Colors.purple // Coral
//                                   ],
//                                 ),
//                               ),
//                               height: screenHeight - targetHeight,
//                               child: CarouselSlider(
//                                 options: CarouselOptions(
//                                   autoPlay: true,
//                                   autoPlayInterval: const Duration(seconds: 5),
//                                   aspectRatio: 16 / 9,
//                                   viewportFraction: 0.9,
//                                   enlargeCenterPage: true,
//                                   scrollDirection: Axis.horizontal,
//                                 ),
//                                 items: [
//                                   ...List.generate(events.length, (index) {
//                                     return EventContainer(
//                                       data: events[index],
//                                     );
//                                   }),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Positioned.fill(
//                           child: Padding(
//                             padding: const EdgeInsets.all(16.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(16.0),
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.black.withOpacity(0.5),
//                                   ],
//                                 ),
//                               ),
//                               child: Align(
//                                 alignment: Alignment.bottomCenter,
//                                 child: Text(
//                                   'See some amazing feed',
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize: 24.0,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
