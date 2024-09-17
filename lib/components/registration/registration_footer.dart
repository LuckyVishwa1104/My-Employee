import 'package:application/components/button_components/custom_text_button.dart';
import 'package:application/components/navigation/push_named.dart';
import 'package:application/components/navigation/push_replacement_named.dart';
import 'package:flutter/material.dart';

class RegistrationFooter extends StatelessWidget {
  final String greetMessage;
  final String buttonText;
  final String pageDesignation;
  const RegistrationFooter(
      {super.key,
      required this.greetMessage,
      required this.buttonText,
      required this.pageDesignation});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          greetMessage,
          style: TextStyle(color: Colors.grey[700]),
        ),
        const SizedBox(
          width: 5.0,
        ),
        CustomTextButton(
          buttonText: buttonText,
          onPressed: () => pushReplacementNamed(
            context,
            pageDesignation,
          ),
          fontSize: 14,
        ),
      ],
    );
  }
}
