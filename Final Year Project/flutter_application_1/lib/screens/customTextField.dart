import 'package:flutter/material.dart';

class CustomInputForm extends StatelessWidget {
  final TextEditingController? controller;
  final IconData icon;
  final String label;
  final String hint;
  final bool? obscureText;
  final TextInputType? keyboardType;
  final int? maxLines;
  final VoidCallback? onTap;
  final bool? readOnly;
  const CustomInputForm(
      {super.key,
      required this.icon,
      required this.label,
      required this.hint,
      this.obscureText,
      this.keyboardType,
      this.maxLines,
      this.onTap,
      this.readOnly,
      this.controller});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: 370,
      child: TextFormField(
        controller: controller,
        readOnly: readOnly ?? false,
        onTap: onTap,
        style: const TextStyle(
          color: Colors.black,
        ),
        maxLines: maxLines ?? 1,
        obscureText: obscureText ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(255, 250, 250, 249),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(20),
          ),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          // hintText: hint,
          // hintStyle: const TextStyle(
          //   color: Colors.black,
          // ),
          prefixIcon: Icon(
            icon,
            color: Colors.black,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }
}
