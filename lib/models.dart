class Product {
  final String id, name, subtitle, imagePath;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.price,
    required this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': subtitle,
      'image_path': imagePath,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      price: (map['price'] as num).toDouble(),
      subtitle: map['description'] ?? '',
      imagePath: map['image_path'] ?? 'assets/laptop.jpg',
    );
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toMap() {
    return {
      'id': product.id,
      'product_id': product.id,
      'name': product.name,
      'price': product.price,
      'image_path': product.imagePath,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      product: Product(
        id: map['product_id'],
        name: map['name'],
        price: (map['price'] as num).toDouble(),
        subtitle: '',
        imagePath: map['image_path'] ?? 'assets/laptop.jpg',
      ),
      quantity: map['quantity'],
    );
  }
}
