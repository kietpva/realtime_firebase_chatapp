import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/data/repositories/auth_repository.dart';
import 'package:realtime_firebase_chatapp/screens/sign_up/cubit/sign_up_cubit.dart';
import 'package:realtime_firebase_chatapp/screens/sign_up/view/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthRepository>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}
