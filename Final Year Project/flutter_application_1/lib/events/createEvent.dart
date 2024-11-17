// ignore_for_file: prefer_const_constructors, unnecessary_const, sort_child_properties_last

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/customTextField.dart';
import 'package:flutter_application_1/events/database.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  FilePickerResult? filePickerResult;
  DateTime sendDateTime = DateTime(3000);
  String imgURL = '';

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController dateTimeController = TextEditingController();
  final TextEditingController guestController = TextEditingController();
  // final TextEditingController yearController = TextEditingController();
  // final TextEditingController branchController = TextEditingController();

  String dropdownvalue1 = 'All years';
  String dropdownvalue2 = 'All branch';

  // List of items in our dropdown menu
  var items1 = [
    'All years',
    '1st year',
    '2nd year',
    '3rd year',
    '4th year',
  ];
  var items2 = ['All branch', 'CSE', 'CSIT', 'ECE', 'EEE', 'EE', 'Mechanical'];

  // to pickup date and time from user

  Future<void> selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
        context: context, firstDate: DateTime(2024), lastDate: DateTime(2100));

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
          context: context, initialTime: const TimeOfDay(hour: 00, minute: 00));

      if (pickedTime != null) {
        final DateTime selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute);
        sendDateTime = pickedDateTime;
        setState(() {
          dateTimeController.text = selectedDateTime.toString();
        });
      }
    }
  }

  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    setState(() {
      filePickerResult = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Event"),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  _openFilePicker();
                  // print(1);
                  // print(filePickerResult!.files.first.path);
                },
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: filePickerResult != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image(
                            image: FileImage(
                                File(filePickerResult!.files.first.path!)),
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo_outlined,
                              size: 40,
                            ),
                            Text("Add Event image")
                          ],
                        ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              CustomInputForm(
                  controller: nameController,
                  icon: Icons.event_outlined,
                  label: "Event Name",
                  hint: "Name of event"),
              const SizedBox(
                height: 10,
              ),
              CustomInputForm(
                controller: descController,
                icon: Icons.description_outlined,
                label: "Description",
                hint: "About the event",
                maxLines: 4,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomInputForm(
                  controller: locationController,
                  icon: Icons.location_on_outlined,
                  label: "Location",
                  hint: "Venue of the event"),
              const SizedBox(
                height: 10,
              ),
              CustomInputForm(
                controller: dateTimeController,
                icon: Icons.calendar_today_outlined,
                label: "Date",
                hint: "Date and time of event",
                onTap: () => selectDateTime(context),
                readOnly: true,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomInputForm(
                  controller: guestController,
                  icon: Icons.people_outlined,
                  label: "Chief Guests",
                  hint: "Chief guest if any"),
              const SizedBox(
                height: 10,
              ),
              const Divider(

                  // color: Colors.transparent,
                  ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                value: dropdownvalue1,
                items: items1
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    dropdownvalue1 = val as String;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_outlined),
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Year",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.numbers_outlined),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              const SizedBox(
                height: 10,
              ),
              DropdownButtonFormField(
                value: dropdownvalue2,
                items: items2
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    dropdownvalue2 = val as String;
                  });
                },
                icon: const Icon(Icons.arrow_drop_down_outlined),
                dropdownColor: Colors.white,
                decoration: const InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    labelText: "Branch",
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    prefixIcon: Icon(Icons.grading_rounded),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 370,
                height: 60,
                child: ElevatedButton(
                    onPressed: () async {
                      if (filePickerResult == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please upload an Image')));
                        return;
                      }
                      if (nameController.text == '' ||
                          descController.text == '' ||
                          locationController.text == '' ||
                          sendDateTime == DateTime(3000)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Name,description,location,date,time are mandatory fields')));
                        return;
                      }

                      await createEvent(
                              nameController.text,
                              descController.text,
                              locationController.text,
                              sendDateTime,
                              guestController.text,
                              dropdownvalue2,
                              dropdownvalue1,
                              filePickerResult)
                          .then((value) => ScaffoldMessenger.of(context)
                              .showSnackBar(
                                  SnackBar(content: Text('Event Created'))));
                      Navigator.pop(context);

                      // String uniqueFileName =
                      //     DateTime.now().microsecondsSinceEpoch.toString();
                      // Reference refRoot = FirebaseStorage.instance.ref();
                      // Reference refDirImages = refRoot.child('images');
                      // Reference refImageUpload =
                      //     refDirImages.child(uniqueFileName);
                      // try {
                      //   await refImageUpload
                      //       .putFile(File(filePickerResult!.files.first.path!));

                      //   imgURL = await refImageUpload.getDownloadURL();
                      // } catch (e) {}

                      // CollectionReference collRef =
                      //     FirebaseFirestore.instance.collection('events');
                      // collRef.add({
                      //   'name': nameController.text,
                      //   'description': descController.text,
                      //   'location': locationController.text,
                      //   'dateTime': Timestamp.fromDate(sendDateTime),
                      //   'guest': guestController.text,
                      //   'branch': dropdownvalue2,
                      //   'year': dropdownvalue1,
                      //   'image': imgURL
                      // });
                    },
                    child: const Text(
                      "Submit",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Colors.transparent;
                          }
                          return Colors.black;
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))))),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 232, 232, 232),
    );
  }
}
