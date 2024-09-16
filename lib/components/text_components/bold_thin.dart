import 'package:flutter/material.dart';

class BoldThin extends StatelessWidget {
  final String primaryText;
  final String secondaryText;
  const BoldThin({
    super.key,
    required this.primaryText,
    required this.secondaryText,
  });

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: primaryText, // Make this part bold
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          TextSpan(
            text: secondaryText, // Keep this part normal
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
