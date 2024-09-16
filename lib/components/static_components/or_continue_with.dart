import 'package:flutter/material.dart';

class OrContinueWith extends StatelessWidget {
  final String msg;
  const OrContinueWith({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.grey[700],
          )),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              msg,
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ),
          Expanded(
              child: Divider(
            thickness: 0.5,
            color: Colors.grey[700],
          )),
        ],
      ),
    );
  }
}
