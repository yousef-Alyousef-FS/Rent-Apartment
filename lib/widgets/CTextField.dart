import 'package:flutter/material.dart';

class CTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPassword;
  final int? maxLength;
  final TextInputType? textInputType;
  final String? Function(String?)? validator;
  final int? maxLines; // Added maxLines parameter

  const CTextField({
    super.key,
    required this.hintText,
    this.controller,
    this.isPassword = false,
    this.maxLength,
    this.textInputType,
    this.validator,
    this.maxLines = 1, // Default to a single line
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        maxLength: maxLength,
        keyboardType: textInputType,
        validator: validator,
        maxLines: maxLines, // Pass it to the underlying TextFormField
        decoration: InputDecoration(
          hintText: hintText,
          counterText: "", // Hide the counter
        ),
      ),
    );
  }
}
