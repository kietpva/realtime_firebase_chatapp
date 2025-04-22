import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:realtime_firebase_chatapp/core/router/router_guard.dart';
import 'package:realtime_firebase_chatapp/screens/home/home_screen.dart';
import 'package:realtime_firebase_chatapp/screens/login/view/login_screen.dart';
import 'package:realtime_firebase_chatapp/screens/sign_up/view/sign_up_screen.dart';

class AppRouter {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final authNotifier = AuthNotifier();

  static final router = GoRouter(
    debugLogDiagnostics: kDebugMode,
    initialLocation: AppPaths.home.path,
    navigatorKey: rootNavigatorKey,
    refreshListenable: authNotifier,
    routes: [
      GoRoute(
        name: AppPaths.login.name,
        path: AppPaths.login.path,
        builder: (_, state) => const LoginScreen(),
      ),
      GoRoute(
        name: AppPaths.sigunUp.name,
        path: AppPaths.sigunUp.path,
        builder: (_, state) => const SignUpScreen(),
      ),
      GoRoute(
        name: AppPaths.home.name,
        path: AppPaths.home.path,
        builder: (_, state) => const HomeScreen(),
      ),
    ],
    errorBuilder: (_, state) =>
        const Scaffold(body: Center(child: Text('Error: No route found'))),
    redirect: (_, state) {
      return RouterGuard.authGuard(state);
    },
  );
}

enum AppPaths {
  home(name: 'home', path: '/'),
  login(name: 'login', path: '/login'),
  sigunUp(name: 'sign-up', path: '/sign-up'),
  chat(name: 'chat', path: '/chat');

  const AppPaths({required this.name, required this.path});

  /// Represents the route name
  ///
  /// Example: `AppRoutes.login.name`
  /// Returns: 'login'
  final String name;

  /// Represents the route path
  ///
  /// Example: `AppRoutes.login.path`
  /// Returns: '/login'
  final String path;

  @override
  String toString() => name;
}

class AuthNotifier extends ChangeNotifier {
  AuthNotifier() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      notifyListeners();
    });
  }
}
