import 'package:flutter/material.dart';

class FilterChipComponent extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;

  const FilterChipComponent({
    Key? key,
    required this.label,
    required this.selected,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: onSelected,
      selectedColor: Colors.blue.withOpacity(0.3),
      checkmarkColor: Colors.black,
      backgroundColor: Colors.grey[200], 
      side: BorderSide.none,
    );
  }
}
