// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_element

import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_application_1/reusable_widgets/comment_button.dart";
import "package:flutter_application_1/reusable_widgets/like_button.dart";
import "package:flutter_application_1/screens/comment_screen.dart";
import "package:flutter_application_1/events/database.dart";

class PostScreen extends StatefulWidget {
  final String message;
  final String postId;
  final List<String> likes;
  final NetworkImage image;
  final String name;
  final String profileImage;

  const PostScreen({
    super.key,
    required this.message,
    required this.postId,
    required this.likes,
    required this.image,
    required this.name,
    required this.profileImage, //required this.profileImage,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _commentTextController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;
  bool isLiked = false;
  bool showFullMessage = false;
  String? profileImageUrl;

  @override
  void initState() {
    super.initState();

    isLiked = widget.likes.contains(currentUser.email);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    DocumentReference postRef =
        FirebaseFirestore.instance.collection("UsersData").doc(widget.postId);
    if (isLiked) {
      postRef.update({
        "Likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        "Likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("UsersData")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    });
  }

  void showCommentDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Add Comment"),
              content: TextField(
                controller: _commentTextController,
                decoration: InputDecoration(hintText: "Write a comment"),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: Text("Cancel")),
                TextButton(
                    onPressed: () {
                      addComment(_commentTextController.text);
                      Navigator.pop(context);
                      _commentTextController.clear();
                    },
                    child: Text("Post")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: toggleLike,
      child: Container(
        margin: EdgeInsets.all(15),
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 5,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget
                      .profileImage), // Placeholder image, replace with actual user image
                ),
                SizedBox(width: 10),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  showFullMessage
                      ? widget.message
                      : widget.message.length > 100
                          ? widget.message.substring(0, 100) + "..."
                          : widget.message,
                  style: TextStyle(fontSize: 14),
                ),
                if (widget.message.length > 100)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showFullMessage = !showFullMessage;
                      });
                    },
                    child: Text(
                      showFullMessage ? "Show Less" : "Show More",
                      style: TextStyle(
                          color: Colors.black, // Muted color
                          fontSize: 12, // Smaller font size
                          //decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                  onPressed: toggleLike,
                ),
                Text(
                  "${widget.likes.length} Likes",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                Spacer(),
                IconButton(
                    icon: Icon(Icons.comment, color: Colors.grey),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  CommentPage(postId: widget.postId)));
                    }),
                Text(
                  "Comment",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
