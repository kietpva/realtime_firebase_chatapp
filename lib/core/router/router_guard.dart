import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:realtime_firebase_chatapp/core/router/app_router.dart';

class RouterGuard {
  static Future<String?> authGuard(GoRouterState state) async {
    final unAuthenList = [
      state.namedLocation(AppPaths.login.name),
      state.namedLocation(AppPaths.sigunUp.name),
    ];

    final currentUser = FirebaseAuth.instance.currentUser != null;

    if (currentUser && unAuthenList.contains(state.matchedLocation)) {
      return state.namedLocation(AppPaths.home.name);
    }

    if (unAuthenList.contains(state.matchedLocation)) {
      return null;
    }

    if (!currentUser) {
      return state.namedLocation(AppPaths.login.name);
    }
    return null;
  }
}
