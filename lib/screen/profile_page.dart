import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            width: double.infinity,
            height: 250,
            child: DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  Text(
                    routeArg['username'],
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
            ),
          ),
          const Padding(
            child: Text('info'),
            padding: EdgeInsets.only(left: 15),
          ),
          const ListTile(title: Text('email'), subtitle: Text('email')),
          const ListTile(title: Text('Bio'), subtitle: Text('Bio')),
        ],
      ),
    );
  }
}
