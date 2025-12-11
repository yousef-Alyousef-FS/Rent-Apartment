
import 'package:flutter/material.dart';
class CTextField extends StatelessWidget {
  final TextEditingController? controller;
   final String hintText;
   final String? Function(String?)? validator;
   final bool isPassword;
   final int maxLength;

   const CTextField({
    super.key,
     this.controller,
     required this.hintText,
     this.validator,
     this.isPassword = false,
     this.maxLength = 10,
   });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        validator: validator,
        obscureText: isPassword,
        maxLength: maxLength,
        decoration: InputDecoration(
          fillColor: Colors.grey[450],
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.white24),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black, width: 3),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[700]),
        )
    );
  }
}
