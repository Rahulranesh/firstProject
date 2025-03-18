import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../components/my_receipt.dart';


import '../database/firestore.dart';
import 'chat_screen.dart';

class DeliveryProgressPage extends StatefulWidget {
  final String receipt;
  final String receiptNumber;

  DeliveryProgressPage({required this.receipt, required this.receiptNumber});

  @override
  _DeliveryProgressPageState createState() => _DeliveryProgressPageState();
}
class _DeliveryProgressPageState extends State<DeliveryProgressPage> {
  final FirestoreService firestoreService = FirestoreService();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _saveOrder();
  }

  void _saveOrder() async {
    try {
      await firestoreService.saveOrderToDatabase(widget.receipt);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save order: $error')));
    }
  }

  // Mock driver details.
  final String driverName = "Driver Name";
  final String driverPhone = "+1234567890";

  void _showDriverDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Driver Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Name: $driverName'),
            Text('Phone: $driverPhone'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close'))
        ],
      ),
    );
  }

  void _callDriver() async {
    final Uri url = Uri(scheme: 'tel', path: driverPhone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not launch dialer')));
    }
  }

  void _messageDriver() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(driverName: driverName, driverId: 'driver_unique_id')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Delivery in Progress'), centerTitle: true, backgroundColor: Colors.transparent),
      bottomNavigationBar: _buildBottomNavBar(context),
      body: Column(
        children: [
          MyReceipt(receipt: widget.receipt, receiptNumber: widget.receiptNumber),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(40), topRight: Radius.circular(40)),
      ),
      padding: EdgeInsets.all(25),
      child: Row(
        children: [
          GestureDetector(
            onTap: _showDriverDetails,
            child: Container(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, shape: BoxShape.circle),
              child: IconButton(onPressed: _showDriverDetails, icon: Icon(Icons.person)),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(driverName, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Theme.of(context).colorScheme.inversePrimary)),
              Text('Driver', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ],
          ),
          Spacer(),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, shape: BoxShape.circle),
                child: IconButton(onPressed: _messageDriver, icon: Icon(Icons.message, color: Theme.of(context).colorScheme.primary)),
              ),
              SizedBox(width: 10),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.background, shape: BoxShape.circle),
                child: IconButton(onPressed: _callDriver, icon: Icon(Icons.call, color: Colors.green)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
