import 'package:flutter/material.dart';

class DrawerText extends StatefulWidget {
  final String hintText;
  final List<String> options;
  final TextEditingController controller;

  const DrawerText({super.key,  required this.hintText,
    required this.options,
    required this.controller,});

  @override
  State<DrawerText> createState() => _DrawerTextState();
}

class _DrawerTextState extends State<DrawerText> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
      ),
      child: GestureDetector(
        onTap: () {
          _showOptions(context);
        },
        child: AbsorbPointer(
          child: TextField(
            controller: widget.controller,
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
              hintText: widget.hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 10,
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.options.map((option) {
            return ListTile(
              title: Text(option),
              onTap: () {
                widget.controller.text = option; // Set selected option to the controller
                Navigator.pop(context); // Close the modal
              },
            );
          }).toList(),
        );
      },
    );
  }
}     
