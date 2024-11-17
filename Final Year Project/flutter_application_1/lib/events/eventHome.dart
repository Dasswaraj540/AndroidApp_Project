// ignore: file_names

// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:data_filters/data_filters.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_application_1/events/createEvent.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/events/eventContainer.dart';
import 'package:flutter_application_1/events/eventDetails.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/safety.dart';
import 'package:flutter_application_1/screens/sidebar.dart';

class EventHome extends StatefulWidget {
  const EventHome({super.key});

  @override
  State<EventHome> createState() => _EventHomeState();
}

// Future bottomSheet(BuildContext context) {
//   return showModalBottomSheet(
//       context: context,
//       showDragHandle: true,
//       builder: (context) => Container(
//             height: 200,

//           ))
// }

List<List> getFilterList(List<dynamic> events) {
  List<List> res = [];
  for (int i = 0; i < events.length; i++) {
    res.add([events[i]['name'], events[i]['branch'], events[i]['year']]);
  }
  return res;
}

class _EventHomeState extends State<EventHome> {
  List events = [];
  List<List> filterList = [];
  List<String> titles = ['Name', 'Branch', 'Year'];
  List<int>? filterIndex;
  bool isLoading = true;
  String changeText = 'Upcoming Events';

  @override
  void initState() {
    refresh();
  }

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
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Events",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    isLoading
                        ? const SizedBox()
                        : CarouselSlider(
                            options: CarouselOptions(
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 5),
                              aspectRatio: 16 / 9,
                              viewportFraction: 0.99,
                              enlargeCenterPage: true,
                              scrollDirection: Axis.horizontal,
                            ),
                            items: [
                              ...List.generate(events.length, (index) {
                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetails(
                                                      data: events[index])))
                                      .then((value) => refresh()),
                                  child: EventContainer(
                                    data: events[index],
                                  ),
                                );
                              }),
                            ],
                          ),
                    // const SizedBox(height: 16),
                    // Text(
                    //   "Popular Events ",
                    //   style: TextStyle(
                    //     color: Colors.white,
                    //     fontSize: 24,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    Row(
                      children: [
                        SizedBox(width: 20),
                        Text(
                          '${changeText}',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w400),
                        ),
                        Spacer(),
                        IconButton(
                            onPressed: () {
                              // bottomSheet(context);
                              showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) => Container(
                                  height: 95,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Filters',
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      DataFilters(
                                        data: filterList,

                                        /// pass your filter title here
                                        filterTitle: titles,

                                        /// enable animation
                                        showAnimation: true,

                                        /// get list of index of selected filter
                                        recent_selected_data_index:
                                            (List<int>? index) {
                                          setState(() {
                                            filterIndex = index;
                                            if (filterIndex != null) {
                                              changeText = 'Filtered Results';
                                            } else {
                                              changeText = 'Upcoming Events';
                                            }
                                          });
                                        },

                                        /// styling
                                        style: FilterStyle(
                                          buttonColor: Colors.black,
                                          buttonColorText: Colors.white,
                                          filterBorderColor: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.filter_list_outlined,
                              color: Colors.black,
                              size: 30,
                            )),
                        SizedBox(
                          width: 8,
                        )
                      ],
                    )
                  ],
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      (context, index) => (filterIndex == null ||
                              filterIndex!.contains(index))
                          ? GestureDetector(
                              onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventDetails(
                                              data: events[index])))
                                  .then((value) => refresh()),
                              child: EventContainer(data: events[index]))
                          : SizedBox(),

                      // EventContainer(data: events[index]),
                      // ListTile(
                      //       onTap: () => Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => EventDetails(
                      //                   data: events[index]
                      //                   ))),
                      //       leading: Text(
                      //         "${index + 1}",
                      //         style: TextStyle(color: Colors.black, fontSize: 20),
                      //       ),
                      //       title: Text(
                      //         events[index]["name"],
                      //         style: TextStyle(color: Colors.black, fontSize: 20),
                      //       ),
                      //       subtitle: Text(
                      //         events[index]["location"],
                      //         style: TextStyle(
                      //           color: Colors.black,
                      //         ),
                      //       ),
                      //     ),
                      childCount: events.length))
            ],
          ),
          Positioned(
            right: 20,
            bottom: 100,
            child: FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CreateEvent()));
                refresh();
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
