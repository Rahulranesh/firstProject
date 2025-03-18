import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String driverName;
  final String driverId;

  ChatScreen({required this.driverName, required this.driverId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getChatId() {
    String userId = _auth.currentUser!.uid;
    String driverId = widget.driverId;
    return userId.compareTo(driverId) > 0 ? '${userId}_$driverId' : '${driverId}_$userId';
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    var message = {
      'text': _messageController.text.trim(),
      'senderId': _auth.currentUser!.uid,
      'senderName': _auth.currentUser!.displayName ?? 'User',
      'timestamp': FieldValue.serverTimestamp(),
    };
    await _firestore.collection('chats').doc(_getChatId()).collection('messages').add(message);
    _messageController.clear();
  }

  Widget _buildMessage(String message, bool isMe, String senderName) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent.withOpacity(0.8) : Colors.grey.withOpacity(0.5),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(senderName, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white70)),
            Text(message, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.driverName}')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('chats').doc(_getChatId()).collection('messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var messageDoc = snapshot.data!.docs[index];
                    bool isMe = messageDoc['senderId'] == _auth.currentUser!.uid;
                    return _buildMessage(messageDoc['text'], isMe, messageDoc['senderName']);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Type a message', border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          )
        ],
      ),
    );
  }
}
