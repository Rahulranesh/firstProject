import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/cart_item.dart';
import '../models/restaurant.dart';
import 'my_quantity_selector.dart';


class MyCartTile extends StatelessWidget {
  final CartItem cartItem;
  MyCartTile({required this.cartItem});
  
  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) => Container(
        margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(cartItem.food.imageUrl, height: 100, width: 100, fit: BoxFit.cover),
            ),
            SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(cartItem.food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 4),
                  Text("\$${cartItem.food.price.toStringAsFixed(2)}", style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                ],
              ),
            ),
            MyQuantitySelector(
              quantity: cartItem.quantity,
              onIncrement: () {
                Provider.of<Restaurant>(context, listen: false).addToCart(cartItem.food, cartItem.selectedAddons);
              },
              onDecrement: () {
                Provider.of<Restaurant>(context, listen: false).removeFromCart(cartItem);
              },
            )
          ],
        ),
      ),
    );
  }
}
