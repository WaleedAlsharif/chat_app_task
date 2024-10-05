import 'package:chat_app_task/extensions/sized_box_extension.dart';
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

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            Navigator.pushReplacementNamed(context, '/homeScreen');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            shrinkWrap: true,
            children: [
              60.height,
              const Text(
                "Create an account now !",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              15.height,
              const TitleBuilder(
                text: "Name",
              ),
              MyTextField(
                controller: nameController,
                prefixIcon: "user",
                hint: "full name",
              ),
              10.height,
              const TitleBuilder(
                text: "email",
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
              ),
              30.height,
              MyButton(
                filled: true,
                fillColor: Colors.black,
                text: "Register",
                width: double.infinity,
                height: 50,
                onTap: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    RegisterEvent(
                      emailController.text.trim(),
                      passwordController.text.trim(),
                      nameController.text,
                    ),
                  );
                },
              ),
              15.height,
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    children: [
                      const TextSpan(text: "Do you already have an account?"),
                      TextSpan(
                        text: "  Login ",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, "/loginScreen");
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
