import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomSubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      backgroundColor: const Color(0xFFF2CD00),
      child: const Icon(
        Icons.check,
        size: 35.0,
      ),
    );
  }
}