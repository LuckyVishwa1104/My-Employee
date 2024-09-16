import 'package:flutter/material.dart';

class InputTextField extends StatelessWidget {
  final String hintText;
  final bool existance;
  final TextEditingController controller;

  const InputTextField({
    super.key,
    required this.hintText,
    required this.existance,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade500,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: hintText,
          errorText: existance ? 'Enter valid details' : null,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 10,
          ),
        ),
      ),
    );
  }
}
