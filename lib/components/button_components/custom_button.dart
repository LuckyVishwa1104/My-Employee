import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  final Color bgColor;
  const CustomButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(
          vertical: 20,
          horizontal: 20,
        ), // Text color
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          // Rounded corners
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
      child: Text(buttonText),
    );
  }
}
