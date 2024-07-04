import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia_app/components/my_drawer.dart';
import 'package:socialmedia_app/components/wall.dart';
import 'package:socialmedia_app/helper/helper.dart';

final _currentUser = FirebaseAuth.instance.currentUser!;
final textController = TextEditingController();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessages() {
    final enteredMessages = textController.text;
    if (enteredMessages.trim().isEmpty) {
      return;
    }

    FirebaseFirestore.instance.collection("users").doc(_currentUser.uid).get();

    FirebaseFirestore.instance.collection("Posts").add(
      {
        "email": _currentUser.email,
        "Message": enteredMessages,
        "TimeStamp": Timestamp.now(),
        "userID": _currentUser.uid,
        "Likes": []
      },
    );

    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      drawer: MyDrawer(onProfile: () {}, logout: signOut),
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.center,
          child: Center(
            child: Text("Social App"),
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts")
                    .orderBy("TimeStamp", descending: false)
                    .snapshots(),
                builder: (context, snapshots) {
                  if (snapshots.hasData) {
                    return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index) {
                        final posts = snapshots.data!.docs[index];
                        return WallPosts(
                          message: posts["Message"],
                          user: posts["email"],
                          posts: posts.id,
                          likes: List<String>.from(posts["Likes"] ?? []),
                          time: formatDate(posts["TimeStamp"]),
                        );
                      },
                    );
                  } else if (snapshots.hasError) {
                    return Center(
                      child: Text("Error ${snapshots.error}"),
                    );
                  }
                  return CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: "Write Something...",
                        labelStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer),
                      ),
                      obscureText: false,
                      controller: textController,
                    ),
                  ),
                  IconButton(
                    onPressed: postMessages,
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
            Text("Hello ${_currentUser.email!}"),
          ],
        ),
      ),
    );
  }
}
