import 'package:flutter/material.dart';

class CustomTextFiled extends StatelessWidget {
  TextEditingController controller;
  int maxLength;
  TextInputType keyboardType;
  String helpText;
  CustomTextFiled(
      {super.key,
      required this.controller,
      required this.maxLength,
      required this.keyboardType,
      required this.helpText});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: helpText,
        hintStyle: Theme.of(context).textTheme.bodyMedium,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      ),
    );
  }
}
