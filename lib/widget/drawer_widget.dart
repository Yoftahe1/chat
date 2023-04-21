import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          width: double.infinity,
          child: DrawerHeader(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<Auth>(
                  builder: (context, value, child) => Text(
                    value.getUser['username'],
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.edit_note_rounded),
          title: const Text('profile'),
          onTap: () => Navigator.of(context).pushNamed('/ProfileScreen'),
        ),
        const ListTile(
          leading: Icon(Icons.create),
          title: Text('Add'),
        ),
        const ListTile(
          leading: Icon(Icons.phone),
          title: Text('Call'),
        ),
        const ListTile(
          leading: Icon(Icons.person),
          title: Text('Contact'),
        ),
        const ListTile(
          leading: Icon(Icons.flag),
          title: Text('Saved Message'),
        ),
        const ListTile(
          leading: SizedBox(
            width: 40,
            child: Switch(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              value: false,
              onChanged: null,
            ),
          ),
          title: Text('Night Mode'),
        ),
        const ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/AuthenticationScreen');
          },
          leading: const Icon(Icons.logout),
          title: const Text('Logout '),
        ),
      ],
    );
  }
}
