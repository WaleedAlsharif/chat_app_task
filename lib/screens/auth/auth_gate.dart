// import 'package:chat_app_task/screens/auth/login_screen.dart';
// import 'package:chat_app_task/screens/home/home_screen.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: StreamBuilder(
//         stream: FirebaseAuth.instance.authStateChanges(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             // user is logeed in
//             return const HomeScreen();
//           } else {
//             // user is not logged in
//             return const LoginScreen();
//           }
//         },
//       ),
//     );
//   }
// }
