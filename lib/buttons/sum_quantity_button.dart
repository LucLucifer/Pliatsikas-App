import 'package:flutter/material.dart';
import '/pages/quantities_day.dart';

class SumQuantityButton extends StatelessWidget {
  const SumQuantityButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const QuantitiesPerDay(),
          ),
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: const Color(0xFFF2CD00),
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(
            color: Colors.black26,
            width: 0.5,
          ),
        ),
      ),
      child: Text(
        'Συνολικές Ποσότητες Προϊόντων Ημέρας',
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          color: Colors.black, // Add text color for better contrast
        ),
      ),
    );
  }
}