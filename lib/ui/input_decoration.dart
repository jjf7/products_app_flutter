import 'package:flutter/material.dart';

class AuthInputDecoration {
  static InputDecoration authInputDecoration(
      {required String hintText,
      required String labelText,
      IconData? prefixIcon}) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.deepPurple),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(color: Colors.deepPurple),
      prefixIcon: prefixIcon == null
          ? null
          : Icon(prefixIcon, color: Colors.deepPurple),
    );
  }
}
