import 'package:chat_app_task/extensions/sized_box_extension.dart';
import 'package:chat_app_task/helpers/image_helper.dart';
import 'package:chat_app_task/screens/auth/bloc/auth_bloc.dart';
import 'package:chat_app_task/screens/auth/bloc/auth_event.dart';
import 'package:chat_app_task/screens/auth/bloc/auth_state.dart';
import 'package:chat_app_task/widgets/my_button.dart';
import 'package:chat_app_task/widgets/my_text_field.dart';
import 'package:chat_app_task/widgets/title_builder.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with ImageHelper {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/homeScreen');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            shrinkWrap: true,
            children: [
              60.height,
              const Text(
                "Welcome Back",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              15.height,
              const Text(
                "Login now and lets chat",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              ),
              15.height,
              const TitleBuilder(
                text: "Email",
              ),
              MyTextField(
                controller: emailController,
                hint: "abc@gmail.com",
                prefixIcon: "email",
              ),
              10.height,
              const TitleBuilder(
                text: "Password",
              ),
              MyTextField(
                controller: passwordController,
                hint: "********",
                prefixIcon: "lock",
                obscure: true,
              ),
              40.height,
              MyButton(
                filled: true,
                fillColor: Colors.black,
                text: " Login",
                width: double.infinity,
                height: 50,
                onTap: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    LoginEvent(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                    ),
                  );
                },
              ),
              10.height,
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account?"),
                      TextSpan(
                        text: "   Create an account",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, "/registerScreen");
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
