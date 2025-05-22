import 'package:flutter/material.dart';
import 'package:tikzy/utils/fontsizes.dart';

/// A reusable, customizable dropdown widget with modern UI styling.
class CustomDropdown extends StatelessWidget {
  final List<String> options;
  final String? value;
  final void Function(String?) onChanged;
  final double fontSize;
  final double height;
  final double width;
  final Color fillColor;
  final IconData icon;

  const CustomDropdown({
    Key? key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.fontSize = 14,
    this.height = 50,
    this.width = 150,
    this.fillColor = const Color(0xFFE0E0E0),
    this.icon = Icons.keyboard_arrow_down,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DropdownButtonFormField<String>(
        value: value,
        icon: Icon(icon),
        style: TextStyle(fontSize: fontSize, color: Colors.black),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          filled: true,
          fillColor: fillColor.withOpacity(0.1),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(commonRadiusSize),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(commonRadiusSize),
            borderSide: BorderSide(color: fillColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
        items: options.map((s) {
          return DropdownMenuItem(
            value: s,
            child: Text(s, style: TextStyle(fontSize: fontSize)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
