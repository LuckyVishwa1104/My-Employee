import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final IconData icon;
  final String msg;
  final bool selectedIndex;
  final VoidCallback onPressed;
  const CustomListTile({
    super.key,
    required this.icon,
    required this.msg,
    required this.onPressed,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black,
      ),
      title: Text(msg),
      selected: selectedIndex,
      onTap: onPressed,
    );
  }
}
