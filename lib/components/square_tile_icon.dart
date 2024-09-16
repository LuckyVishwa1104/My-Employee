import 'package:application/components/button_components/custom_icon_button.dart';
import 'package:flutter/material.dart';

class SquareTileIcon extends StatelessWidget {
  final IconData icon;
  final String labelText; // Add labelText for the text below the tile
  final VoidCallback onPressed;
  final Color clr;
  final Color bgColor;

  const SquareTileIcon(
      {super.key,
      required this.icon,
      required this.onPressed,
      required this.labelText,
      required this.clr,
      required this.bgColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: bgColor,
          ),
          child: CustomIconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            iconSize: 45,
            clr: clr,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          labelText,
          style: const TextStyle(color: Colors.blue),
        ),
      ],
    );
  }
}
