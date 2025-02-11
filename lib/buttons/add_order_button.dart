import 'package:flutter/material.dart';
import 'package:pliatsikas_app/pages/new_order_page.dart';

class CustomFloatingButton extends StatelessWidget {
  const CustomFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewOrderPage(initialProducts: [],)),
        );
      },
      tooltip: 'Προσθήκη Νέας Παραγγελίας', // Tooltip for accessibility
      shape: CircleBorder(), //circular shape button
      backgroundColor: Color(0xFFF2CD00),
      child: Icon(
        Icons.add,
        size: 35.0,
      ),
    );
  }
}