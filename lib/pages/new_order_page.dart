import 'dart:convert';
import 'package:flutter/material.dart';
import '/models/products.dart';
import '/database/database_creation.dart';
import 'package:intl/intl.dart';
import '/pages/home_page.dart';

class NewOrderPage extends StatefulWidget {
  final List<Product> initialProducts;
  final String? existingOrderId;  // For editing mode
  final String? customerName;
  final String? phone;
  final String? address;
  final DateTime? existingDeliveryDate;
  final List<Map<String, dynamic>>? existingProducts;
  final bool isEditing;  // To determine if we're editing or creating

  const NewOrderPage({
    super.key,
    required this.initialProducts,
    this.existingOrderId,
    this.customerName,
    this.phone,
    this.address,
    this.existingDeliveryDate,
    this.existingProducts,
    this.isEditing = false,
  });

  @override
  NewOrderPageState createState() => NewOrderPageState();
}

class NewOrderPageState extends State<NewOrderPage> {
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? deliveryDate;
  late List<Product> _productsList;
  String? displayOrderId;

  @override
  void initState() {
    super.initState();

    // Set initial date
    deliveryDate = widget.existingDeliveryDate ?? DateTime.now();

    // Initialize controllers with existing data if editing
    if (widget.isEditing) {
      customerNameController.text = widget.customerName ?? '';
      phoneController.text = widget.phone ?? '';
      addressController.text = widget.address ?? '';
      displayOrderId = widget.existingOrderId;
    } else {
      _initializeOrderId();
    }

    // Initialize products list
    _productsList = productsList.map((product) => Product(
      id: product.id,
      name: product.name,
      price: product.price,
      unit: product.unit,
      quantity: 0.0,
    )).toList();

    // If editing, set quantities from existing products
    if (widget.isEditing && widget.existingProducts != null) {
      for (var existingProduct in widget.existingProducts!) {
        final productIndex = _productsList.indexWhere(
                (p) => p.name == existingProduct['name']
        );
        if (productIndex != -1) {
          _productsList[productIndex].quantity =
              double.parse(existingProduct['quantity'].toString());
        }
      }
    }
  }

  Future<void> _initializeOrderId() async {
    displayOrderId = await DatabaseHelper.instance.getNextDisplayOrderId();
    if (mounted) {
      setState(() {});
    }
  }

  String _encodeProducts() {
    return json.encode(_productsList
        .where((product) => product.quantity > 0)
        .map((product) => {
      'name': product.name,
      'quantity': product.quantity,
    })
        .toList());
  }

  void _showSnackBar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.white,
          ),
        ),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> submitOrder() async {
    if (!mounted) return;

    // Validate inputs
    if (customerNameController.text.isEmpty) {
      _showSnackBar('Παρακαλώ εισάγετε όνομα πελάτη!', const Color(0xFFE61F1F));
      return;
    }
    String phone = phoneController.text.replaceAll(' ', '');
    if (phone.isEmpty) {
      _showSnackBar('Παρακαλώ εισάγετε τηλέφωνο!', const Color(0xFFE61F1F));
      return;
    }
    if (!RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
      _showSnackBar('Το τηλέφωνο πρέπει να είναι 10 ψηφία!', const Color(0xFFE61F1F));
      return;
    }
    if (deliveryDate == null) {
      _showSnackBar('Επιλέξτε ημερομηνία!', const Color(0xFFE61F1F));
      return;
    }
    if (_productsList.every((product) => product.quantity == 0)) {
      _showSnackBar(
          'Παρακαλώ επιλέξτε τουλάχιστον ένα προϊόν!',
          const Color(0xFFE61F1F)
      );
      return;
    }

    final order = {
      'customerName': customerNameController.text,
      'phone': phoneController.text,
      'address': addressController.text,
      'deliveryDate': deliveryDate.toString(),
      'products': _encodeProducts(),
      'displayOrderId': displayOrderId,
    };

    try {
      if (widget.isEditing) {
        await DatabaseHelper.instance.updateOrder(order, widget.existingOrderId!);
      } else {
        await DatabaseHelper.instance.insertOrder(order);
      }

      if (!mounted) return;

      _showSuccessAndNavigate(isEditing: widget.isEditing);
    } catch (e) {
      if (!mounted) return;
      _showSnackBar(
        'Σφάλμα κατά την ${widget.isEditing ? 'ενημέρωση' : 'υποβολή'} της παραγγελίας',
        const Color(0xFFE61F1F),
      );
    }
  }

  void _showSuccessAndNavigate({bool isEditing = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEditing
              ? 'Η παραγγελία ενημερώθηκε επιτυχώς!'
              : 'Η παραγγελία υποβλήθηκε επιτυχώς!',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFF2CD00),
        duration: const Duration(seconds: 2),
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Επεξεργασία Παραγγελίας' : 'Νέα Παραγγελία'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF2CD00),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Order ID: ${displayOrderId ?? "Loading..."}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: customerNameController,
              decoration: const InputDecoration(
                labelText: 'Ονοματεπώνυμο Πελάτη',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 16),
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Τηλέφωνο',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 16),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Διεύθυνση',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(fontSize: 16),
              ),
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 16.0),
            ListTile(
              title: const Text('Ημερομηνία Παράδοσης:'),
              subtitle: Text((DateFormat('dd/MM/yyyy').format(deliveryDate!)),  //set default date current date for orders
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Προϊόντα',
              style: Theme.of(context).textTheme.displayMedium,
            ),
            const SizedBox(height: 10.0),
            ..._buildProductsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: submitOrder,
        backgroundColor: const Color(0xFFF2CD00),
        child: const Icon(Icons.check, size: 35.0),
      ),
    );
  }

  List<Widget> _buildProductsList() {
    return _productsList.map((product) {
      // Create a TextEditingController for each product
      TextEditingController controller = TextEditingController();

      // Set initial text if quantity exists
      if (product.quantity > 0) {
        controller.text = product.quantity.toString();
      }

      return ListTile(
        title: Text(product.name),
        subtitle: Text('${product.price.toStringAsFixed(2)}€ / ${product.unit}'),
        trailing: SizedBox(
          width: 100,
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ποσ.',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.text, // Changed to text for easier editing
            onChanged: (value) {
              setState(() {
                if (value.isEmpty) {
                  product.quantity = 0.0;
                } else {
                  // Remove any non-numeric characters except decimal point
                  String cleanValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
                  try {
                    product.quantity = double.parse(cleanValue);
                  } catch (e) {
                    product.quantity = 0.0;
                  }
                }
              });
            },
          ),
        ),
      );
    }).toList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && mounted) {
      setState(() {
        deliveryDate = picked;
      });
    }
  }
}