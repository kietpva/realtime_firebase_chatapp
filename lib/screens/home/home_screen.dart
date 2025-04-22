import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/core/widgets/chat_list_tile.dart';
import 'package:realtime_firebase_chatapp/data/auth_bloc/auth_bloc.dart';
import 'package:realtime_firebase_chatapp/data/repositories/chat_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _currentUserId;
  @override
  void initState() {
    _currentUserId = FirebaseAuth.instance.currentUser?.uid ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CustomBlurAppBar(
        title: const Text("Home"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: InkWell(
              onTap: () async {
                context.read<AuthBloc>().add(const AuthLogoutPressed());
              },
              child: const Icon(Icons.logout),
            ),
          )
        ],
      ),
      body: StreamBuilder(
          stream: context.read<ChatRepository>().getChatRooms(_currentUserId),
          builder: (_, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text("error:${snapshot.error}"),
              );
            }
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final chats = snapshot.data!;
            if (chats.isEmpty) {
              return const Center(
                child: Text("No recent chats"),
              );
            }
            return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (_, index) {
                  final chat = chats[index];
                  return ChatListTile(
                    chat: chat,
                    currentUserId: _currentUserId,
                    onTap: () {
                      final otherUserId = chat.participants
                          .firstWhere((id) => id != _currentUserId);
                      print(
                          "home screen current user id ${context.read<AuthBloc>().state.user?.uid ?? ''}");
                      final outherUserName =
                          chat.participantsName?[otherUserId] ?? "Unknown";
                      // TODO(Kiet Pham): navigate to chat screen
                    },
                  );
                });
          }),
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
