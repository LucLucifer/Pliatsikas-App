import 'package:flutter/material.dart';
import '/pages/orders_date.dart';

class OrdersByDateButton extends StatelessWidget {
  const OrdersByDateButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OrdersByDatePage()),
        );
      },
      style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: const BorderSide(
            color: Color(0xFFF2CD00),
            width: 2.5,
          ),
        ),
      ),
      child: Text(
        'Παραγγελίες Ημέρας',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}