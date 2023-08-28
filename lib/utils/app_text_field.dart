import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget appTextField(
    {required TextEditingController controller,
    double? width,
    int? maxLength,
    String? labelText,
    String? hintText,
    Icon? prefixIcon}) {
  return SizedBox(
    height: 80,
    width: width,
    child: TextField(
      controller: controller,
      maxLength: maxLength,
      style: const TextStyle(fontSize: 30),
      textAlign: TextAlign.center,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      // Prevent cursor overflow
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        contentPadding: const EdgeInsets.all(10),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
    ),
  );
}
