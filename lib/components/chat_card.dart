import 'package:chat_app_task/components/text_message.dart';
import 'package:flutter/material.dart';

class ChatMessageCard extends StatelessWidget {
  const ChatMessageCard(
      {Key? key,
      required this.message,
      required this.image,
      required this.name})
      : super(key: key);

  final ChatMessage message;
  final String image, name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        message.messageType == ChatMessageType.image ||
                message.messageType == ChatMessageType.video
            ? message.isSender
                ? Row(
                    children: [
                      const ForwardButtonBuilder(),
                      ChatBubbleBuilder(
                        message: message,
                        image: image,
                        name: name,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      ChatBubbleBuilder(
                        message: message,
                        image: image,
                        name: name,
                      ),
                      const ForwardButtonBuilder(),
                    ],
                  )
            : ChatBubbleBuilder(
                message: message,
                image: image,
                name: name,
              ),
      ],
    );
  }
}

class ChatBubbleBuilder extends StatelessWidget {
  const ChatBubbleBuilder({
    Key? key,
    required this.message,
    required this.image,
    required this.name,
  }) : super(key: key);

  final ChatMessage message;
  final String image, name;

  @override
  Widget build(BuildContext context) {
    Widget messageType(ChatMessage message, String image) {
      if (message.messageType == ChatMessageType.text) {
        return TextMessage(message: message);
      } else {
        return Container();
      }
    }

    return Row(
      mainAxisAlignment:
          message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 10,
            right: 20 * 0.8,
            left: 20 * 0.8,
          ),
          decoration: BoxDecoration(
            color: message.isSender
                ? Theme.of(context).focusColor
                : Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(20 * 1.4),
          ),
          child: messageType(
            message,
            image,
          ),
        ),
      ],
    );
  }
}

class ForwardButtonBuilder extends StatelessWidget {
  const ForwardButtonBuilder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: Colors.amber),
        ),
        Container(
          height: 23.0,
          width: 23.0,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/arrow.png"),
              fit: BoxFit.scaleDown,
              invertColors: true,
            ),
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

enum ChatMessageType { text, audio, image, video }

class ChatMessage {
  final String text, time;
  final String duration;
  final ChatMessageType messageType;
  final bool isSender;

  ChatMessage({
    this.text = '',
    this.time = '',
    this.duration = '',
    required this.messageType,
    required this.isSender,
  });
}

List chatMessagesData = [
  ChatMessage(
    text: "Sure!",
    time: "6:12 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "I'll surely join you next time.",
    time: "6:16 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "dscscddsc",
    time: "6:18 pm",
    duration: "0:41",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "xcv xc xc ",
    time: "6:25 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "This look mesmerizing.",
    time: "6:32 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Watched sunset!",
    time: "6:52 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "xc xc cx xc xc ",
    time: "6:57 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "Send me pictures.",
    time: "6:12 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "You also went to beach?",
    time: "6:16 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "zxczxczxc",
    time: "6:18 pm",
    duration: "0:29",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "zxczxc",
    time: "6:32 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Beutiful video.",
    time: "6:52 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "Glad you like it.",
    time: "6:57 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Oh wow!!",
    time: "6:12 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "5000ft above sea level.",
    time: "6:16 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Okay wait.",
    time: "6:32 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Send me pictures and videos.",
    time: "6:52 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "Yes I did.",
    time: "6:57 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Sounds like you had  alot of fun.",
    time: "6:12 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "Listen this..",
    time: "6:16 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Did you enjoy your trip?",
    time: "6:25 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "I am great.",
    time: "6:32 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
  ChatMessage(
    text: "Hello. How are you?",
    time: "6:52 pm",
    messageType: ChatMessageType.text,
    isSender: false,
  ),
  ChatMessage(
    text: "Hi! Ali Asar.",
    time: "6:57 pm",
    messageType: ChatMessageType.text,
    isSender: true,
  ),
];
