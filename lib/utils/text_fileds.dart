import 'package:flutter/material.dart';

const OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(width: 5, color: Colors.tealAccent));

Widget customTextField(String title, TextEditingController controller,
    {TextInputType? inputType}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: TextFormField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      keyboardType: inputType,
      obscureText: title == "Password",
      decoration: InputDecoration(
          hintText: title,
          hintStyle: const TextStyle(color: Colors.white70),
          labelText: title,
          labelStyle: const TextStyle(color: Colors.white),
          enabledBorder: border,
          focusedBorder: border),
    ),
  );
}