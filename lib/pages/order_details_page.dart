import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/buttons/finished_order_button.dart';
import '/buttons/edit_order_button.dart';
import '/buttons/cancel_order_button.dart';
import '../database/database_creation.dart';
import '/pages/new_order_page.dart';

class OrderDetailsPage extends StatefulWidget {
  final String displayOrderId;
  final String customerName;
  final String phone;
  final String address;
  final DateTime deliveryDate;
  final List<Map<String, dynamic>> products;
  final bool isCompleted;

  const OrderDetailsPage({
    super.key,
    required this.displayOrderId,
    required this.customerName,
    required this.phone,
    required this.address,
    required this.deliveryDate,
    required this.products,
    this.isCompleted = false,
  });

  @override
  State<OrderDetailsPage> createState() => OrderDetailsPageState();
}

class OrderDetailsPageState extends State<OrderDetailsPage> {
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.isCompleted;
  }

  Future<void> _editOrder() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewOrderPage(
          initialProducts: [],
          existingOrderId: widget.displayOrderId,
          customerName: widget.customerName,
          phone: widget.phone,
          address: widget.address,
          existingDeliveryDate: widget.deliveryDate,
          existingProducts: widget.products,
          isEditing: true,
        ),
      ),
    );

    if (result == true && mounted) {
      Navigator.pop(context, true); // Return to previous screen with update flag
    }
  }

  Future<void> _cancelOrder() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Επιβεβαίωση Ακύρωσης'),
          content: const Text('Είστε σίγουροι ότι θέλετε να ακυρώσετε την παραγγελία;'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Όχι'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Ναι'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        await DatabaseHelper.instance.deleteOrder(widget.displayOrderId);

        if (!mounted) return;

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Η παραγγελία ακυρώθηκε επιτυχώς!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Color(0xFFF2CD00),
          ),
        );

        // Return to previous screen
        Navigator.pop(context, true);
      } catch (e) {
        if (!mounted) return;

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Σφάλμα κατά την ακύρωση της παραγγελίας!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _markOrderAsFinished() async {
    await DatabaseHelper.instance.updateOrderCompletionStatus(
        widget.displayOrderId,
        !_isCompleted
    );

    if (!mounted) return;

    setState(() {
      _isCompleted = !_isCompleted;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isCompleted ? 'Η παραγγελία ολοκληρώθηκε!' : 'Η παραγγελία είναι σε αναμονή!',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFF2CD00),
      ),
    );

    Navigator.pop(context, true);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('dd/MM/yyyy').format(widget.deliveryDate);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Λεπτομέρειες Παραγγελίας'),
        backgroundColor: const Color(0xFFF2CD00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${widget.displayOrderId}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildDetailRow('Όνομα', widget.customerName),
            const SizedBox(height: 8),
            _buildDetailRow('Τηλέφωνο', widget.phone),
            const SizedBox(height: 8),
            _buildDetailRow('Διεύθυνση', widget.address),
            const SizedBox(height: 8),
            _buildDetailRow('Ημερομηνία Παράδοσης', formattedDate),
            const SizedBox(height: 16),
            const Text(
              'Προϊόντα:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.products.map((product) => Card(
              elevation: 2,
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(
                  product['name'] ?? 'Unknown product',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  'Ποσ.: ${product['quantity']?.toStringAsFixed(2) ?? '0.00'}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            )),
            const SizedBox(height: 20),
            Center(
              child: Wrap(
                spacing: 16, // horizontal space between buttons
                runSpacing: 16, // vertical space between lines
                alignment: WrapAlignment.center,
                children: [
                  FinishedOrderButton(
                    onPressed: _markOrderAsFinished,
                    isCompleted: _isCompleted,
                  ),
                  EditOrderButton(
                    onPressed: _editOrder,
                  ),
                  CancelOrderButton(
                    onPressed: _cancelOrder,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}