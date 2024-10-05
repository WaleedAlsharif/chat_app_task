import 'package:chat_app_task/screens/chat/bloc/chat_event.dart';
import 'package:chat_app_task/screens/chat/bloc/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ChatBloc() : super(ChatInitial()) {
    on<SendMessageEvent>((event, emit) async {
      try {
        // Create a unique chat ID between the sender and receiver
        String chatId = generateChatId(event.senderId, event.receiverId);

        // Send message to Firestore asynchronously
        await _firestore
            .collection('chats')
            .doc(chatId)
            .collection('messages')
            .add({
          'senderId': event.senderId,
          'receiverId': event.receiverId,
          'message': event.message,
          'timestamp': FieldValue.serverTimestamp(),
       
        });

        // Ensure emit is called after asynchronous operation
        emit(MessageSent());
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<LoadMessagesEvent>((event, emit) async {
      try {
        print('Loading messages for chatId: ${event.chatId}'); // Debugging

        // Listening to Firestore stream and emitting messages
        await _firestore
            .collection('chats')
            .doc(event.chatId)
            .collection('messages')
            .orderBy('timestamp')
            .snapshots()
            .listen((snapshot) {
          var messages = snapshot.docs.map((doc) => doc.data()).toList();

          print('Loaded messages: ${messages.length}'); // Debugging

          // Emit the loaded messages
          emit(MessagesLoaded(messages));
        }).asFuture(); // Convert to Future to await the operation
      } catch (e) {
        emit(ChatError(e.toString()));
        print('Error loading messages: $e'); // Debugging
      }
    });
  }

  // Helper function to generate a unique chat ID between two users
  String generateChatId(String senderId, String receiverId) {
    return senderId.hashCode <= receiverId.hashCode
        ? '$senderId-$receiverId'
        : '$receiverId-$senderId';
  }
}
