import 'package:flutter/material.dart';

class MyDescriptionBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var primaryTextStyle = TextStyle(color: Theme.of(context).colorScheme.inversePrimary);
    var secondaryTextStyle = TextStyle(color: Theme.of(context).colorScheme.primary);
    
    return Container(
      margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.secondary), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text('\$0.99', style: primaryTextStyle),
              Text('Delivery fee', style: secondaryTextStyle),
            ],
          ),
          Column(
            children: [
              Text('15-30 min', style: primaryTextStyle),
              Text('Delivery time', style: secondaryTextStyle),
            ],
          ),
        ],
      ),
    );
  }
}
