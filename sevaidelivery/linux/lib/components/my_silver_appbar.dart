import 'package:flutter/material.dart';

import '../pages/cart_page.dart';


class MySilverAppBar extends StatelessWidget {
  final Widget child;
  MySilverAppBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 340,
      collapsedHeight: 120,
      floating: false,
      title: Text('Food Delivery', style: TextStyle(fontWeight: FontWeight.bold)),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
          },
          icon: Icon(Icons.shopping_cart),
        ),
      ],
      backgroundColor: Theme.of(context).colorScheme.background,
      flexibleSpace: FlexibleSpaceBar(
        background: child,
      ),
    );
  }
}
