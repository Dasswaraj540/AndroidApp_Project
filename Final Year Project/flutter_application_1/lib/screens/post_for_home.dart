import 'package:flutter/material.dart';

class PostScreen2 extends StatefulWidget {
  final String message;
  final String postId;

  final NetworkImage image;
  final String name;
  final String profileImage;
  const PostScreen2(
      {Key? key,
      required this.message,
      required this.postId,
      required this.image,
      required this.name,
      required this.profileImage})
      : super(key: key);

  @override
  _PostScreen2State createState() => _PostScreen2State();
}

class _PostScreen2State extends State<PostScreen2> {
  bool showFullMessage = false;
  String? profileImageUrl;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: 390,
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
          ],
        ),
      ),
    );
  }
}
