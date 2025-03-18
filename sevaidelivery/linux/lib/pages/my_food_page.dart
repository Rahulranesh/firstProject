import 'package:flutter/material.dart';


import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../models/food.dart';
import '../models/restaurant.dart';


class FoodPage extends StatefulWidget {
  final Food food;
  FoodPage({required this.food});
  
  @override
  _FoodPageState createState() => _FoodPageState();
}
class _FoodPageState extends State<FoodPage> {
  Map<Addon, bool> selectedAddons = {};
  
  @override
  void initState() {
    super.initState();
    widget.food.availableAddons.forEach((addon) {
      selectedAddons[addon] = false;
    });
  }
  
  void addToCart() {
    List<Addon> addons = [];
    selectedAddons.forEach((addon, isSelected) {
      if (isSelected) addons.add(addon);
    });
    Provider.of<Restaurant>(context, listen: false).addToCart(widget.food, addons);
    Navigator.pop(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.food.imageUrl),
            Padding(
              padding: EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.food.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  SizedBox(height: 10),
                  Text("\$${widget.food.price.toStringAsFixed(2)}", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 16)),
                  SizedBox(height: 10),
                  Text(widget.food.description, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16)),
                  SizedBox(height: 10),
                  Text("Add-ons", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 10),
                  ListView.builder(
                    itemCount: widget.food.availableAddons.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final addon = widget.food.availableAddons[index];
                      return CheckboxListTile(
                        title: Text(addon.name),
                        subtitle: Text("${addon.description} - \$${addon.price.toStringAsFixed(2)}"),
                        value: selectedAddons[addon],
                        onChanged: (val) {
                          setState(() {
                            selectedAddons[addon] = val!;
                          });
                        },
                      );
                    },
                  )
                ],
              ),
            ),
            MyButton(onTap: addToCart, text: 'Add to Cart'),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
