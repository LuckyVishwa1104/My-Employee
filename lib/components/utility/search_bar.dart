import 'package:flutter/material.dart';

class SearchEmployee extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;

  const SearchEmployee({Key? key, required this.onSearchChanged}) : super(key: key);

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
        enabledBorder: OutlineInputBorder(
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
