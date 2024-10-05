// chat_bloc/chat_state.dart
abstract class ChatState {}

class ChatInitial extends ChatState {}

class MessageSent extends ChatState {}

class MessagesLoaded extends ChatState {
  final List messages;

  MessagesLoaded(this.messages);
}

class ChatError extends ChatState {
  final String message;

  ChatError(this.message);
}
