import 'package:chat/widget/drawer_widget.dart';
import 'package:chat/widget/trend_widget.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../widget/message_widget.dart';

class FriendsScreen extends StatefulWidget {
  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen> {
  // const FriendsScreen({super.key});
  int index = 0;
  void selectPage(int idx) {
    setState(() {
      index = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: index == 0 ? const Text('Trend') : const Text('Chat'),
      ),
      drawer: const Drawer(child: DrawerWidget()),
      body: index == 1 ? const MessageWidget() : TrendWidget(),
      bottomNavigationBar:
          BottomNavigationBar(onTap: selectPage, currentIndex: index, items: [
        const BottomNavigationBarItem(
            icon: Icon(Icons.category), label: 'Trend'),
        const BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Chat'),
      ]),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.of(context).pushNamed('/AddScreen'),
          child: const Icon(Icons.add)),
    );
  }
}
