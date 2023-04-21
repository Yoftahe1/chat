import 'package:flutter/material.dart';

class Message {
  final String message;
  final String senderId;
  final String receiverId;
  final DateTime time;
  Message({
    required this.message,
    required this.time,
    required this.senderId,
    required this.receiverId,
  });
}

class MessageProvider with ChangeNotifier {
  List<Message> _messages = [
    Message(
        message: 'message1',
        time: DateTime.now(),
        senderId: 'senderId',
        receiverId: 'receiverId'),
    Message(
        message: 'message2',
        time: DateTime.now(),
        senderId: 'senderId',
        receiverId: 'receiverId'),
    Message(
        message: 'message3',
        time: DateTime.now(),
        senderId: 'senderId',
        receiverId: 'receiverId')
  ];
  List<Message> get getMessages {
    return [..._messages];
  }

  void addMessage(String newMessage) {
    _messages.add(Message(
        message: newMessage,
        time: DateTime.now(),
        senderId: 'senderId',
        receiverId: 'receiverId'));
    notifyListeners();
  }
}
