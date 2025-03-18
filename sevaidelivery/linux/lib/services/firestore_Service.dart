import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Save order with receipt and receipt number.
  Future<void> saveOrderToDatabase(String receipt, String receiptNumber) async {
    CollectionReference orders = _firestore.collection('orders');
    await orders.add({
      'receipt': receipt,
      'receiptNumber': receiptNumber,
      'date': DateTime.now(),
    });
  }

  // Load foods from Firestore.
  Future<List<Map<String, dynamic>>> loadFoods() async {
    QuerySnapshot snapshot = await _firestore.collection('foods').get();
    return snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return data;
    }).toList();
  }
}
