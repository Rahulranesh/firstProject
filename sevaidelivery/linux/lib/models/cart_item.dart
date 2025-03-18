import 'food.dart';
import 'package:collection/collection.dart';

class CartItem {
  final Food food;
  final List<Addon> selectedAddons;
  int quantity;

  CartItem({required this.food, required this.selectedAddons, this.quantity = 1});

  double get totalPrice {
    double addonsPrice = selectedAddons.fold(0, (sum, addon) => sum + addon.price);
    return (food.price + addonsPrice) * quantity;
  }

  bool equals(CartItem other) {
    return food.id == other.food.id && ListEquality().equals(selectedAddons, other.selectedAddons);
  }
}
