import 'package:flutter/material.dart';

class MyReceipt extends StatelessWidget {
  final String receipt;
  final String receiptNumber;
  MyReceipt({required this.receipt, required this.receiptNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25, right: 25, bottom: 25, top: 50),
      child: Column(
        children: [
          Text('Thank you for your order!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
          Text('Receipt Number: $receiptNumber', style: TextStyle(fontSize: 16)),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(25),
            decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.secondary), borderRadius: BorderRadius.circular(12)),
            child: Text(receipt),
          ),
        ],
      ),
    );
  }
}
