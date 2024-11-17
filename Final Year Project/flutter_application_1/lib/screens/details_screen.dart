import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_application_1/reusable_widgets/reusable_widgets.dart';
import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/screens/Home_Screen_2.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
// import 'package:flutter_application_1/reusable_widgets/reusable_widgets.dart';
// import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class DetailsScreen extends StatefulWidget {
  DetailsScreen({Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  FilePickerResult? filePickerResult;
  String imgURL = '';

  String barcodeResult = 'Scan your ID card barcode';

  TextEditingController nameTextController = TextEditingController();
  TextEditingController ageTextController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> scanBarcode() async {
    String res = '';
    try {
      res = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.DEFAULT);
    } catch (e) {}
    if (!mounted) return;

    setState(() {
      barcodeResult = res;
    });
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Fill in details",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Divider(
              color: Colors.transparent,
            ),
            SizedBox(
                width: 350,
                child: reusableTextField(
                    "Name", Icons.person, false, nameTextController)),
            SizedBox(
              height: 20,
            ),
            SizedBox(
                width: 350,
                child: reusableTextField(
                    "Age", Icons.calendar_month, false, ageTextController)),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 350,
              child: IntlPhoneField(
                controller: phoneController,
                decoration: InputDecoration(
                    //prefixIcon: Icon(Icons.phone),
                    filled: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    fillColor: Colors.white,
                    labelText: 'Phone Number',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(
                            width: 0, style: BorderStyle.none))),
                initialCountryCode: 'IN',
                onChanged: (phone) {
                  print(phone.completeNumber);
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Stack(
                  children: [
                    // width: double.infinity,
                    // height: 100,
                    GestureDetector(
                      onTap: () {
                        scanBarcode();
                      },
                      child: InputDecorator(
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: 'Registration Number',
                            floatingLabelStyle:
                                TextStyle(fontWeight: FontWeight.w500),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(20)),
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.numbers),
                              SizedBox(
                                width: 10,
                              ),
                              Text(barcodeResult)
                            ],
                          )),
                    ),
                  ],
                )),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              width: 350,
              height: 60,
              child: ElevatedButton(
                  onPressed: () {
                    _openFilePicker();
                  },
                  child: Text(
                    "Choose Profile Picture",
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))))),
            ),
            SizedBox(
              height: 50,
            ),
            // SizedBox(
            //   width: 350,
            //   height: 60,
            //   child: ElevatedButton(
            //       onPressed: () {
            //         scanBarcode();
            //       },
            //       child: Text(
            //         "Scan ID Card Barcode",
            //         style: const TextStyle(
            //             color: Colors.white,
            //             fontWeight: FontWeight.bold,
            //             fontSize: 16),
            //       ),
            //       style: ButtonStyle(
            //           backgroundColor:
            //               MaterialStateProperty.resolveWith((states) {
            //             if (states.contains(MaterialState.pressed)) {
            //               return Colors.transparent;
            //             }
            //             return Colors.black;
            //           }),
            //           shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            //               RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(20))))),
            // ),

            SizedBox(
              width: 350,
              height: 60,
              child: ElevatedButton(
                  onPressed: () async {
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) => ProfileScreen())); changed
                    if (nameTextController.text == '' ||
                        ageTextController.text == '' ||
                        phoneController.text == '' ||
                        barcodeResult == 'Scan your ID card barcode') {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Name,Age,Phone Number,ID Card Scan are mandatory')));
                      return;
                    }

                    if (!isNumeric(ageTextController.text)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Age should be a number')));
                      return;
                    }

                    if (filePickerResult == null) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please choose profile picture')));
                      return;
                    }

                    showDialog(
                      context: context,
                      builder: (context) => Center(
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      ),
                    );

                    await createProfile(
                            nameTextController.text,
                            ageTextController.text,
                            phoneController.text,
                            barcodeResult,
                            filePickerResult)
                        .then((value) => ScaffoldMessenger.of(context)
                            .showSnackBar(
                                SnackBar(content: Text('Profile Created'))));
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HomeScreen2()));
                  },
                  child: Text(
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))))),
            ),
          ],
        ),
      ),
    );
  }
}
