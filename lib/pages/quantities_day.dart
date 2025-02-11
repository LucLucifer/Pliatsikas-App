import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/database/database_creation.dart';
import '/models/products.dart';
import 'dart:convert';

class QuantitiesPerDay extends StatefulWidget {
  const QuantitiesPerDay({super.key});

  @override
  State<QuantitiesPerDay> createState() => QuantitiesPerDayState();
}

class QuantitiesPerDayState extends State<QuantitiesPerDay> {
  DateTime? _selectedDate;
  Map<String, double> _productQuantities = {};
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _fetchProductQuantities();
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime(2100),
      locale: const Locale('el', 'GR'),
    );

    if (pickedDate != null && mounted) {
      setState(() {
        _selectedDate = pickedDate;
      });
      await _fetchProductQuantities();
    }
  }

  Future<void> _fetchProductQuantities() async {
    if (_selectedDate == null) return;
    setState(() {
      _isLoading = true;
      _productQuantities = {};
    });

    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    // Add excludeCompleted parameter
    final orders = await DatabaseHelper.instance.fetchOrdersByDate(formattedDate, excludeCompleted: true);

    final Map<String, double> quantities = {};

    for (final order in orders) {
      final products = json.decode(order['products']) as List;
      for (final product in products) {
        final name = product['name'] as String;
        final quantity = product['quantity'] as double;
        quantities[name] = (quantities[name] ?? 0.0) + quantity;
      }
    }

    setState(() {
      _productQuantities = quantities;
      _isLoading = false;
    });
  }

  String _getUnit(String productName) {
    final product = productsList.firstWhere(
          (p) => p.name == productName,
      orElse: () => Product(id: '0', name: '', price: 0, unit: ''),
    );
    return product.unit;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Εκκρεμείς Ποσότητες Προϊόντων Ημέρας'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CD00),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListTile(
              title: Text(
                _selectedDate == null
                    ? 'Επιλέξτε Ημερομηνία'
                    : 'Ημερομηνία: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _productQuantities.isEmpty
                ? const Center(
              child: Text(
                'Δεν υπάρχουν άλλες ποσότητες για αυτή την ημέρα',
                style: TextStyle(fontSize: 16),
              ),
            )
                : ListView.builder(
              itemCount: _productQuantities.length,
              itemBuilder: (context, index) {
                final productName = _productQuantities.keys.elementAt(index);
                final quantity = _productQuantities[productName]!;
                final unit = _getUnit(productName);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: ListTile(
                    title: Text(
                      productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: Text(
                      '${quantity.toStringAsFixed(2)} $unit',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
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