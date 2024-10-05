import 'package:chat_app_task/screens/auth/bloc/auth_bloc.dart';
import 'package:chat_app_task/screens/auth/login_screen.dart';
import 'package:chat_app_task/screens/auth/registers_screen.dart';
import 'package:chat_app_task/firebase_options.dart';
import 'package:chat_app_task/screens/chat/bloc/chat_bloc.dart';
import 'package:chat_app_task/screens/home/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AuthBloc()),
         BlocProvider(create: (_) => ChatBloc()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.black,
                  titleTextStyle: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  )),
              useMaterial3: true,
            ),
            routes: <String, WidgetBuilder>{
              '/loginScreen': (BuildContext context) => const LoginScreen(),
              '/registerScreen': (BuildContext context) =>
                  const RegisterScreen(),
              '/homeScreen': (BuildContext context) => HomeScreen(),
            },
            home: const LoginScreen()),
      ),
    );
  }
}
