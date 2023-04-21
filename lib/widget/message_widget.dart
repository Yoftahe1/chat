import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './shimmer.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key});
  String getUsername(name1, name2, uid, compare) {
    if (uid == compare) {
      return name2;
    }
    return name1;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: true);

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('friends')
            .where("uid", arrayContains: auth.getUser['uid'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) => Container(
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black12))),
                child: ListTile(
                  leading: const CircleAvatar(),
                  title: Text(getUsername(
                      snapshot.data?.docs[index]['username'][0],
                      snapshot.data?.docs[index]['username'][1],
                      snapshot.data?.docs[index]['uid'][0],
                      auth.getUser['uid'])),
                  subtitle: const Text('last message'),
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/MessageScreen', arguments: {
                      'username': getUsername(
                          snapshot.data?.docs[index]['username'][0],
                          snapshot.data?.docs[index]['username'][1],
                          snapshot.data?.docs[index]['uid'][0],
                          auth.getUser['uid']),
                      'docID':
                          '${snapshot.data?.docs[index]['uid'][0]}${snapshot.data?.docs[index]['uid'][1]}'
                    });
                  },
                ),
              ),
              itemCount: snapshot.data?.docs.length,
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Shimmering();
          } else {
            return const Text('has no data');
          }
        });
  }
}
