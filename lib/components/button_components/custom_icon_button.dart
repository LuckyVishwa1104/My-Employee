import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  final Icon icon;
  final double iconSize;
  final VoidCallback onPressed;
  final Color clr;
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    required this.iconSize,
    required this.clr
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      iconSize: iconSize,
      color: clr,
    );
  }
}
