import 'package:flutter/material.dart';

class MyQuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const MyQuantitySelector({required this.quantity, required this.onIncrement, required this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onDecrement, icon: Icon(Icons.remove)),
        Text(quantity.toString()),
        IconButton(onPressed: onIncrement, icon: Icon(Icons.add)),
      ],
    );
  }
}
