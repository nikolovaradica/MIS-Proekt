import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final VoidCallback? onTap;
  final bool readOnly;
  final ValueChanged<String>? onChanged;

  const CustomTextFormField({
    super.key,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    required this.controller,
    this.onTap,
    this.readOnly = false,
    this.onChanged,
  });  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onTap: onTap,
      readOnly: readOnly,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: Color.fromARGB(255, 207, 207, 207)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10), 
          borderSide: const BorderSide(color: Color(0xFF5D9EEA))
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: suffixIcon,
      ),
    );
  }
}