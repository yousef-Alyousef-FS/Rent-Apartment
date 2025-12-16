import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final String? Function(String?)? validator;
  final bool isPassword;
  final int? maxLength;
  final TextInputType? textInputType;

  const CTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.validator,
    this.isPassword = false,
    this.maxLength,
    this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isPassword,
      maxLength: maxLength,
      keyboardType: textInputType,
      decoration: InputDecoration(
        fillColor: theme.colorScheme.surface,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: theme.dividerColor, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: theme.colorScheme.primary, width: 2.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.5),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        hintText: hintText,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
        counterText: "",
      ),
    );
  }
}
