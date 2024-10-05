import 'package:chat_app_task/extensions/sized_box_extension.dart';
import 'package:chat_app_task/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_app_task/screens/chat/bloc/chat_event.dart';
import 'package:chat_app_task/screens/chat/message_list.dart';
import 'package:chat_app_task/widgets/custom_botton_nav_with_shadow.dart';
import 'package:chat_app_task/widgets/my_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.reciverName,
    required this.reciverId,
    required this.senderId,
  });
  final String reciverName;
  final String reciverId;
  final String senderId;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

final TextEditingController _messageController = TextEditingController();

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isTyping = false;

  void _setTypingStatus(bool isTyping) {
    if (_isTyping != isTyping) {
      setState(() {
        _isTyping = isTyping;
      });

      // Update the 'isTyping' field in Firestore
      _firestore.collection('users').doc(widget.senderId).update({
        'isTyping': isTyping,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25.r,
                backgroundImage: const AssetImage("assets/icons/profile.png"),
              ),
              30.width,
              Column(
                children: [
                  Text(widget.reciverName),
                  // Typing Indicator and Online/Offline Status
                  StreamBuilder(
                    stream: _firestore
                        .collection('users')
                        .doc(widget.reciverId)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasData) {
                        var user = snapshot.data!;
                        bool isTyping = user['isTyping'] ?? false;
                        String status = user['status'] ?? 'offline';

                        // Show typing indicator if the user is typing, otherwise show online/offline status
                        if (isTyping) {
                          return Text(
                            "${user['name']} is typing...",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 10),
                          );
                        } else {
                          return Text(
                            "${user['name']} is $status",
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          );
                        }
                      } else {
                        return const SizedBox.shrink(); // No data yet
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
          titleTextStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          // leadingWidth: 120,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF048067),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: MessageList(
                  senderId: widget.senderId, receiverId: widget.reciverId),
            ),
            CustomBottomNavBarWithShadow(
              topPadding: 0,
              horizontalPadding: 0,
              bgColor: const Color(0xFF222222),
              shadow: false,
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                        showFocusBorder: false,
                        controller: _messageController,
                        hint: "write your message ...",
                        textColor: Colors.white,
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            _setTypingStatus(true);
                          } else {
                            _setTypingStatus(false);
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.send,
                        color: Color(0xff2ECCAD),
                      ),
                      onPressed: () {
                        BlocProvider.of<ChatBloc>(context).add(
                          SendMessageEvent(
                            senderId: widget.senderId,
                            receiverId: widget.reciverId,
                            message: _messageController.text.trim(),
                          ),
                        );
                        _messageController.clear();
                        _setTypingStatus(
                            false); // Stop typing after sending the message
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
