import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia_app/components/comment_button.dart';
import 'package:socialmedia_app/components/comments.dart';
import 'package:socialmedia_app/components/delete_button.dart';
import 'package:socialmedia_app/components/like_button.dart';
import 'package:socialmedia_app/helper/helper.dart';

class WallPosts extends StatefulWidget {
  final String user;
  final String message;
  final String posts;
  final String time;
  final List<String> likes;

  const WallPosts(
      {super.key,
      required this.message,
      required this.user,
      required this.likes,
      required this.time,
      required this.posts});

  @override
  State<WallPosts> createState() => _WallPostsState();
}

class _WallPostsState extends State<WallPosts> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  final _commentTextfield = TextEditingController();

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLikes() {
    setState(
      () {
        isLiked = !isLiked;
      },
    );
    DocumentReference postRef =
        FirebaseFirestore.instance.collection("Posts").doc(widget.posts);

    if (isLiked) {
      postRef.update(
        {
          "Likes": FieldValue.arrayUnion([currentUser.email])
        },
      );
    } else {
      postRef.update(
        {
          "Likes": FieldValue.arrayRemove([currentUser.email])
        },
      );
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(widget.posts)
        .collection("comments")
        .add({
      "commentsText": commentText,
      "commentsBy": currentUser.email,
      "commentsTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Comment"),
        content: TextField(
          controller: _commentTextfield,
          decoration: const InputDecoration(hintText: "Write a comment.."),
        ),
        actions: [
          // cancel
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextfield.clear();
            },
            child: const Text("Cancel"),
          ),
          // save
          TextButton(
            onPressed: () {
              addComment(_commentTextfield.text);

              Navigator.pop(context);

              _commentTextfield.clear();
            },
            child: const Text("Post"),
          ),
        ],
      ),
    );
  }

  void deletePost() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Delete Post?"),
              content: const Text("Are You Sure"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    final commentDocs = await FirebaseFirestore.instance
                        .collection("Posts")
                        .doc(widget.posts)
                        .collection("comments")
                        .get();

                    for (var doc in commentDocs.docs) {
                      await FirebaseFirestore.instance
                          .collection("Posts")
                          .doc(widget.posts)
                          .collection("comments")
                          .doc(doc.id)
                          .delete();
                    }
                    FirebaseFirestore.instance
                        .collection("Posts")
                        .doc(widget.posts)
                        .delete()
                        .then(
                          (value) => print("Post Deleted"),
                        )
                        .catchError(
                          (error) => print("Failed to delete post $error"),
                        );
                    Navigator.pop(context);
                  },
                  child: const Text("Delete"),
                ),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.message,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.user,
                        style: TextStyle(
                          color: Colors.grey[400],
                        ),
                      ),
                      Text(
                        " . ",
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                      Text(
                        widget.time,
                        style: TextStyle(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],
              ),
              if (widget.user == currentUser.email)
                DeleteButton(onTap: deletePost)
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // liked
              Column(
                children: [
                  LikedButton(isLiked: isLiked, onTap: toggleLikes),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.likes.length.toString(),
                  )
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.likes.length.toString(),
                  )
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Posts")
                .doc(widget.posts)
                .collection("comments")
                .orderBy("commentsTime", descending: true)
                .snapshots(),
            builder: (context, snapshots) {
              if (!snapshots.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshots.data!.docs.map((doc) {
                  final commentData = doc.data();

                  return Comments(
                    text: commentData["commentsText"],
                    time: formatDate(
                      commentData["commentsTime"],
                    ),
                    users: commentData["commentsBy"],
                  );
                }).toList(),
              );
            },
          )
        ],
      ),
    );
  }
}
