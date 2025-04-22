import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/data/auth_bloc/auth_bloc.dart';
import 'package:realtime_firebase_chatapp/data/repositories/auth_repository.dart';

class AppProvider extends StatelessWidget {
  const AppProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<FirebaseFirestore>(
          lazy: false,
          create: (context) => FirebaseFirestore.instance,
        ),
        RepositoryProvider<FirebaseAuth>(
          lazy: false,
          create: (context) => FirebaseAuth.instance,
        ),
        RepositoryProvider<AuthRepository>(
          lazy: false,
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            lazy: true,
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            )..add(const AuthCheckAuthentication()),
          ),
        ],
        child: child,
      ),
    );
  }
}
