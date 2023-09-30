import 'package:flutter/material.dart';

class CommonTextField extends StatelessWidget {
  final Widget child;
  final TextEditingController controller;
  final String? hintText;
  final Function(String)? onChange;
  final bool? isObsecure;

  CommonTextField(
      {super.key,
      this.onChange,
      required this.controller,
      required this.child,
      this.hintText, this.isObsecure});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(
          fontSize: 17, fontWeight: FontWeight.w300, color: Colors.white,fontFamily: "sfPro"),
      onChanged: (value) {
        if (onChange != null) {
          onChange!(value) ?? () {};
        }
      },
      obscureText: isObsecure ?? false,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hintText,
        hintStyle:  TextStyle(
            color: Colors.white.withOpacity(0.55),
            fontSize: 20,
            height: 2,
            fontWeight: FontWeight.w200,letterSpacing: 2),
        prefixIcon: child,
      ),
    );
  }
}
