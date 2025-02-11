import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
//import '/pages/orders_date.dart';
//import '/theme/theme.dart';

//import buttons
import '/buttons/add_order_button.dart';
import '/buttons/orders_bydate_button.dart';
// import Lottie from constants
import '/constants/constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final String currentDate = DateFormat.yMMMMEEEEd('el').format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Διαχείριση Παραγγελιών',
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: AppConstants.primaryColor, // Move color to constants
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              currentDate,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Καλώς ήρθατε!',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Κοτόπουλα Πλιάτσικας',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Lottie.asset(
                    AppConstants.animationJson,
                    // Consider adding width and height constraints
                    width: 300,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                  OrdersByDateButton(), // Move TextButton to separate widget
                ],
              ),

            ),
          ),
        ],
      ),
      floatingActionButton: const CustomFloatingButton(),
    );
  }
}

