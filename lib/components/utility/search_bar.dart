import 'package:flutter/material.dart';

class SearchEmployee extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchEmployee({super.key, required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        hintText: "Search employee...",
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Colors.black,
            width: 1,
          ),
        ),
      ),
    );
  }
}
