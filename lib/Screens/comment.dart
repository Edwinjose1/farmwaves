import 'package:flutter/material.dart';

class Comment {
  final String userName;
  final String comment;
  bool isLiked;

  Comment({
    required this.userName,
    required this.comment,
    this.isLiked = false,
  });
}

class CommentPageContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color of Scaffold
      body: SizedBox(
        // height: MediaQuery.of(context).size.height * 10, // 75% of screen height
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
            color: Colors.yellow,
          ),
          child: CommentPage(),
        ),
      ),
    );
  }
}


class CommentPage extends StatefulWidget {
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> comments = [
    Comment(userName: "Amal Thomas", comment: "Help full", isLiked: false),
    Comment(userName: "David ", comment: "Good imformation", isLiked: true),
    // Add more comments as needed
  ];

  TextEditingController _commentController = TextEditingController();

  void _toggleLike(Comment comment) {
    setState(() {
      comment.isLiked = !comment.isLiked;
    });
  }

  void _addComment(String comment) {
    setState(() {
      comments.add(Comment(userName: "User", comment: comment));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container( height: MediaQuery.of(context).size.height * .75, 
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 30),
          Container(height: 5, width: 50, color: Colors.grey),
          Text(
            'Comments',
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(color: Colors.grey, thickness: 2),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return _buildCommentTile(comments[index]);
              },
            ),
          ),
          Divider(color: Colors.grey, thickness: 2),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/2.jpg'),
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Add a comment for post',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              hintStyle: TextStyle(color: Colors.black),
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send, color: Colors.black),
                          onPressed: () {
                            String comment = _commentController.text;
                            if (comment.isNotEmpty) {
                              _addComment(comment);
                              _commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(Comment comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: AssetImage('assets/images/2.jpg'),
        backgroundColor: Colors.white,
      ),
      title: Text(comment.userName, style: TextStyle(color: Colors.black)),
      subtitle: Text(comment.comment, style: TextStyle(color: Colors.black)),
      trailing: IconButton(
        icon: Icon(
          comment.isLiked ? Icons.favorite : Icons.favorite_border,
          color: comment.isLiked ? Colors.red : Colors.black,
        ),
        onPressed: () {
          _toggleLike(comment);
        },
      ),
    );
  }
}

