import 'package:flutter/material.dart';
import 'package:tikzy/utils/fontsizes.dart';

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
    super.key,
    required this.options,
    required this.value,
    required this.onChanged,
    this.fontSize = 14,
    this.height = 50,
    this.width = 100,
    this.fillColor = const Color(0xFFE0E0E0),
    this.icon = Icons.keyboard_arrow_down,
  });

  @override
  Widget build(BuildContext context) {
    final bool isValidValue =
        value != null && value!.isNotEmpty && options.contains(value);
    final String? selectedValue = isValidValue ? value : null;

    return SizedBox(
      height: height,
      width: width,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        hint: Text(
          'select',
          style: TextStyle(fontSize: fontSize, color: Colors.grey),
        ),
        icon: Icon(icon),
        style: TextStyle(fontSize: fontSize, color: Colors.black),
        dropdownColor: Colors.white,
        decoration: InputDecoration(
          errorStyle: TextStyle(fontSize: 14),
          counterText: '',
          hintStyle: TextStyle(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            fontSize: baseFontSize,
            fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.all(commonPaddingSize),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(commonRadiusSize),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(commonRadiusSize),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(commonRadiusSize),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
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
