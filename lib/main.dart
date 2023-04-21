import 'package:chat/screen/add_screen.dart';
import 'package:chat/screen/friends_screen.dart';
import 'package:chat/screen/profile_page.dart';
import './screen/message_screen.dart';
import 'package:flutter/material.dart';
import './screen/autentication_screen.dart';
import 'package:provider/provider.dart';
import './provider/message.dart';
import './provider/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import './screen/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const Homepage());
}

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: MessageProvider(),
        ),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
      ],
      child: MaterialApp(
        home: const AuthenticationScreen(),
        routes: {
          '/AuthenticationScreen': (context) => const AuthenticationScreen(),
          '/FriendsScreen': (context) => FriendsScreen(),
          '/MessageScreen': (context) => const MessageScreen(),
          '/AddScreen': (context) => const AddScreen(),
          '/ProfileScreen': (context) => ProfileScreen(),
          '/ProfilePage': (context) => const ProfilePage(),
        },
      ),
    );
  }
}
