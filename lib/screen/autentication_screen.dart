import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  bool login = true;
  bool obs = true;
  String error = '';
  var sign = {'email': '', 'username': '', 'password': ''};
  final _formKey = GlobalKey<FormState>();

  void changeAuthScreen() {
    setState(() {
      login = !login;
      error = '';
    });
  }

  void changePasswordVisibility() {
    setState(() {
      obs = !obs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    void submit() {
      setState(() {
        error = '';
      });
      final isValid = _formKey.currentState!.validate();
      FocusScope.of(context).unfocus(); //close keyboard if open
      if (isValid) {
        _formKey.currentState!.save();
        if (login) {
          auth
              .signIn(sign['email'].toString(), sign['password'].toString())
              .then((value) =>
                  Navigator.of(context).pushReplacementNamed('/FriendsScreen'))
              .catchError((onError) => setState(() {
                    error = onError;
                  }));
        } else {
          auth
              .signUp(sign['email'].toString(), sign['username'].toString(),
                  sign['password'].toString())
              .then((value) =>
                  Navigator.of(context).pushReplacementNamed('/FriendsScreen'))
              .catchError((onError) => setState(() {
                    error = onError;
                  }));
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: Card(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'please enter valid email';
                    } else {
                      return null;
                    }
                  },
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  onSaved: (newValue) {
                    sign['email'] = newValue.toString();
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                if (!login)
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty || value.length < 4) {
                        return 'password must be at least 4 characters';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'UserName',
                    ),
                    onSaved: (newValue) =>
                        sign['username'] = newValue.toString(),
                  ),
                const SizedBox(
                  height: 10,
                ),
                Stack(
                  children: [
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || value.length < 8) {
                          return 'password must be at least 8 characters';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      obscureText: obs,
                      decoration: const InputDecoration(labelText: 'Password'),
                      onSaved: (newValue) =>
                          sign['password'] = newValue.toString(),
                    ),
                    Positioned(
                      right: 0,
                      child: IconButton(
                          color: Colors.grey,
                          onPressed: changePasswordVisibility,
                          icon: obs
                              ? const Icon(Icons.visibility)
                              : const Icon(Icons.visibility_off)),
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                if (error.length > 0)
                  Column(
                    children: [
                      Text(error),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ElevatedButton(
                    onPressed: submit,
                    child: login ? const Text('signIn') : const Text('SignUP')),
                TextButton(
                    onPressed: changeAuthScreen,
                    child: login
                        ? const Text('create account')
                        : const Text('Login to account'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
