import 'package:flutter/material.dart';
import 'package:flutter_application_0/constants/pallete.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _commentController = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {"message": "Hello! How can I assist you today?", "isBot": true},
    {"message": "Hi! I'm here to help.", "isBot": false},
  ];

  void _addMessage(String message, bool isBot) {
    setState(() {
      _messages.add({"message": message, "isBot": isBot});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
  backgroundColor: Pallete.whiteColor,
  leading: GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0), // Adjust padding as needed
      child: Icon(
        Icons.arrow_back_ios, // Use the Cupertino-style back button icon
        color: Colors.black,
      ),
    ),
  ),
),

      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                bool isBot = _messages[index]["isBot"];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    mainAxisAlignment: isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
                    children: [
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isBot ? Colors.grey[200] :Pallete.darkgreenColor,
                        ),
                        padding: EdgeInsets.all(12),
                        child: Text(
                          _messages[index]["message"],
                          style: TextStyle(color: isBot ? Colors.black : Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
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
                              hintText: 'Type your message...',
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
                            String message = _commentController.text;
                            if (message.isNotEmpty) {
                              _addMessage(message, false); // User's message
                              // Dummy bot response for demonstration
                              _addMessage("I received your message", true);
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
}

void main() {
  runApp(MaterialApp(
    home: ChatPage(),
  ));
}
