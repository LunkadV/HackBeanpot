import 'package:flutter/cupertino.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      color: CupertinoColors.black,
      onPressed: onTap,
      child: Text(
        text,
        style: const TextStyle(
          color: CupertinoColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}
