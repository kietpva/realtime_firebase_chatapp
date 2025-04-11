part of 'auth_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

final class AuthState extends Equatable {
  const AuthState({UserModel? user, String? fcmToken})
      : this._(
          status: user == UserModel.empty
              ? AppStatus.unauthenticated
              : AppStatus.authenticated,
          user: user,
          fcmToken: fcmToken,
        );

  const AuthState._({
    required this.status,
    this.user = UserModel.empty,
    this.fcmToken,
  });

  final AppStatus status;
  final String? fcmToken;
  final UserModel? user;

  @override
  List<Object?> get props => [status, user, fcmToken];
}
