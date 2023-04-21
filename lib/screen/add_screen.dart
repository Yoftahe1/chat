import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  List people = [];
  void search(var input) async {
    final strFrontCode = input.substring(0, input.length - 1);
    final strEndCode = input[input.length - 1];
    final limit =
        strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);

    final citiesRef = FirebaseFirestore.instance.collection("users");
    final query = await citiesRef
        .where("username", isGreaterThanOrEqualTo: input)
        .where("username", isLessThan: limit)
        .get()
        .then(
      (doc) {
        setState(() {
          people = doc.docs.toList();
        });
      },
      onError: (e) => print("Error completing: $e"),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);

    void add(secondPersonName, secondPersonUid) async {
      FocusScope.of(context).unfocus();

      await FirebaseFirestore.instance
          .collection('friends')
          .doc('${auth.getUser['uid']}$secondPersonUid')
          .set({
        'uid': [auth.getUser['uid'], secondPersonUid],
        'username': [auth.getUser['username'], secondPersonName],
        'message': [],
      });
      const snackBar = SnackBar(
        content: Text('friend added'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('add'),
      ),
      body: Column(
        children: [
          TextField(
              onChanged: search,
              decoration: const InputDecoration(labelText: 'enter to search')),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) => Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: ListTile(
                  leading: const CircleAvatar(),
                  title: Text(people[index]['username'] as String),
                  trailing: ElevatedButton.icon(
                      onPressed: () =>
                          add(people[index]['username'], people[index]['uid']),
                      icon: const Icon(Icons.person_add_alt_rounded),
                      label: const Text('add')),
                ),
              ),
              itemCount: people.length,
            ),
          )
        ],
      ),
    );
  }
}
