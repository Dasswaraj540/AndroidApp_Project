import 'dart:io';
import 'dart:math';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/screens/post2.dart';

TextEditingController _controller = TextEditingController();

class PostCaption extends StatefulWidget {
  const PostCaption({super.key});

  @override
  State<PostCaption> createState() => _PostCaptionState();
}

class _PostCaptionState extends State<PostCaption> {
  bool toggleSwitch = false;
  bool isLoading = false;
  TextEditingController captionController = TextEditingController();
  ValueNotifier<bool> isCaptionEmpty = ValueNotifier(true);
  List profile = [];

  @override
  void initState() {
    super.initState();
    refresh();
    captionController.addListener(() {
      isCaptionEmpty.value = captionController.text.isEmpty;
    });
  }

  void refresh() {
    getProfile().then((value) {
      profile = value;
      setState(() {});
    });
  }

  void _showLoadingIndicator(bool show) {
    setState(() {
      isLoading = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            _controller.clear();
            sleep(const Duration(seconds: 1));
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        title: const Text(
          "New Post",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: isCaptionEmpty,
            builder: (context, isEmpty, child) {
              return TextButton(
                onPressed: isEmpty
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Write a caption')));
                      }
                    : () async {
                        _showLoadingIndicator(true);
                        try {
                          _controller.clear();
                          String img =
                              'https://firebasestorage.googleapis.com/v0/b/signup-info-cc273.appspot.com/o/images%2Fanonymous.jpg?alt=media&token=6a14a823-17f9-4cb0-b637-0184a941c359';
                          toggleSwitch
                              ? await createPost(
                                      'Anonymous',
                                      captionController.text,
                                      img,
                                      selectedImage)
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBar(
                                          content:
                                              Text('Anonymous Post Created'))))
                              : await createPost(
                                      profile[0]['name'],
                                      captionController.text,
                                      profile[0]['image'],
                                      selectedImage)
                                  .then((value) => ScaffoldMessenger.of(context)
                                      .showSnackBar(
                                          SnackBar(content: Text('Post Created'))));
                          int count = 0;
                          Navigator.of(context).popUntil((_) => count++ >= 2);
                        } finally {
                          _showLoadingIndicator(false);
                        }
                      },
                child: const Text(
                  "Post",
                  style: TextStyle(
                      color: Colors.lightBlue,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: Image.file(
                      selectedImage!,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: captionController,
                    minLines: 4,
                    maxLines: null,
                    autofocus: false,
                    autocorrect: true,
                    cursorColor: Theme.of(context).primaryColor,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      labelText: 'Write a Caption',
                      labelStyle: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Anonymous Post:',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            toggleSwitch = !toggleSwitch;
                          });
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: toggleSwitch
                                ? LinearGradient(
                                    colors: [Colors.green, Colors.teal])
                                : LinearGradient(
                                    colors: [Colors.red, Colors.orange]),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              AnimatedAlign(
                                duration: Duration(milliseconds: 300),
                                alignment: toggleSwitch
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                                child: Container(
                                  margin: EdgeInsets.all(4.0),
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    toggleSwitch
                                        ? Icons.person
                                        : Icons.person_off,
                                    color: toggleSwitch
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  toggleSwitch ? 'On' : 'Off',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
