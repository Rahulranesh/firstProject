import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../models/restaurant.dart';
import 'delivery_progress.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}
class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;

  void userTappedPay() {
    if (formKey.currentState!.validate()) {
      final restaurant = Provider.of<Restaurant>(context, listen: false);
      String receipt = restaurant.generateReceipt();
      String receiptNumber = restaurant.generateReceiptNumber();
      
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Payment'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Card Number: $cardNumber'),
                Text('Expiry Date: $expiryDate'),
                Text('Card Holder: $cardHolderName'),
                Text('CVV: $cvvCode'),
                SizedBox(height: 20),
                Text('Receipt:'),
                SizedBox(height: 10),
                Text(receipt),
                SizedBox(height: 10),
                Text('Receipt Number: $receiptNumber'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => DeliveryProgressPage(receipt: receipt, receiptNumber: receiptNumber)),
                );
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text('Check Out'),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              showBackView: isCvvFocused,
              onCreditCardWidgetChange: (p0) {},
            ),
            SizedBox(height: 20),
            CreditCardForm(
              formKey: formKey,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              onCreditCardModelChange: (data) {
                setState(() {
                  cardNumber = data.cardNumber;
                  expiryDate = data.expiryDate;
                  cardHolderName = data.cardHolderName;
                  cvvCode = data.cvvCode;
                  isCvvFocused = data.isCvvFocused;
                });
              },
              obscureCvv: true,
              obscureNumber: false,
            ),
            SizedBox(height: 20),
            MyButton(onTap: userTappedPay, text: 'Pay now'),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }
}
