import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/data/auth_bloc/auth_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomBlurAppBar(
        title: const Text("Chats"),
        actions: [
          InkWell(
            onTap: () async {
              context.read<AuthBloc>().add(const AuthLogoutPressed());
            },
            child: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
    );
  }
}

class CustomBlurAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomBlurAppBar({super.key, this.actions, this.title});
  final List<Widget>? actions;
  final Widget? title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: title,
      actions: actions,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}
