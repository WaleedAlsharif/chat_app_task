// auth_bloc/auth_bloc.dart
import 'package:chat_app_task/screens/auth/bloc/auth_event.dart';
import 'package:chat_app_task/screens/auth/bloc/auth_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with WidgetsBindingObserver {
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
            "status": 'online',
            "lastSeen": FieldValue.serverTimestamp(),
            "isTyping": false
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
            "status": "online",
            "lastSeen": FieldValue.serverTimestamp(),
            "isTyping": false
          },
        );
        emit(Authenticated());
      } catch (e) {
        emit(
          AuthError(
            e.toString(),
          ),
        );
      }
    });

    // Handle LogoutEvent
    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        // Set the user status to offline when logging out
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'status': 'offline', // offline
          'lastSeen': FieldValue.serverTimestamp(),
        });

        await _auth.signOut();
        emit(AuthInitial()); // Go back to the initial state after logout
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    void setUserStatus(bool isOnline) async {
      if (_auth.currentUser != null) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .update({
          'status': isOnline, // online/offline
          'lastSeen': FieldValue.serverTimestamp(),
        });
      }
    }

    // Handle app lifecycle changes to update online/offline status
    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
      if (_auth.currentUser != null) {
        if (state == AppLifecycleState.paused ||
            state == AppLifecycleState.detached) {
          // User goes offline when the app is in the background or closed
          setUserStatus(false);
        } else if (state == AppLifecycleState.resumed) {
          // User comes online when the app is resumed
          setUserStatus(true);
        }
      }
    }

    @override
    Future<void> close() {
      WidgetsBinding.instance.removeObserver(this);
      return super.close();
    }
  }
}
