// auth_bloc/auth_bloc.dart
import 'package:chat_app_task/screens/auth/bloc/auth_event.dart';
import 'package:chat_app_task/screens/auth/bloc/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthBloc() : super(AuthInitial()) {
    // Handle LoginEvent
    on<LoginEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        _firestore.collection("users").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': event.email,
          },
          SetOptions(merge: true),
        );
        emit(
          Authenticated(),
        );
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    // Handle RegisterEvent
    on<RegisterEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: event.email,
          password: event.password,
        );
        _firestore.collection("users").doc(userCredential.user!.uid).set(
          {
            'uid': userCredential.user!.uid,
            'email': event.email,
            'name': event.name, // Store the user's name

            'status': 'online',
          },
        );
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
