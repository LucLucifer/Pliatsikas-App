import 'package:flutter/material.dart';

class FinishedOrderButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool isCompleted;

  const FinishedOrderButton({
    super.key,
    required this.onPressed,
    this.isCompleted = false, // Optional completion status
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: isCompleted ? 'Η παραγγελία έχει ολοκληρωθεί' : 'Ολοκληρώστε την παραγγελία',
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? const Color(0xFFF2CD00) : Colors.lightBlueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          isCompleted ? 'Ολοκληρωμένη' : 'Ολοκλήρωση',
        ),
      ),
    );
  }
}