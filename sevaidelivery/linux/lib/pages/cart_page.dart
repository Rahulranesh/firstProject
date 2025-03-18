import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../components/my_cart_tile.dart';
import '../models/restaurant.dart';
import 'payment_page.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<Restaurant>(
      builder: (context, restaurant, child) {
        final cart = restaurant.cart;
        return Scaffold(
          appBar: AppBar(
            title: Text('Cart'),
            actions: [
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  if (cart.isNotEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Clear Cart'),
                        content: Text('Are you sure you want to clear the cart?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel')),
                          TextButton(onPressed: () {
                            restaurant.clearCart();
                            Navigator.pop(context);
                          }, child: Text('Yes'))
                        ],
                      ),
                    );
                  }
                },
              )
            ],
          ),
          body: cart.isEmpty
              ? Center(child: Text('Your cart is empty.'))
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, index) {
                          return MyCartTile(cartItem: cart[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentPage()));
                        },
                        child: Text('Proceed to Checkout'),
                      ),
                    )
                  ],
                ),
        );
      },
    );
  }
}
