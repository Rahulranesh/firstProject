import 'package:flutter/material.dart';


import '../models/food.dart';

class FoodTile extends StatelessWidget {
  final Food food;
  final void Function()? onTap;
  
  const FoodTile({required this.food, this.onTap});
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text("\$${food.price.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                  Text(food.description, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary)),
                ],
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(food.imageUrl, height: 120, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }
}
