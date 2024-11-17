// import 'dart:core';

// import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomInputDecor extends StatelessWidget {
  final IconData icon;
  final String label;
  final String data;
  const CustomInputDecor(
      {super.key, required this.icon, required this.label, required this.data});

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          floatingLabelStyle:
              TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              // size: 25,
            ),
            SizedBox(
              width: 25,
            ),
            Text(
              data,
              style: TextStyle(fontSize: 15),
            )
          ],
        ));
  }
}
