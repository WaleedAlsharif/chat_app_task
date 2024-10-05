import 'package:chat_app_task/screens/chat/bloc/chat_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';

class MessageList extends StatelessWidget {
  final String senderId;
  final String receiverId;

  const MessageList({required this.senderId, required this.receiverId});

  @override
  Widget build(BuildContext context) {
    // Generate the chat ID
    final String chatId =
        BlocProvider.of<ChatBloc>(context).generateChatId(senderId, receiverId);

    // Load messages when the widget builds
    BlocProvider.of<ChatBloc>(context).add(LoadMessagesEvent(chatId));

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state is MessagesLoaded) {
          return ListView.builder(
            itemCount: state.messages.length,
            itemBuilder: (context, index) {
              var message = state.messages[index];
              bool isMe = message['senderId'] == senderId;
              // Convert Firestore timestamp to DateTime and format it
              // Check if the timestamp exists and is not null
              var timestamp = message['timestamp'];
              String formattedTime = '';

              if (timestamp != null) {
                // Convert Firestore timestamp to DateTime and format it
                var messageTime = (timestamp as Timestamp).toDate();
                formattedTime = DateFormat('hh:mm a')
                    .format(messageTime); // Example: 08:30 PM
              } else {
                formattedTime = ''; // Fallback for missing timestamp
              }
              return ListTile(
                title: Align(
                  alignment:
                      isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isMe ? Color(0xFF048067) : Color(0xFF333333),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message['message'],
                          style: const TextStyle(color: Colors.white),
                        ),
                        Text(
                          formattedTime,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ChatError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
