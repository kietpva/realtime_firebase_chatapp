import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realtime_firebase_chatapp/core/app/app_provider.dart';
import 'package:realtime_firebase_chatapp/core/app/app_router.dart';
import 'package:realtime_firebase_chatapp/core/themes/theme.dart';
import 'package:realtime_firebase_chatapp/screens/login/view/login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AppProvider(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: FocusManager.instance.primaryFocus?.unfocus,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: context.read<AppRouter>().navigatorKey,
        theme: theme,
        home: const LoginScreen(),
      ),
    );
  }
}
