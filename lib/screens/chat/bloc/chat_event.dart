// chat_bloc/chat_event.dart
abstract class ChatEvent {}

class SendMessageEvent extends ChatEvent {
  final String senderId;
  final String receiverId;
  final String message;
  
  SendMessageEvent({
    required this.senderId,
    required this.receiverId,
    required this.message,
  });
}

class LoadMessagesEvent extends ChatEvent {
  final String chatId; // Chat ID (for loading messages in a specific chat)

  LoadMessagesEvent(this.chatId);
}
