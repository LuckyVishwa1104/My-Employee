import 'package:flutter/material.dart';

void push(BuildContext context, Widget destination) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => destination,
    ),
  );
}
