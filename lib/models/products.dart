// Catalog of the products that the company sells.

class Product {
  final String id;
  final String name;
  final double price;
  final String unit;
  double quantity;

  Product ({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    this.quantity = 0.0, // define the quantity of every product as 0 by default
  });

  Product copy(){
    return Product(
      name: name,
      price: price,
      unit: unit,
      id: id,
    );
  }
}

//list of products that the company sells
final List<Product> productsList = [
  Product(id: '1', name: 'Κοτόπουλο μικρό', price: 6.50, unit: 'Τεμάχιο'),
  Product(id: '2', name: 'Κοτόπουλο μεσαίο', price: 6.50, unit: 'Τεμάχιο'),
  Product(id: '3', name: 'Κοτόπουλο μεγάλο', price: 6.50, unit: 'Τεμάχιο'),
  Product(id: '4', name: 'Στήθος κοτόπουλο', price: 3.50, unit: 'Τεμάχιο'),
  Product(id: '5', name: 'Μπούτι κοτόπουλο', price: 2.80, unit: 'Τεμάχιο'),
  Product(id: '6', name: 'Συκωτάκια', price: 4.50, unit: 'Κιλό'),
  Product(id: '7', name: 'Φτερούγες', price: 3.80, unit: 'Κιλό'),
  Product(id: '8', name: 'Σουβλάκι κοτόπουλο', price: 1.50, unit: 'Τεμάχιο'),
  Product(id: '9', name: 'Σουβλάκι μαριναρισμένο', price: 2.00, unit: 'Τεμάχιο'),
  Product(id: '10', name: 'Σνίτσελ', price: 2.50, unit: 'Τεμάχιο'),
  Product(id: '11', name: 'Κοτομπουκιές', price: 7.50, unit: 'Κιλό'),
  Product(id: '12', name: 'Γύρος κοτόπουλο', price: 8.50, unit: 'Κιλό'),
  Product(id: '13', name: 'Φιλέτο Στήθος', price: 1.50 , unit: 'Τεμάχιο'),
  Product(id: '14', name: 'Φιλέτο Μπούτι', price: 1.50 , unit: 'Τεμάχιο'),
  Product(id: '15', name: 'Εντόσθια', price: 1.00 , unit: 'Κιλό'),
  Product(id: '16', name: 'Παριζάκι Κοτόπουλο', price: 2.00 , unit: 'Τεμάχιο'),
  Product(id: '17', name: 'Πλατάρια', price: 1.50 , unit: 'Κιλό'),
  Product(id: '18', name: 'Ρέντζες - Στομάχια', price: 1.50 , unit: 'Κιλό'),
  Product(id: '19', name: 'Λουκάνικο', price: 1.50 , unit: 'Τεμάχιο'),
  Product(id: '20', name: 'Μπιφτέκι', price: 1.50 , unit: 'Τεμάχιο'),
  Product(id: '21', name: 'Ρολό κοτόπουλο μικρό', price: 1.80 , unit: 'Τεμάχιο'),
  Product(id: '22', name: 'Ρολό κοτόπουλο μεγάλο', price: 2.50 , unit: 'Τεμάχιο'),
  Product(id: '23', name: 'Κιμάς στήθος', price: 1.50 , unit: 'Κιλό'),
  Product(id: '24', name: 'Κιμάς μπούτι', price: 1.50 , unit: 'Κιλό'),
  Product(id: '25', name: 'Κιμάς ανάμεικτος', price: 1.50 , unit: 'Κιλό'),
  Product(id: '26', name: 'Αυγά μεγάλο', price: 0.60 , unit: 'Τεμάχιο'),
  Product(id: '27', name: 'Αυγά μικρό', price: 0.40 , unit: 'Τεμάχιο'),
  Product(id: '28', name: 'Αυγά εξάδα', price: 2.40 , unit: 'Τεμάχιο'),
];