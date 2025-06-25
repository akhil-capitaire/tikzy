import 'package:flutter/material.dart';
import 'package:tikzy/utils/fontsizes.dart';

import '../utils/screen_size.dart';

class FormInput extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final int? maxlength;
  final Widget? suffix;

  const FormInput({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.maxlength,
    this.suffix,
  });

  @override
  State<FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<FormInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText ?? false,
      maxLength: widget.maxlength,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
      decoration: InputDecoration(
        errorStyle: TextStyle(fontSize: 14),
        labelText: widget.hintText,
        counterText: '',
        suffixIcon: widget.suffix,
        hintStyle: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: TextStyle(
          fontSize: baseFontSize,
          fontWeight: FontWeight.w400,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
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
    );
  }
}

class FormDescription extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final void Function(String)? onChanged;

  const FormDescription({
    super.key,
    required this.controller,
    this.validator,
    this.hintText,
    this.keyboardType,
    this.obscureText,
    this.onChanged,
  });

  @override
  State<FormDescription> createState() => FormDescriptionState();
}

class FormDescriptionState extends State<FormDescription> {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;
    final width = isWide ? ScreenSize.width(40) : double.infinity;

    return SizedBox(
      width: width,
      child: TextFormField(
        controller: widget.controller,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText ?? false,
        onChanged: widget.onChanged,
        minLines: 8,
        maxLines: 12,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          labelText: widget.hintText,
          alignLabelWithHint: true,
          errorStyle: const TextStyle(fontSize: 14),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}
