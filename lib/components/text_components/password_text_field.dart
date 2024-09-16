import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String hintText;
  final bool existance;
  final TextEditingController controller;
  const PasswordTextField(
      {super.key,
      required this.hintText,
      required this.existance,
      required this.controller});

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  void obscurity() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: TextField(
        controller: widget.controller,
        obscureText: _obscureText,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.grey.shade500,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 1.2,
            ),
          ),
          fillColor: Colors.grey.shade200,
          filled: true,
          hintText: widget.hintText,
          errorText: widget.existance ? 'Enter valid details' : null,
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18,
            horizontal: 10,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.grey[800],
            ),
            onPressed: () {
              obscurity();
            },
            style: IconButton.styleFrom().copyWith(
              overlayColor: WidgetStateProperty.all(
                Colors.transparent,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
