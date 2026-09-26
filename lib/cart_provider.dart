import 'package:flutter/material.dart';
import 'models.dart';
import 'db_helper.dart';

class CartProvider extends ChangeNotifier {
  List<Product> products = [];
  List<CartItem> cartItems = [];
  final DBHelper _dbHelper = DBHelper();

  CartProvider() {
    loadData();
  }

  Future<void> loadData() async {
    products = await _dbHelper.getProducts();
    cartItems = await _dbHelper.getCartItems();
    notifyListeners();
  }

  int get totalCartCount => cartItems.fold(0, (s, i) => s + i.quantity);
  double get subtotal =>
      cartItems.fold(0.0, (s, i) => s + (i.product.price * i.quantity));
  double get totalPembayaran => cartItems.isNotEmpty ? subtotal + 30000 : 0;

  Future<void> addProduct(Product p) async {
    await _dbHelper.insertProduct(p);
    await loadData();
  }

  Future<void> addToCart(Product p) async {
    int i = cartItems.indexWhere((x) => x.product.id == p.id);
    if (i != -1) {
      int newQty = cartItems[i].quantity + 1;
      await _dbHelper.updateCartQuantity(p.id, newQty);
    } else {
      await _dbHelper.insertCartItem(CartItem(product: p, quantity: 1));
    }
    await loadData();
  }

  Future<void> updateQuantity(int index, int change) async {
    String id = cartItems[index].product.id;
    int newQty = cartItems[index].quantity + change;
    await _dbHelper.updateCartQuantity(id, newQty);
    await loadData();
  }

  Future<void> removeItem(int index) async {
    String id = cartItems[index].product.id;
    await _dbHelper.deleteCartItem(id);
    await loadData();
  }
}
