import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';


import 'package:collection/collection.dart';

import '../services/firestore_Service.dart';
import 'cart_item.dart';
import 'food.dart';

class Restaurant extends ChangeNotifier {
  List<Food> _menu = [];
  List<Food> get menu => _menu;

  // User cart.
  final List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  // Delivery address.
  String _deliveryAddress = 'Default Address';
  String get deliveryAddress => _deliveryAddress;

  final FirestoreService _firestoreService = FirestoreService();

  Restaurant() {
    loadMenu();
  }

  Future<void> loadMenu() async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('foods').get();
    _menu = snapshot.docs.map((doc) => Food.fromFirestore(doc)).toList();
    notifyListeners();
  }

  void addToCart(Food food, List<Addon> selectedAddons) {
    CartItem? existing = _cart.firstWhereOrNull(
        (item) => item.food.id == food.id && ListEquality().equals(item.selectedAddons, selectedAddons));
    if (existing != null) {
      existing.quantity++;
    } else {
      _cart.add(CartItem(food: food, selectedAddons: selectedAddons));
    }
    notifyListeners();
  }

  void removeFromCart(CartItem cartItem) {
    int index = _cart.indexOf(cartItem);
    if (index != -1) {
      if (_cart[index].quantity > 1) {
        _cart[index].quantity--;
      } else {
        _cart.removeAt(index);
      }
      notifyListeners();
    }
  }

  double getTotalPrice() {
    return _cart.fold(0, (total, item) => total + item.totalPrice);
  }

  int getTotalItemCount() {
    return _cart.fold(0, (total, item) => total + item.quantity);
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  void updateDeliveryAddress(String newAddress) {
    _deliveryAddress = newAddress;
    notifyListeners();
  }

  // Generate a receipt string.
  String generateReceipt() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Receipt:');
    buffer.writeln('------------------------');
    _cart.forEach((cartItem) {
      buffer.writeln('${cartItem.food.name} x${cartItem.quantity}');
      cartItem.selectedAddons.forEach((addon) {
        buffer.writeln(' - ${addon.name}: \$${addon.price.toStringAsFixed(2)}');
      });
      buffer.writeln('Total: \$${cartItem.totalPrice.toStringAsFixed(2)}');
    });
    buffer.writeln('------------------------');
    buffer.writeln('Grand Total: \$${getTotalPrice().toStringAsFixed(2)}');
    buffer.writeln('Thank you for your order!');
    return buffer.toString();
  }

  // Generate a receipt number (using timestamp).
  String generateReceiptNumber() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}
