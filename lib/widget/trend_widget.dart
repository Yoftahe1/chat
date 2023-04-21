import 'package:chat/provider/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './shimmer.dart';

class TrendWidget extends StatefulWidget {
  var _storedImage;

  @override
  State<TrendWidget> createState() => _TrendWidgetState();
}

class _TrendWidgetState extends State<TrendWidget> {
  // File? _pickedImage;
  bool isVisible = true;
  final postMessage = TextEditingController();

  Future<void> _takePic() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      widget._storedImage = pickedImageFile;
    });
  }

  void pickImg() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    final pickedImageFile = File(pickedImage!.path);
    setState(() {
      widget._storedImage = pickedImageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context, listen: false);
    void submit() async {
      if (postMessage.text.trim().length > 0) {
        FocusScope.of(context).unfocus();
        var url = '';
        if (widget._storedImage != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('trend_image')
              .child(auth.getUser['uid'] + DateTime.now().toString() + '.jpg');
          await ref.putFile(widget._storedImage);
          url = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance.collection('trends').add({
          'description': postMessage.text,
          'uid': auth.getUser['uid'],
          'username': auth.getUser['username'],
          'image': url,
        });
        setState(() {
          widget._storedImage = null;
          postMessage.text = '';
        });
      } else if (postMessage.text.trim().length == 0 ||
          postMessage.text.isEmpty) {
        const snackBar = SnackBar(
          content: Text('must have description'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Column(
      children: [
        if (isVisible)
          Card(
            //shape: CircleBorder,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))),
            elevation: 4,
            child: Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: const InputDecoration(
                            label: Text('What is on your mind ?')),
                        onSubmitted: (_) => submit(),
                        controller: postMessage,
                      ),
                    ),
                    IconButton(
                      onPressed: submit,
                      icon: const Icon(Icons.send_rounded),
                      color: Colors.blue,
                    )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        onPressed: _takePic,
                        label: const Text('Camera'),
                        icon: const Icon(Icons.camera_alt)),
                    TextButton.icon(
                        onPressed: pickImg,
                        label: const Text('Gallery'),
                        icon: const Icon(Icons.image)),
                    if (widget._storedImage != null)
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget._storedImage = null;
                          });
                        },
                        child: Container(
                          child: Image.file(
                            widget._storedImage!,
                          ),
                          height: 50,
                        ),
                      )
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        Expanded(
          child: StreamBuilder(
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction == ScrollDirection.forward) {
                      if (!isVisible)
                        setState(() {
                          isVisible = true;
                        });
                    }
                    if (notification.direction == ScrollDirection.reverse) {
                      if (isVisible)
                        setState(() {
                          isVisible = false;
                        });
                    }
                    return true;
                  },
                  child: ListView.builder(
                    itemBuilder: (context, index) => Card(
                      elevation: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            leading: const CircleAvatar(),
                            title: Text(snapshot.data?.docs[index]['username']),
                            onTap: () {
                              Navigator.of(context).pushNamed('/ProfilePage',
                                  arguments: {
                                    'username': snapshot.data?.docs[index]
                                        ['username']
                                  });
                            },
                          ),
                          Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Text(
                                  snapshot.data?.docs[index]['description'])),
                          if (snapshot.data?.docs[index]['image'].length > 0)
                            Container(
                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  snapshot.data?.docs[index]['image'],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                    itemCount: snapshot.data?.docs.length,
                  ),
                );
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Shimmering();
              } else {
                return const Text('has no data');
              }
            },
            stream: FirebaseFirestore.instance.collection('trends').snapshots(),
          ),
        )
      ],
    );
  }
}
