import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:provider/provider.dart';
import '../provider/message.dart';
import '../provider/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widget/shimmer.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: true);
    final routeArg =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final friendId = routeArg['docID']!;
    final friendRef =
        FirebaseFirestore.instance.collection("friends").doc(friendId);

    void addMessage(message) {
      friendRef.update({
        "message": FieldValue.arrayUnion([
          {'sender': auth.getUser['uid'], 'message': message},
        ]),
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () => Navigator.of(context).pushNamed('/ProfilePage',
                arguments: {'username': routeArg['username']!.toString()}),
            child: Row(
              children: [
                const CircleAvatar(backgroundColor: Colors.amber),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(routeArg['username']!.toString()),
                    const Text(
                      'last seen',
                      style: TextStyle(fontSize: 13),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
                    stream: friendRef.snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return ListView.builder(
                          itemCount: snapshot.data!['message'].length,
                          itemBuilder: (context, index) => InkWell(
                            onLongPress: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('what do u want'),
                                      content: const Text(
                                          'do u want to delete message'),
                                      actions: [
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('yes')),
                                        OutlinedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('no'))
                                      ],
                                    );
                                  });
                            },
                            child: Padding(
                              padding: EdgeInsets.all(3),
                              child: BubbleSpecialThree(
                                text: snapshot.data!['message'][index]
                                    ['message'],
                                tail: true,
                                color: auth.getUser['uid'] ==
                                        snapshot.data!['message'][index]
                                            ['sender']
                                    ? const Color(0xFF1B97F3)
                                    : const Color.fromARGB(255, 72, 72, 224),
                                textStyle: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                                isSender: auth.getUser['uid'] ==
                                        snapshot.data!['message'][index]
                                            ['sender']
                                    ? true
                                    : false,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        //return const Shimmering();
                        return const Text('');
                      } else {
                        return const Text('has no data');
                      }
                    })),
            MessageBar(
              onSend: (Message) => addMessage(Message),
              actions: [
                InkWell(
                  child: const Icon(
                    Icons.add,
                    color: Colors.black,
                    size: 24,
                  ),
                  onTap: () {},
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: InkWell(
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.green,
                      size: 24,
                    ),
                    onTap: () {},
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
