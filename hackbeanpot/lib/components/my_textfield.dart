import 'package:flutter/cupertino.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: CupertinoTextField(
        controller: controller,
        obscureText: obscureText,
        placeholder: hintText,
        decoration: BoxDecoration(
          color: CupertinoColors.systemGrey6,
          border: Border.all(color: CupertinoColors.systemGrey4),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
