import 'package:flutter/material.dart';

void pushReplacement(BuildContext context, Widget designation) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => designation),
    );
  }