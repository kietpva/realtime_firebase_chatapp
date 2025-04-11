import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/data/repositories/auth_repository.dart';
import 'package:realtime_firebase_chatapp/screens/login/cubit/login_cubit.dart';
import 'package:realtime_firebase_chatapp/screens/login/view/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: SingleChildScrollView(
              child: BlocProvider(
                create: (_) => LoginCubit(context.read<AuthRepository>()),
                child: const LoginForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
