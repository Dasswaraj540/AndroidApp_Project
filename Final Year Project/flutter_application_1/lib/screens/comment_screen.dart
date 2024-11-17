// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:timeago/timeago.dart' as timeago; // Import timeago package

class CommentPage extends StatefulWidget {
  final String postId;

  const CommentPage({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _commentTextController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser!;

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("UsersData")
        .doc(widget.postId)
        .collection("Comments")
        .add({
      "CommentText": commentText,
      "CommentedBy": currentUser.email,
      "CommentTime": Timestamp.now(),
    }).then((value) {
      // Clear the text field after posting comment
      _commentTextController.clear();
    }).catchError((error) {
      // Handle error, if any
      print("Failed to add comment: $error");
    });
  }

  void deleteComment(String commentId) {
    FirebaseFirestore.instance
        .collection("UsersData")
        .doc(widget.postId)
        .collection("Comments")
        .doc(commentId)
        .delete()
        .then((value) {
      // Comment deleted successfully
      print('Comment deleted successfully');
    }).catchError((error) {
      // Handle error, if any
      print("Failed to delete comment: $error");
    });
  }

  void editComment(String commentId, String newText) {
    FirebaseFirestore.instance
        .collection("UsersData")
        .doc(widget.postId)
        .collection("Comments")
        .doc(commentId)
        .update({
      "CommentText": newText,
    }).then((value) {
      // Comment updated successfully
      print('Comment updated successfully');
    }).catchError((error) {
      // Handle error, if any
      print("Failed to update comment: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        //backgroundColor: Colors.blue, // Use consistent theme color
      ),
      body: Column(
        children: [
          Expanded(
            child: CommentsList(
              postId: widget.postId,
              onDelete: deleteComment,
              onEdit: editComment,
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  blurRadius: 5,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentTextController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_commentTextController.text.isNotEmpty) {
                      addComment(_commentTextController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CommentsList extends StatelessWidget {
  final String postId;
  final Function(String) onDelete;
  final Function(String, String) onEdit;

  const CommentsList({
    Key? key,
    required this.postId,
    required this.onDelete,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection("UsersData")
          .doc(postId)
          .collection("Comments")
          .orderBy('CommentTime', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No comments yet.'));
        }
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var comment = snapshot.data!.docs[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            comment['CommentText'],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(width: 8),
                        if (currentUser.email == comment['CommentedBy'])
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showEditDialog(context, comment.id,
                                    comment['CommentText']);
                              } else if (value == 'delete') {
                                onDelete(comment.id);
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
                                value: 'edit',
                                child: Row(
                                  // ignore: prefer_const_literals_to_create_immutables
                                  children: [
                                    Icon(Icons.edit, size: 20),
                                    SizedBox(width: 8),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
                              PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, size: 20),
                                    SizedBox(width: 8),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          comment['CommentedBy'],
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          _getTimeAgo(comment['CommentTime']),
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getTimeAgo(Timestamp timestamp) {
    DateTime commentTime = timestamp.toDate();
    Duration difference = DateTime.now().difference(commentTime);
    return timeago.format(DateTime.now().subtract(difference));
  }

  void _showEditDialog(
      BuildContext context, String commentId, String currentText) {
    TextEditingController controller = TextEditingController(text: currentText);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Edit Comment"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Edit your comment"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              String newText = controller.text.trim();
              if (newText.isNotEmpty) {
                onEdit(commentId, newText);
                Navigator.pop(context);
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
