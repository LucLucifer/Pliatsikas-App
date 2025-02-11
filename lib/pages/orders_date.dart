import 'package:flutter/material.dart';
import '../database/database_creation.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'order_details_page.dart';
import '/pages/quantities_day.dart';

class OrdersByDatePage extends StatefulWidget {
  const OrdersByDatePage({super.key});

  @override
  State<OrdersByDatePage> createState() => OrdersByDatePageState();
}

class OrdersByDatePageState extends State<OrdersByDatePage> {
  DateTime? _selectedDate;
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    if (_selectedDate == null) return;

    setState(() {
      _isLoading = true;
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    final fetchedOrders = await DatabaseHelper.instance.fetchOrdersByDate(formattedDate);

    if (mounted) {
      setState(() {
        _orders = fetchedOrders;
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
      });
      await _fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Παραγγελίες Ημέρας'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CD00),
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const QuantitiesPerDay(),
                ),
              );
            },
            tooltip: 'Ποσότητες Ημέρας',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Επιλέξτε Ημερομηνία'
                    : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _orders.isEmpty
                ? const Center(
              child: Text(
                'Δεν υπάρχουν παραγγελίες για αυτήν την ημερομηνία.',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return InkWell(
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(
                          displayOrderId: order['displayOrderId'] ?? '#00000',
                          customerName: order['customerName'],
                          phone: order['phone'],
                          address: order['address'] ?? '',  // Added address
                          deliveryDate: DateTime.parse(order['deliveryDate']),
                          products: List<Map<String, dynamic>>.from(
                            json.decode(order['products']),
                          ),
                          isCompleted: order['isCompleted'] == 1,
                        ),
                      ),
                    );

                    if (result == true && mounted) {
                      _fetchOrders();
                    }
                  },
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      title: Text('Order ID: ${order['displayOrderId'] ?? '#00000'}'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Όνομα: ${order['customerName']}'),
                          Text('Τηλέφωνο: ${order['phone']}'),
                        ],
                      ),
                      trailing: order['isCompleted'] == 1
                          ? const Icon(Icons.check_circle, color: Colors.green)
                          : null,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}