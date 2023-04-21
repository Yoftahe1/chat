import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: ListView(
        children: [
          const CircleAvatar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.photo),
                  label: const Text('open gallery')),
              TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('open camera')),
            ],
          ),
          const TextField(
            decoration: InputDecoration(label: Text('username')),
          ),
          const TextField(
            decoration: InputDecoration(label: Text('bio')),
          )
        ],
      ),
    );
  }
}
