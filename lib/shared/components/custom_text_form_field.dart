import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  TextEditingController controller;
  TextInputType type;
  String label;
  IconData prefix;
  IconData? suffix;
  void Function(String)? onChange;
  void Function(String)? onSubmit;
  void Function()? suffixPress;
  void Function()? onTap;
  String? Function(String?)? validator;
  bool isPassword;
  bool isClickable;

  CustomTextFormField({
    required this.controller,
    required this.type,
    required this.label,
    required this.prefix,
    this.onChange,
    this.onSubmit,
    required this.validator,
    this.suffix,
    this.isPassword = false,
    this.suffixPress,
    this.onTap,
    this.isClickable = true,
  });
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: type,
      obscureText: isPassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: label,
        prefixIcon: Icon(prefix),
        suffixIcon: suffix != null
            ? IconButton(onPressed: suffixPress, icon: Icon(suffix))
            : null,
      ),
      enabled: isClickable,
      onChanged: onChange,
      onFieldSubmitted: onSubmit,
      validator: validator,
      onTap: onTap,
    );
  }
}
