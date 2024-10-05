import 'package:chat_app_task/screens/auth/bloc/auth_bloc.dart';
import 'package:chat_app_task/screens/auth/bloc/auth_event.dart';
import 'package:chat_app_task/screens/chat/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>with WidgetsBindingObserver {
 final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  void initState() {
       WidgetsBinding.instance.addObserver(this); // Start observing app lifecycle

    super.initState();
  }

    @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_auth.currentUser != null) {
      final String currentUserId = _auth.currentUser!.uid;
      
      if (state == AppLifecycleState.paused) {
        // App is in background - set user status to offline
        _firestore.collection('users').doc(currentUserId).update({
          'status': 'offline',
        });
      } else if (state == AppLifecycleState.resumed) {
        // App is back to foreground - set user status to online
        _firestore.collection('users').doc(currentUserId).update({
          'status': 'online',
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    // Get the current logged-in user's uid
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("User List"),
        actions: [
          GestureDetector(
            child: Icon(
              Icons.login,
              color: Colors.white,
            ),
            onTap: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutEvent());
              Navigator.pushReplacementNamed(
                  context, '/loginScreen'); // Navigate to login screen
            },
          )
        ],
      ),
      body: StreamBuilder(
        // Fetch all users except the current logged-in user
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // Handle errors or loading state
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // Filter out the logged-in user from the list
          final users = snapshot.data!.docs
              .where((user) => user['uid'] != currentUserId)
              .toList();

          // Display the filtered users in a ListView
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(
              height: 10.h,
            ),
            padding: EdgeInsets.all(10),
            itemCount: users.length,
            itemBuilder: (context, index) {
              var user = users[index];
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xff222222),
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/icons/profile.png"),
                  ),
                  title: Text(
                    user['name'],
                    style: TextStyle(fontSize: 16.sp, color: Colors.white),
                  ),
                  subtitle: Text(
                    user['email'],
                    style: TextStyle(fontSize: 12.sp, color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(
                            reciverName: user['name'],
                            reciverId: user['uid'],
                            senderId: currentUserId),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
