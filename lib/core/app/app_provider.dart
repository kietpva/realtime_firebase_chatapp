import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/core/app/app_router.dart';
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
          lazy: true,
          create: (context) => FirebaseFirestore.instance,
        ),
        RepositoryProvider<AppRouter>(
          lazy: true,
          create: (context) => AppRouter(),
        ),
        RepositoryProvider<FirebaseAuth>(
          lazy: true,
          create: (context) => FirebaseAuth.instance,
        ),
        RepositoryProvider<AuthRepository>(
          lazy: true,
          create: (context) => AuthRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
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
