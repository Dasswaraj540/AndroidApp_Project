import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/events/database.dart';
import 'package:flutter_application_1/screens/customTextField.dart';

class helpPage extends StatefulWidget {
  const helpPage({super.key});

  @override
  State<helpPage> createState() => _helpPageState();
}

class _helpPageState extends State<helpPage> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var padding = EdgeInsets.symmetric(horizontal: screenSize.width * 0.05);
    var spacing = SizedBox(height: screenSize.height * 0.02);

    return Scaffold(
      appBar: AppBar(
        title: Text('Help'),
      ),
      body: Padding(
        padding: padding,
        child: SingleChildScrollView(
          child: Column(
            children: [
              spacing,
              Container(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.25,
                child: Image(image: AssetImage('assets/images/logo.png')),
              ),
              spacing,
              CustomInputForm(
                controller: _textEditingController,
                icon: Icons.edit,
                label: 'Write to the developers...',
                maxLines: 4,
                hint: '',
              ),
              spacing,
              SizedBox(
                width: screenSize.width * 0.8,
                height: screenSize.height * 0.06,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_textEditingController.text == '') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Write something to post')));
                    } else {
                      await createReport(_textEditingController.text).then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text('Report Sent Successfully'))));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 0, 0),
                      side: BorderSide.none),
                  child: const Text(
                    "Send",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Contact Us ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: screenSize.width * 0.05,
                    ),
                  ),
                ],
              ),
              spacing,
              _contactInfo('shantiswaruprath@gmail.com', screenSize),
              _contactInfo('kaushik.barik1967@gmail.com', screenSize),
              _contactInfo('pratiksahu2003@gmail.com', screenSize),
              _contactInfo('samaresh0741@gmail.com', screenSize),
              spacing,
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 8),
                  Text(
                    'Toll Free',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: screenSize.width * 0.05,
                    ),
                  ),
                  Spacer(),
                  Text(
                    '899-216-000',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: screenSize.width * 0.05,
                        color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contactInfo(String email, Size screenSize) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(width: 8),
        Text(
          email,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: screenSize.width * 0.045,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
