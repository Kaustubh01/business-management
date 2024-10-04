import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  const CustomInputField({super.key, required this.controller, required this.hint, this.obscureText =false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hint,
        ),
      ),
    );
  }
}